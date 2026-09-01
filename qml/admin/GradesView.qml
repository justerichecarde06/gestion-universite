import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    color: "#F3F4F6"
    
    property int currentCourseId: -1
    property var stats: ({"totalStudents": 0, "publishedCount": 0, "publishedPercentage": 0, "average": "--", "maxGrade": "--", "maxStudent": "--", "minGrade": "--", "minStudent": "--"})
    
    property int itemsPerPage: 6
    property int currentPage: 1

    function getAvatarColor(name) {
        let colors = ["#E0E7FF", "#FCE7F3", "#DCFCE7", "#DBEAFE", "#FEE2E2", "#FEF3C7", "#F3E8FF"];
        let charCodeSum = 0;
        for (let i = 0; i < name.length; i++) charCodeSum += name.charCodeAt(i);
        return colors[charCodeSum % colors.length];
    }
    
    function getAvatarTextColor(name) {
        let colors = ["#4338CA", "#BE185D", "#15803D", "#1D4ED8", "#B91C1C", "#B45309", "#7E22CE"];
        let charCodeSum = 0;
        for (let i = 0; i < name.length; i++) charCodeSum += name.charCodeAt(i);
        return colors[charCodeSum % colors.length];
    }
    
    function getLetterGrade(avgStr) {
        if (avgStr === "--") return "";
        let avg = parseFloat(avgStr);
        if (avg >= 90) return "A";
        if (avg >= 80) return "B";
        if (avg >= 70) return "C";
        if (avg >= 60) return "D";
        return "E";
    }

    Component.onCompleted: {
        adminGradeService.loadFaculties();
        if (adminGradeService.faculties.length > 0) {
            facultyCombo.currentIndex = 0;
        } else {
            adminGradeService.loadCourses(""); 
        }
    }
    
    Connections {
        target: adminGradeService
        function onStudentsListChanged() {
            if (currentCourseId !== -1) {
                stats = adminGradeService.getGradeStats(currentCourseId);
                let maxPage = Math.max(1, Math.ceil(adminGradeService.studentsList.length / itemsPerPage));
                if (currentPage > maxPage) currentPage = maxPage;
            }
        }
        function onOperationSuccess(message) {
            toastMsg.text = message;
            toast.open();
        }
        function onOperationError(error) {
            toastMsg.text = "Erreur: " + error;
            toast.open();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 24

        // --- HEADER SECTION ---
        RowLayout {
            Layout.fillWidth: true
            
            Column {
                spacing: 4
                Text {
                    text: "Gestion des Notes"
                    font.family: "Inter"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: "#111827"
                }
                Text {
                    text: "Consultez, saisissez et gérez les notes des étudiants."
                    font.family: "Inter"
                    font.pixelSize: 14
                    color: "#6B7280"
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Filters Group
            RowLayout {
                spacing: 16
                
                // Semester / Faculty
                Rectangle {
                    width: 220; height: 44; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 8
                        Text { text: "🎓"; font.pixelSize: 16; color: "#6B7280" }
                        Column {
                            Layout.fillWidth: true; spacing: 0
                            Text { text: "Filière / Semestre"; font.pixelSize: 11; color: "#9CA3AF" }
                            ComboBox {
                                id: facultyCombo; width: parent.width; height: 20
                                model: adminGradeService.faculties; background: Item {}
                                font.pixelSize: 13; font.weight: Font.Medium; padding: 0; leftPadding: 0
                                onCurrentTextChanged: adminGradeService.loadCourses(currentText)
                            }
                        }
                    }
                }
                
                // Course Filter
                Rectangle {
                    width: 320; height: 44; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 8
                        Text { text: "📄"; font.pixelSize: 16; color: "#6B7280" }
                        Column {
                            Layout.fillWidth: true; spacing: 0
                            Text { text: "Cours"; font.pixelSize: 11; color: "#9CA3AF" }
                            ComboBox {
                                id: courseCombo; width: parent.width; height: 20
                                model: adminGradeService.courses; textRole: "displayName"; valueRole: "id"
                                background: Item {} font.pixelSize: 13; font.weight: Font.Medium; padding: 0; leftPadding: 0
                                onCurrentValueChanged: {
                                    if (currentValue !== undefined) {
                                        currentCourseId = currentValue;
                                        adminGradeService.loadStudents(currentCourseId);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Publish Button
            Rectangle {
                width: 180; height: 44; radius: 8; color: "#2563EB"
                opacity: adminGradeService.studentsList.length > 0 && stats.publishedCount < stats.totalStudents ? 1.0 : 0.5
                RowLayout {
                    anchors.centerIn: parent; spacing: 8
                    Text { text: "📤"; color: "white"; font.pixelSize: 16 }
                    Text { text: "Publier les notes"; color: "white"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.Medium }
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                    enabled: adminGradeService.studentsList.length > 0
                    onEntered: parent.opacity = 0.9; onExited: parent.opacity = 1.0
                    onClicked: {
                        if (currentCourseId !== -1) adminGradeService.publishGrades(currentCourseId);
                    }
                }
            }
        }

        // --- STATS CARDS ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            
            // Enrolled
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#EFF6FF"
                        Text { anchors.centerIn: parent; text: "👥"; font.pixelSize: 22; color: "#3B82F6" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.totalStudents || 0; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Étudiants inscrits"; font.pixelSize: 13; color: "#6B7280" }
                    }
                }
            }
            // Published
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#F0FDF4"
                        Text { anchors.centerIn: parent; text: "📋"; font.pixelSize: 22; color: "#22C55E" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.publishedCount || 0; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Notes publiées"; font.pixelSize: 13; color: "#6B7280" }
                        Text { text: (root.stats.publishedPercentage ? root.stats.publishedPercentage.toFixed(1) : 0) + "%"; font.pixelSize: 11; color: "#9CA3AF" }
                    }
                }
            }
            // Average
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#FFFBEB"
                        Text { anchors.centerIn: parent; text: "📊"; font.pixelSize: 22; color: "#F59E0B" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.average; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Moyenne générale"; font.pixelSize: 13; color: "#6B7280" }
                        Text { text: "/ 100"; font.pixelSize: 11; color: "#9CA3AF" }
                    }
                }
            }
            // Best Grade
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#F5F3FF"
                        Text { anchors.centerIn: parent; text: "⭐"; font.pixelSize: 22; color: "#8B5CF6" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.maxGrade; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Meilleure note"; font.pixelSize: 13; color: "#6B7280" }
                        Text { text: root.stats.maxStudent; font.pixelSize: 11; color: "#9CA3AF"; elide: Text.ElideRight; Layout.maximumWidth: 100 }
                    }
                }
            }
            // Worst Grade
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#FEF2F2"
                        Text { anchors.centerIn: parent; text: "📉"; font.pixelSize: 22; color: "#EF4444" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.minGrade; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Note la plus basse"; font.pixelSize: 13; color: "#6B7280" }
                        Text { text: root.stats.minStudent; font.pixelSize: 11; color: "#9CA3AF"; elide: Text.ElideRight; Layout.maximumWidth: 100 }
                    }
                }
            }
        }

        // --- FILTERS ROW ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Rectangle {
                Layout.preferredWidth: 350; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 8
                    Text { text: "🔍"; color: "#9CA3AF"; font.pixelSize: 14 }
                    TextInput { 
                        id: searchInput
                        Layout.fillWidth: true; clip: true; font.pixelSize: 13; color: "#111827"
                        Text { text: "Rechercher un étudiant, matricule ou examen..."; color: "#9CA3AF"; font.pixelSize: 13; visible: !parent.text && !parent.activeFocus; elide: Text.ElideRight }
                    }
                }
            }
            
            Rectangle {
                Layout.preferredWidth: 140; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                ComboBox { anchors.fill: parent; anchors.margins: 1; background: Item {} model: ["Tous", "Brouillon", "Publié"]; contentItem: Text { text: "Statut: " + parent.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12 } }
            }
            
            Rectangle {
                Layout.preferredWidth: 180; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                ComboBox { anchors.fill: parent; anchors.margins: 1; background: Item {} model: ["Tous", "Oui", "Non"]; contentItem: Text { text: "Statut publication: " + parent.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12 } }
            }
            
            Rectangle {
                Layout.preferredWidth: 180; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                ComboBox { anchors.fill: parent; anchors.margins: 1; background: Item {} model: ["Nom (A-Z)", "Nom (Z-A)", "Moyenne (Max)", "Moyenne (Min)"]; contentItem: Text { text: "Trier par: " + parent.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12 } }
            }
            
            Rectangle {
                Layout.preferredWidth: 90; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                RowLayout { anchors.centerIn: parent; spacing: 6; Text { text: "⚲"; color: "#2563EB"; font.pixelSize: 16 } Text { text: "Filtres"; color: "#2563EB"; font.pixelSize: 13; font.weight: Font.Medium } }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
            }
            
            Rectangle {
                Layout.preferredWidth: 40; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                Text { anchors.centerIn: parent; text: "📥"; color: "#6B7280"; font.pixelSize: 16 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
            }
            
            Item { Layout.fillWidth: true }
        }

        // --- MAIN TABLE ---
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            radius: 12
            border.color: "#E5E7EB"
            border.width: 1
            clip: true
            layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.05; shadowBlur: 10; shadowVerticalOffset: 2 }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Table Header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    color: "white"
                    Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16
                        
                        Text { text: "ÉTUDIANT"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 11; Layout.preferredWidth: 200 }
                        Text { text: "MATRICULE"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 11; Layout.preferredWidth: 120 }
                        Text { text: "EXAMEN"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 11; Layout.preferredWidth: 160 }
                        Text { text: "NOTE INTRA\n(40%)"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 10; Layout.preferredWidth: 80; horizontalAlignment: Text.AlignHCenter; lineHeight: 1.2 }
                        Text { text: "NOTE FINAL\n(60%)"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 10; Layout.preferredWidth: 80; horizontalAlignment: Text.AlignHCenter; lineHeight: 1.2 }
                        Text { text: "MOYENNE\n/ 100"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 10; Layout.preferredWidth: 80; horizontalAlignment: Text.AlignHCenter; lineHeight: 1.2 }
                        Text { text: "LETTRE"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 11; Layout.preferredWidth: 50; horizontalAlignment: Text.AlignHCenter }
                        Text { text: "STATUT"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 11; Layout.preferredWidth: 100 }
                        Text { text: "DATE PUBLICATION"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 11; Layout.preferredWidth: 120 }
                        Text { text: "ACTIONS"; font.weight: Font.Bold; color: "#6B7280"; font.pixelSize: 11; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                    }
                }

                // Table Content
                ListView {
                    id: studentsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    
                    model: {
                        if (!adminGradeService.studentsList) return 0;
                        let start = (root.currentPage - 1) * root.itemsPerPage;
                        let end = Math.min(start + root.itemsPerPage, adminGradeService.studentsList.length);
                        return adminGradeService.studentsList.slice(start, end);
                    }
                    
                    delegate: Rectangle {
                        width: parent.width
                        height: 76
                        color: index % 2 === 0 ? "white" : "#FAFAFA"
                        
                        Rectangle { width: parent.width; height: 1; color: "#F3F4F6"; anchors.bottom: parent.bottom }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16
                            
                            // Etudiant
                            RowLayout {
                                Layout.preferredWidth: 200
                                spacing: 12
                                Rectangle {
                                    width: 36; height: 36; radius: 18
                                    color: getAvatarColor(modelData.name)
                                    Text { anchors.centerIn: parent; text: modelData.initials; color: getAvatarTextColor(modelData.name); font.pixelSize: 13; font.weight: Font.Bold }
                                }
                                ColumnLayout {
                                    spacing: 2
                                    Text { text: modelData.name; font.weight: Font.Medium; color: "#111827"; font.pixelSize: 13; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.name.toLowerCase().replace(" ", ".") + "@usfah.ht"; color: "#6B7280"; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                            
                            // Matricule
                            Text { text: modelData.matricule; color: "#4B5563"; font.pixelSize: 13; Layout.preferredWidth: 120; elide: Text.ElideRight }
                            
                            // Examen
                            ColumnLayout {
                                Layout.preferredWidth: 160
                                spacing: 2
                                Text { text: "Examen 1"; font.weight: Font.Bold; color: "#111827"; font.pixelSize: 13; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: "Session standard"; color: "#6B7280"; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                            
                            // Intra
                            ColumnLayout {
                                Layout.preferredWidth: 80
                                spacing: 2
                                Text { text: modelData.gradeIntra; font.weight: Font.Bold; color: "#111827"; font.pixelSize: 13; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                                Text { text: "/ 100"; color: "#9CA3AF"; font.pixelSize: 11; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                            }
                            
                            // Final
                            ColumnLayout {
                                Layout.preferredWidth: 80
                                spacing: 2
                                Text { text: modelData.gradeFinal; font.weight: Font.Bold; color: "#111827"; font.pixelSize: 13; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                                Text { text: "/ 100"; color: "#9CA3AF"; font.pixelSize: 11; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                            }
                            
                            // Moyenne
                            Rectangle {
                                Layout.preferredWidth: 80
                                height: 28; radius: 14
                                property bool hasGrade: modelData.average !== "--"
                                property bool isPass: hasGrade && parseFloat(modelData.average) >= 60
                                color: !hasGrade ? "#F3F4F6" : (isPass ? "#ECFDF5" : "#FEF2F2")
                                Text { 
                                    anchors.centerIn: parent
                                    text: modelData.average
                                    color: !parent.hasGrade ? "#6B7280" : (parent.isPass ? "#10B981" : "#EF4444")
                                    font.pixelSize: 13; font.weight: Font.Bold 
                                }
                            }
                            
                            // Lettre
                            Text { text: getLetterGrade(modelData.average); font.weight: Font.Bold; color: "#111827"; font.pixelSize: 14; Layout.preferredWidth: 50; horizontalAlignment: Text.AlignHCenter }
                            
                            // Status
                            Rectangle {
                                Layout.preferredWidth: 100; height: 24; radius: 12; color: "transparent"
                                RowLayout {
                                    anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; spacing: 6
                                    Rectangle { width: 8; height: 8; radius: 4; color: modelData.status === "Publié" ? "#10B981" : (modelData.status === "Brouillon" ? "#F59E0B" : "#EF4444") }
                                    Text { text: modelData.status; color: modelData.status === "Publié" ? "#10B981" : (modelData.status === "Brouillon" ? "#F59E0B" : "#EF4444"); font.pixelSize: 12; font.weight: Font.Medium }
                                }
                            }
                            
                            // Date
                            ColumnLayout {
                                Layout.preferredWidth: 120
                                spacing: 2
                                Text { text: modelData.datePublication && modelData.datePublication !== "--" ? modelData.datePublication : "--"; color: "#4B5563"; font.pixelSize: 12; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                            
                            Item { Layout.fillWidth: true }
                            
                            // Actions
                            RowLayout {
                                spacing: 8
                                Layout.alignment: Qt.AlignRight
                                
                                Rectangle {
                                    width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"
                                    Text { anchors.centerIn: parent; text: "✏"; color: "#3B82F6"; font.pixelSize: 14 }
                                    MouseArea { 
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; 
                                        onEntered: parent.color="#F9FAFB"; onExited: parent.color="white"
                                        onClicked: {
                                            gradePopup.enrollmentId = modelData.enrollmentId
                                            gradePopup.studentName = modelData.name
                                            intraInput.text = modelData.gradeIntra === "--" ? "" : modelData.gradeIntra
                                            finalInput.text = modelData.gradeFinal === "--" ? "" : modelData.gradeFinal
                                            gradePopup.open()
                                        }
                                    }
                                }
                                Rectangle {
                                    width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"
                                    Text { anchors.centerIn: parent; text: "⋮"; color: "#4B5563"; font.pixelSize: 16; font.weight: Font.Bold }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color="#F9FAFB"; onExited: parent.color="white" }
                                }
                            }
                        }
                    }
                    
                    Text { anchors.centerIn: parent; text: "Aucun étudiant n'est inscrit à ce cours."; color: "#9CA3AF"; font.pixelSize: 14; visible: adminGradeService.studentsList.length === 0 }
                }
                
                // Pagination Footer
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 60; color: "white"; visible: adminGradeService.studentsList.length > 0
                    Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.top: parent.top }
                    
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 20
                        
                        Text {
                            property int startIdx: (root.currentPage - 1) * root.itemsPerPage + 1
                            property int endIdx: Math.min(root.currentPage * root.itemsPerPage, adminGradeService.studentsList.length)
                            text: "Affichage de " + startIdx + " à " + endIdx + " sur " + adminGradeService.studentsList.length + " étudiants"
                            color: "#6B7280"; font.pixelSize: 13; Layout.fillWidth: true
                        }
                        
                        RowLayout {
                            spacing: 4
                            Rectangle {
                                width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: root.currentPage > 1 ? "white" : "#F9FAFB"
                                Text { anchors.centerIn: parent; text: "<"; color: root.currentPage > 1 ? "#374151" : "#9CA3AF" }
                                MouseArea { anchors.fill: parent; cursorShape: root.currentPage > 1 ? Qt.PointingHandCursor : Qt.ArrowCursor; onClicked: if(root.currentPage > 1) root.currentPage-- }
                            }
                            
                            Rectangle { width: 32; height: 32; radius: 6; color: "#0F172A"; Text { anchors.centerIn: parent; text: root.currentPage; color: "white"; font.weight: Font.Medium } }
                            
                            Rectangle {
                                width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1
                                property bool hasNext: (root.currentPage * root.itemsPerPage) < adminGradeService.studentsList.length
                                color: hasNext ? "white" : "#F9FAFB"
                                Text { anchors.centerIn: parent; text: ">"; color: hasNext ? "#374151" : "#9CA3AF" }
                                MouseArea { anchors.fill: parent; cursorShape: parent.hasNext ? Qt.PointingHandCursor : Qt.ArrowCursor; onClicked: if(parent.hasNext) root.currentPage++ }
                            }
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        RowLayout {
                            spacing: 8
                            Text { text: "Afficher"; color: "#6B7280"; font.pixelSize: 13 }
                            Rectangle {
                                width: 50; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"
                                RowLayout { anchors.centerIn: parent; spacing: 4; Text { text: root.itemsPerPage; color: "#374151"; font.pixelSize: 13 } Text { text: "⌄"; color: "#374151"; font.pixelSize: 14 } }
                            }
                            Text { text: "par page"; color: "#6B7280"; font.pixelSize: 13 }
                        }
                    }
                }
            }
        }
        
        // Info Banner
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            radius: 8
            color: "#EFF6FF"
            border.color: "#BFDBFE"
            border.width: 1
            RowLayout {
                anchors.fill: parent; anchors.margins: 12; spacing: 8
                Text { text: "ℹ️"; font.pixelSize: 14 }
                Text { text: "Pondération : Note Intra (40%) + Note Final (60%) = Moyenne générale / 100"; color: "#1E3A8A"; font.pixelSize: 13; font.weight: Font.Medium; Layout.fillWidth: true }
            }
        }
    }

    // --- GRADE ENTRY POPUP ---
    Popup {
        id: gradePopup
        width: 350
        height: 350
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        property int enrollmentId: -1
        property string studentName: ""
        
        background: Rectangle { color: "white"; radius: 12; layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 15; shadowOpacity: 0.2; shadowColor: "#40000000" } }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            
            Text { text: "Saisir les Notes"; font.family: "Inter"; font.pixelSize: 20; font.weight: Font.Bold; color: "#111827" }
            Text { text: gradePopup.studentName; font.pixelSize: 14; color: "#6B7280"; Layout.bottomMargin: 8 }
            
            ColumnLayout {
                Layout.fillWidth: true; spacing: 8
                Text { text: "Note Intra (sur 100)"; font.pixelSize: 12; font.weight: Font.Medium; color: "#374151" }
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "#F9FAFB"
                    TextInput { id: intraInput; anchors.fill: parent; anchors.margins: 10; font.pixelSize: 14; color: "#111827"; verticalAlignment: TextInput.AlignVCenter; validator: DoubleValidator { bottom: 0; top: 100; decimals: 1 } }
                }
            }
            
            ColumnLayout {
                Layout.fillWidth: true; spacing: 8
                Text { text: "Note Finale (sur 100)"; font.pixelSize: 12; font.weight: Font.Medium; color: "#374151" }
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "#F9FAFB"
                    TextInput { id: finalInput; anchors.fill: parent; anchors.margins: 10; font.pixelSize: 14; color: "#111827"; verticalAlignment: TextInput.AlignVCenter; validator: DoubleValidator { bottom: 0; top: 100; decimals: 1 } }
                }
            }
            
            Item { Layout.fillHeight: true }
            
            RowLayout {
                Layout.fillWidth: true; spacing: 12
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 8; color: "#F3F4F6"
                    Text { text: "Annuler"; color: "#4B5563"; font.weight: Font.Medium; anchors.centerIn: parent }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color = "#E5E7EB"; onExited: parent.color = "#F3F4F6"; onClicked: gradePopup.close() }
                }
                
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 8; color: "#2563EB"
                    Text { text: "Enregistrer"; color: "white"; font.weight: Font.Medium; anchors.centerIn: parent }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.opacity = 0.9; onExited: parent.opacity = 1.0
                        onClicked: {
                            var intra = intraInput.text !== "" ? parseFloat(intraInput.text.replace(",", ".")) : -1;
                            var finalG = finalInput.text !== "" ? parseFloat(finalInput.text.replace(",", ".")) : -1;
                            adminGradeService.saveGrade(gradePopup.enrollmentId, intra, finalG);
                            adminGradeService.loadStudents(currentCourseId);
                            gradePopup.close();
                        }
                    }
                }
            }
        }
    }
    
    // Toast Notification
    Popup {
        id: toast
        y: 40; x: (parent.width - width) / 2; width: toastMsg.implicitWidth + 40; height: 40
        closePolicy: Popup.NoAutoClose
        background: Rectangle { color: "#111827"; radius: 20 }
        Text { id: toastMsg; anchors.centerIn: parent; color: "white"; font.pixelSize: 14 }
        Timer { id: toastTimer; interval: 3000; running: toast.visible; onTriggered: toast.close() }
        enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 } }
        exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 } }
    }
}
