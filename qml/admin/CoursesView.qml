import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    color: "#F3F4F6"
    
    property var courseModel: []
    property var stats: ({"total": 0, "active": 0, "planned": 0, "inactive": 0})
    property int itemsPerPage: 6
    property int currentPage: 1

    function loadData() {
        courseModel = adminCourseService.getCourses(deptFilter.currentText, statusFilter.currentText, searchInput.text);
        stats = adminCourseService.getCourseStats();
        
        // Ensure currentPage is within bounds after a reload
        let maxPage = Math.max(1, Math.ceil(courseModel.length / itemsPerPage));
        if (currentPage > maxPage) {
            currentPage = maxPage;
        }
    }

    Component.onCompleted: loadData()

    Connections {
        target: adminCourseService
        function onCoursesChanged() {
            loadData();
        }
        function onActionSuccess(msg) {
            successBanner.text = msg;
            bannerTimer.start();
        }
    }
    
    Timer {
        id: bannerTimer
        interval: 3000
        onTriggered: successBanner.text = ""
    }

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
                    text: "Gestion des Cours"
                    font.family: "Inter"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: "#111827"
                }
                Text {
                    text: "Gérez l'ensemble des cours et leurs informations."
                    font.family: "Inter"
                    font.pixelSize: 14
                    color: "#6B7280"
                }
            }
            
            Item { Layout.fillWidth: true } // Spacer
            
            // Département Filter
            Rectangle {
                width: 200
                height: 40
                radius: 8
                color: "white"
                border.color: "#E5E7EB"
                border.width: 1
                
                ComboBox {
                    id: deptFilter
                    anchors.fill: parent
                    anchors.margins: 1
                    background: Item {}
                    model: ["Tous", "Informatique", "Mathématiques", "Réseaux", "Génie Logiciel", "Droit"]
                    onCurrentTextChanged: loadData()
                    font.pixelSize: 13
                    contentItem: Text {
                        text: "Département: " + deptFilter.currentText
                        font.pixelSize: 13
                        color: "#374151"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                        elide: Text.ElideRight
                    }
                }
            }
            
            // Add Button
            Rectangle {
                width: 160
                height: 40
                radius: 8
                color: "#1E3A8A" // Dark blue
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    Text { text: "+"; color: "white"; font.pixelSize: 18; font.weight: Font.Bold }
                    Text { text: "Nouveau Cours"; color: "white"; font.family: "Inter"; font.pixelSize: 13; font.weight: Font.Medium }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.opacity = 0.9
                    onExited: parent.opacity = 1.0
                    onClicked: addCoursePopup.open()
                }
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }
        }
        
        Text {
            id: successBanner
            Layout.fillWidth: true
            color: "#059669"
            font.pixelSize: 14
            font.weight: Font.Medium
            visible: text !== ""
        }

        // --- STATS CARDS ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            
            // Total Card
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#EFF6FF"
                        Text { anchors.centerIn: parent; text: "📖"; font.pixelSize: 22; color: "#3B82F6" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.total; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Total des cours"; font.pixelSize: 13; color: "#6B7280" }
                        Text { text: "Tous départements"; font.pixelSize: 11; color: "#9CA3AF" }
                    }
                }
            }
            // Active Card
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#F0FDF4"
                        Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 22; color: "#22C55E"; font.weight: Font.Bold }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.active; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Cours actifs"; font.pixelSize: 13; color: "#6B7280" }
                        Text { text: (root.stats.total > 0 ? Math.round((root.stats.active/root.stats.total)*100) : 0) + "% du total"; font.pixelSize: 11; color: "#9CA3AF" }
                    }
                }
            }
            // Planned Card
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#F5F3FF"
                        Text { anchors.centerIn: parent; text: "📅"; font.pixelSize: 22; color: "#8B5CF6" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.planned; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Planifiés"; font.pixelSize: 13; color: "#6B7280" }
                        Text { text: "À venir"; font.pixelSize: 11; color: "#9CA3AF" }
                    }
                }
            }
            // Inactive Card
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 90
                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12; color: "#FFF7ED"
                        Text { anchors.centerIn: parent; text: "⏸"; font.pixelSize: 22; color: "#F97316"; font.weight: Font.Bold }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.inactive; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Inactifs"; font.pixelSize: 13; color: "#6B7280" }
                        Text { text: (root.stats.total > 0 ? Math.round((root.stats.inactive/root.stats.total)*100) : 0) + "% du total"; font.pixelSize: 11; color: "#9CA3AF" }
                    }
                }
            }
        }

        // --- FILTERS ROW ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            // Search
            Rectangle {
                Layout.preferredWidth: 250
                Layout.preferredHeight: 40
                radius: 8
                color: "white"
                border.color: "#E5E7EB"
                border.width: 1
                RowLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 8
                    Text { text: "🔍"; color: "#9CA3AF"; font.pixelSize: 14 }
                    TextInput { 
                        id: searchInput
                        Layout.fillWidth: true; clip: true
                        font.pixelSize: 13; color: "#111827"
                        Text { text: "Rechercher..."; color: "#9CA3AF"; font.pixelSize: 13; visible: !parent.text && !parent.activeFocus }
                        onAccepted: loadData()
                    }
                }
            }
            
            // Status Dropdown
            Rectangle {
                Layout.preferredWidth: 150; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                ComboBox {
                    id: statusFilter
                    anchors.fill: parent; anchors.margins: 1; background: Item {}
                    model: ["Tous", "Actif", "Planifié", "Inactif"]
                    onCurrentTextChanged: loadData()
                    contentItem: Text { text: "Statut: " + statusFilter.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12; elide: Text.ElideRight }
                }
            }
            
            // Level Dropdown (Visual only for now)
            Rectangle {
                Layout.preferredWidth: 140; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                ComboBox {
                    anchors.fill: parent; anchors.margins: 1; background: Item {}
                    model: ["Tous", "L1", "L2", "L3", "M1", "M2"]
                    contentItem: Text { text: "Niveau: " + parent.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12; elide: Text.ElideRight }
                }
            }
            
            // Filter Button
            Rectangle {
                Layout.preferredWidth: 100; Layout.preferredHeight: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                RowLayout {
                    anchors.centerIn: parent; spacing: 6
                    Text { text: "⚲"; color: "#374151"; font.pixelSize: 16 }
                    Text { text: "Filtrer"; color: "#374151"; font.pixelSize: 13; font.weight: Font.Medium }
                }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: loadData() }
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
                    color: "#0F172A" // Dark Blue Header
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16
                        
                        Text { text: "COURS"; font.weight: Font.Bold; color: "white"; font.pixelSize: 11; Layout.preferredWidth: 250; Layout.fillWidth: true }
                        Text { text: "ENSEIGNANT"; font.weight: Font.Bold; color: "white"; font.pixelSize: 11; Layout.preferredWidth: 180 }
                        Text { text: "DÉPARTEMENT"; font.weight: Font.Bold; color: "white"; font.pixelSize: 11; Layout.preferredWidth: 130 }
                        Text { text: "CRÉDITS"; font.weight: Font.Bold; color: "white"; font.pixelSize: 11; Layout.preferredWidth: 70; horizontalAlignment: Text.AlignHCenter }
                        Text { text: "ÉTUDIANTS"; font.weight: Font.Bold; color: "white"; font.pixelSize: 11; Layout.preferredWidth: 100 }
                        Text { text: "STATUT"; font.weight: Font.Bold; color: "white"; font.pixelSize: 11; Layout.preferredWidth: 90 }
                        Text { text: "ACTIONS"; font.weight: Font.Bold; color: "white"; font.pixelSize: 11; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                    }
                }

                // Table Content
                ListView {
                    id: courseList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    
                    model: {
                        if (!root.courseModel) return 0;
                        let start = (root.currentPage - 1) * root.itemsPerPage;
                        let end = Math.min(start + root.itemsPerPage, root.courseModel.length);
                        return root.courseModel.slice(start, end);
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
                            
                            // Course Info
                            RowLayout {
                                Layout.preferredWidth: 250
                                Layout.fillWidth: true
                                spacing: 12
                                
                                Rectangle {
                                    width: 54; height: 26; radius: 4
                                    color: (modelData.themeColor || "#3B82F6") + "20" // 20% opacity
                                    Text { 
                                        anchors.centerIn: parent
                                        text: modelData.code
                                        color: modelData.themeColor || "#3B82F6"
                                        font.pixelSize: 12; font.weight: Font.Bold
                                    }
                                }
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    Text { text: modelData.title; font.weight: Font.Bold; color: "#111827"; font.pixelSize: 13; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.description || "Aucune description"; color: "#6B7280"; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                            
                            // Enseignant
                            RowLayout {
                                Layout.preferredWidth: 180
                                spacing: 10
                                
                                Rectangle {
                                    width: 32; height: 32; radius: 16
                                    color: getAvatarColor(modelData.profName)
                                    Text { 
                                        anchors.centerIn: parent
                                        text: modelData.profName !== "Non assigné" ? (modelData.profName.replace("Dr. ", "").charAt(0)) : "?"
                                        color: getAvatarTextColor(modelData.profName)
                                        font.pixelSize: 12; font.weight: Font.Bold
                                    }
                                }
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    Text { text: modelData.profName; font.weight: Font.Medium; color: "#374151"; font.pixelSize: 13; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.profEmail || "Non assigné"; color: "#6B7280"; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                            
                            // Departement
                            Text { text: modelData.filiere; color: "#4B5563"; font.pixelSize: 13; Layout.preferredWidth: 130; elide: Text.ElideRight }
                            
                            // Credits
                            Text { text: modelData.credits; color: "#111827"; font.pixelSize: 14; font.weight: Font.Bold; Layout.preferredWidth: 70; horizontalAlignment: Text.AlignHCenter }
                            
                            // Etudiants
                            RowLayout {
                                Layout.preferredWidth: 100
                                spacing: 6
                                Text { text: "👥"; color: "#6B7280"; font.pixelSize: 14 }
                                Column {
                                    spacing: 2
                                    Text { 
                                        text: "<font color='#111827'><b>" + modelData.enrolled + "</b></font> <font color='#6B7280'>/ " + modelData.capacity + "</font>"
                                        font.pixelSize: 12
                                        textFormat: Text.RichText
                                    }
                                }
                            }
                            
                            // Status
                            Rectangle {
                                Layout.preferredWidth: 90
                                height: 24; radius: 12; color: "transparent"
                                RowLayout {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    spacing: 6
                                    Rectangle {
                                        width: 8; height: 8; radius: 4
                                        color: modelData.status === "Actif" ? "#10B981" : (modelData.status === "Planifié" ? "#F59E0B" : "#EF4444")
                                    }
                                    Text { 
                                        text: modelData.status
                                        color: modelData.status === "Actif" ? "#10B981" : (modelData.status === "Planifié" ? "#F59E0B" : "#EF4444")
                                        font.pixelSize: 12; font.weight: Font.Medium 
                                    }
                                }
                            }
                            
                            // Actions
                            RowLayout {
                                spacing: 6
                                Layout.preferredWidth: 120
                                Layout.alignment: Qt.AlignRight
                                
                                Rectangle {
                                    width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"
                                    Text { anchors.centerIn: parent; text: "👁"; color: "#4B5563"; font.pixelSize: 14 }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color="#F9FAFB"; onExited: parent.color="white" }
                                }
                                Rectangle {
                                    width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"
                                    Text { anchors.centerIn: parent; text: "✏"; color: "#3B82F6"; font.pixelSize: 14 }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color="#F9FAFB"; onExited: parent.color="white" }
                                }
                                Rectangle {
                                    width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"
                                    Text { anchors.centerIn: parent; text: "⋮"; color: "#4B5563"; font.pixelSize: 16; font.weight: Font.Bold }
                                    MouseArea { 
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; 
                                        onEntered: parent.color="#F9FAFB"; onExited: parent.color="white"
                                        onClicked: {
                                            actionMenu.modelDataId = modelData.id
                                            actionMenu.popup()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Aucun cours trouvé."
                        color: "#9CA3AF"
                        font.pixelSize: 14
                        visible: root.courseModel.length === 0
                    }
                }
                
                // Pagination Footer
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    color: "white"
                    visible: root.courseModel.length > 0
                    
                    Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.top: parent.top }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        
                        Text {
                            property int startIdx: (root.currentPage - 1) * root.itemsPerPage + 1
                            property int endIdx: Math.min(root.currentPage * root.itemsPerPage, root.courseModel.length)
                            text: "Affichage de " + startIdx + " à " + endIdx + " sur " + root.courseModel.length + " cours"
                            color: "#6B7280"
                            font.pixelSize: 13
                            Layout.fillWidth: true
                        }
                        
                        RowLayout {
                            spacing: 4
                            
                            Rectangle {
                                width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: root.currentPage > 1 ? "white" : "#F9FAFB"
                                Text { anchors.centerIn: parent; text: "<"; color: root.currentPage > 1 ? "#374151" : "#9CA3AF" }
                                MouseArea { anchors.fill: parent; cursorShape: root.currentPage > 1 ? Qt.PointingHandCursor : Qt.ArrowCursor; onClicked: if(root.currentPage > 1) root.currentPage-- }
                            }
                            
                            Rectangle {
                                width: 32; height: 32; radius: 6; color: "#0F172A"
                                Text { anchors.centerIn: parent; text: root.currentPage; color: "white"; font.weight: Font.Medium }
                            }
                            
                            Rectangle {
                                width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1
                                property bool hasNext: (root.currentPage * root.itemsPerPage) < root.courseModel.length
                                color: hasNext ? "white" : "#F9FAFB"
                                Text { anchors.centerIn: parent; text: ">"; color: hasNext ? "#374151" : "#9CA3AF" }
                                MouseArea { anchors.fill: parent; cursorShape: parent.hasNext ? Qt.PointingHandCursor : Qt.ArrowCursor; onClicked: if(parent.hasNext) root.currentPage++ }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // --- CONTEXT MENU FOR ACTIONS ---
    Menu {
        id: actionMenu
        property int modelDataId: -1
        
        MenuItem {
            text: "Éditer le cours"
            font.pixelSize: 13
            onTriggered: console.log("Édition non implémentée pour l'ID", actionMenu.modelDataId)
        }
        MenuItem {
            text: "Supprimer le cours"
            font.pixelSize: 13
            onTriggered: {
                if (actionMenu.modelDataId !== -1) {
                    adminCourseService.deleteCourse(actionMenu.modelDataId)
                }
            }
        }
    }

    // --- ADD COURSE POPUP ---
    Popup {
        id: addCoursePopup
        width: 450
        height: 520
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle {
            color: "white"
            radius: 12
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 15; shadowOpacity: 0.15; shadowColor: "#000000" }
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            
            Text {
                text: "Ajouter un Cours"
                font.family: "Inter"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: "#111827"
            }
            
            // Code & Title Fields
            RowLayout {
                Layout.fillWidth: true
                spacing: 16
                ColumnLayout {
                    Layout.preferredWidth: 100
                    spacing: 8
                    Text { text: "Code"; font.pixelSize: 12; font.weight: Font.Medium; color: "#374151" }
                    Rectangle {
                        Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "#F9FAFB"
                        TextInput { id: codeInput; anchors.fill: parent; anchors.margins: 10; font.pixelSize: 14; color: "#111827"; verticalAlignment: TextInput.AlignVCenter; clip: true }
                    }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "Titre du Cours"; font.pixelSize: 12; font.weight: Font.Medium; color: "#374151" }
                    Rectangle {
                        Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "#F9FAFB"
                        TextInput { id: titleInput; anchors.fill: parent; anchors.margins: 10; font.pixelSize: 14; color: "#111827"; verticalAlignment: TextInput.AlignVCenter; clip: true }
                    }
                }
            }
            
            // Subtitle / Description
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Text { text: "Description / Sous-titre"; font.pixelSize: 12; font.weight: Font.Medium; color: "#374151" }
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "#F9FAFB"
                    TextInput { id: descInput; anchors.fill: parent; anchors.margins: 10; font.pixelSize: 14; color: "#111827"; verticalAlignment: TextInput.AlignVCenter; clip: true }
                }
            }
            
            // Filière Dropdown
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Text { text: "Département"; font.pixelSize: 12; font.weight: Font.Medium; color: "#374151" }
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "#F9FAFB"
                    ComboBox {
                        id: filiereInput; anchors.fill: parent; anchors.margins: 1; background: Item {}
                        model: ["Informatique", "Mathématiques", "Réseaux", "Génie Logiciel", "Droit"]
                        contentItem: Text { text: filiereInput.currentText; font.pixelSize: 14; color: "#111827"; verticalAlignment: Text.AlignVCenter; leftPadding: 10 }
                    }
                }
            }
            
            // Credits & Capacity Fields
            RowLayout {
                Layout.fillWidth: true
                spacing: 16
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "Crédits"; font.pixelSize: 12; font.weight: Font.Medium; color: "#374151" }
                    Rectangle {
                        Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "#F9FAFB"
                        TextInput { id: creditsInput; text: "3"; anchors.fill: parent; anchors.margins: 10; font.pixelSize: 14; color: "#111827"; verticalAlignment: TextInput.AlignVCenter; clip: true; validator: IntValidator {bottom: 1; top: 10} }
                    }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "Capacité Max"; font.pixelSize: 12; font.weight: Font.Medium; color: "#374151" }
                    Rectangle {
                        Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "#F9FAFB"
                        TextInput { id: capacityInput; text: "50"; anchors.fill: parent; anchors.margins: 10; font.pixelSize: 14; color: "#111827"; verticalAlignment: TextInput.AlignVCenter; clip: true; validator: IntValidator {bottom: 10; top: 500} }
                    }
                }
            }
            
            Item { Layout.fillHeight: true } // Spacer
            
            // Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 8; color: "#F3F4F6"
                    Text { text: "Annuler"; color: "#4B5563"; font.weight: Font.Medium; anchors.centerIn: parent }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                        onEntered: parent.color = "#E5E7EB"; onExited: parent.color = "#F3F4F6"
                        onClicked: addCoursePopup.close()
                    }
                }
                
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 8; color: "#1E3A8A"
                    Text { text: "Créer le cours"; color: "white"; font.weight: Font.Medium; anchors.centerIn: parent }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                        onEntered: parent.opacity = 0.9; onExited: parent.opacity = 1.0
                        onClicked: {
                            if (codeInput.text.trim() !== "" && titleInput.text.trim() !== "") {
                                let courseData = {
                                    "code": codeInput.text,
                                    "title": titleInput.text,
                                    "description": descInput.text,
                                    "filiere": filiereInput.currentText,
                                    "credits": parseInt(creditsInput.text) || 3,
                                    "capacity": parseInt(capacityInput.text) || 50,
                                    "status": "Actif",
                                    "themeColor": "#3B82F6",
                                    "profId": 0
                                };
                                adminCourseService.addCourse(courseData);
                                
                                codeInput.text = ""; titleInput.text = ""; descInput.text = "";
                                addCoursePopup.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
