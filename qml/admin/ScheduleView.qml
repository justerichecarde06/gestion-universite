import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent

    function getCardBgColor(type) {
        if (type === "blue") return "#EFF6FF";
        if (type === "orange") return "#FFF7ED";
        if (type === "green") return "#F0FDF4";
        if (type === "purple") return "#F5F3FF";
        if (type === "pink") return "#FDF2F8";
        return "transparent";
    }

    function getCardBorderColor(type) {
        if (type === "blue") return "#3B82F6";
        if (type === "orange") return "#F97316";
        if (type === "green") return "#22C55E";
        if (type === "purple") return "#8B5CF6";
        if (type === "pink") return "#EC4899";
        return "transparent";
    }

    property var scheduleData: [
        { day: 0, time: 0, title: "Algorithmique", prof: "Pr. Jean Baptiste", room: "Salle A101", color: "blue" },
        { day: 1, time: 0, title: "Programmation C", prof: "Pr. David Pierre", room: "Salle A101", color: "orange" },
        { day: 2, time: 0, title: "Base de données", prof: "Pr. Marie Claire", room: "Salle A102", color: "green" },
        { day: 3, time: 0, title: "Réseaux", prof: "Pr. Junior Louis", room: "Salle B201", color: "blue" },
        { day: 4, time: 0, title: "Programmation C", prof: "Pr. David Pierre", room: "Salle A101", color: "orange" },
        { day: 5, time: 0, title: "Mathématiques", prof: "Pr. Smith", room: "Salle A103", color: "purple" },
        
        { day: 0, time: 1, title: "Base de données", prof: "Pr. Marie Claire", room: "Salle A102", color: "green" },
        { day: 1, time: 1, title: "Réseaux", prof: "Pr. Junior Louis", room: "Salle B201", color: "blue" },
        { day: 2, time: 1, title: "Algorithmique", prof: "Pr. Jean Baptiste", room: "Salle A101", color: "blue" },
        { day: 3, time: 1, title: "Mathématiques", prof: "Pr. Smith", room: "Salle A103", color: "purple" },
        { day: 4, time: 1, title: "Algorithmique", prof: "Pr. Jean Baptiste", room: "Salle A101", color: "blue" },
        { day: 5, time: 1, title: "Anglais technique", prof: "Pr. Anna", room: "Salle C301", color: "pink" },
        
        { day: 0, time: 3, title: "Mathématiques", prof: "Pr. Smith", room: "Salle A103", color: "purple" },
        { day: 1, time: 3, title: "Anglais technique", prof: "Pr. Anna", room: "Salle C301", color: "pink" },
        { day: 2, time: 3, title: "Programmation C", prof: "Pr. David Pierre", room: "Salle A101", color: "orange" },
        { day: 3, time: 3, title: "Base de données", prof: "Pr. Marie Claire", room: "Salle A102", color: "green" },
        { day: 4, time: 3, title: "Réseaux", prof: "Pr. Junior Louis", room: "Salle B201", color: "blue" }
    ]

    property var times: ["08:00 - 10:00", "10:00 - 12:00", "12:00 - 14:00", "14:00 - 16:00", "16:00 - 18:00"]
    property var days: ["Lundi\n26 Mai", "Mardi\n27 Mai", "Mercredi\n28 Mai", "Jeudi\n29 Mai", "Vendredi\n30 Mai", "Samedi\n31 Mai"]

    function getEvent(d, t) {
        for (var i = 0; i < scheduleData.length; i++) {
            if (scheduleData[i].day === d && scheduleData[i].time === t) {
                return scheduleData[i];
            }
        }
        return null;
    }

    Rectangle {
        anchors.fill: parent
        color: "#F3F4F6"
        
        ScrollView {
            anchors.fill: parent
            contentWidth: Math.max(width, 1000)
            contentHeight: contentCol.implicitHeight + 60
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ColumnLayout {
                id: contentCol
                width: Math.max(parent.width - 60, 1000)
                x: 30; y: 30
                spacing: 24

                // --- HEADER SECTION ---
                RowLayout {
                    Layout.fillWidth: true
                    
                    Column {
                        spacing: 4
                        Text {
                            text: "Mon Emploi du Temps"
                            font.family: "Inter"
                            font.pixelSize: 28
                            font.weight: Font.Bold
                            color: "#111827"
                        }
                        Text {
                            text: "Gérez et consultez les emplois du temps par programme, niveau et salle."
                            font.family: "Inter"
                            font.pixelSize: 14
                            color: "#6B7280"
                        }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Rectangle {
                        width: 180; height: 44; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                            Column {
                                Layout.fillWidth: true; spacing: 0
                                Text { text: "Année académique"; font.pixelSize: 11; color: "#9CA3AF" }
                                Text { text: "2024-2025"; font.pixelSize: 13; color: "#374151"; font.weight: Font.Medium }
                            }
                            Text { text: "⌄"; color: "#6B7280"; font.pixelSize: 16 }
                        }
                    }
                }

                // --- STATS CARDS ---
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20
                    
                    Component {
                        id: statCardComponent
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 90
                            color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                            layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                            
                            property string iconText: ""
                            property color iconColor: "blue"
                            property color iconBg: "lightblue"
                            property string value: ""
                            property string title: ""
                            property string subtitle: ""
                            property color subtitleColor: "blue"
                            
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 20; spacing: 16
                                Rectangle {
                                    width: 48; height: 48; radius: 12; color: parent.parent.iconBg
                                    Text { anchors.centerIn: parent; text: parent.parent.parent.iconText; font.pixelSize: 22; color: parent.parent.parent.iconColor }
                                }
                                Column {
                                    spacing: 2
                                    Text { text: parent.parent.title; font.pixelSize: 13; color: "#6B7280" }
                                    Text { text: parent.parent.value; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                                    Text { text: parent.parent.subtitle; font.pixelSize: 11; color: parent.parent.subtitleColor }
                                }
                            }
                        }
                    }
                    
                    Loader { sourceComponent: statCardComponent; Layout.fillWidth: true; onLoaded: { item.iconText = "📅"; item.iconColor = "#3B82F6"; item.iconBg = "#EFF6FF"; item.title = "Total Cours"; item.value = "142"; item.subtitle = "Cours programmés"; item.subtitleColor = "#3B82F6" } }
                    Loader { sourceComponent: statCardComponent; Layout.fillWidth: true; onLoaded: { item.iconText = "🏛️"; item.iconColor = "#22C55E"; item.iconBg = "#F0FDF4"; item.title = "Salles"; item.value = "24"; item.subtitle = "Salles disponibles"; item.subtitleColor = "#22C55E" } }
                    Loader { sourceComponent: statCardComponent; Layout.fillWidth: true; onLoaded: { item.iconText = "👥"; item.iconColor = "#8B5CF6"; item.iconBg = "#F5F3FF"; item.title = "Enseignants"; item.value = "38"; item.subtitle = "Enseignants assignés"; item.subtitleColor = "#8B5CF6" } }
                    Loader { sourceComponent: statCardComponent; Layout.fillWidth: true; onLoaded: { item.iconText = "🎓"; item.iconColor = "#F97316"; item.iconBg = "#FFF7ED"; item.title = "Étudiants"; item.value = "1,205"; item.subtitle = "Étudiants concernés"; item.subtitleColor = "#F97316" } }
                }

                // --- FILTERS ROW ---
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 80; radius: 12; color: "white"; border.color: "#E5E7EB"; border.width: 1
                    layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                    
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 20; spacing: 16
                        
                        Column {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: "Programme"; font.pixelSize: 12; color: "#6B7280" }
                            ComboBox { 
                                width: parent.width; height: 36; model: ["Tous les programmes", "Génie Logiciel", "Sciences Comptables", "Génie Civil"]
                                background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6 }
                                contentItem: Text { text: parent.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12 }
                            }
                        }
                        
                        Column {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: "Niveau"; font.pixelSize: 12; color: "#6B7280" }
                            ComboBox { 
                                width: parent.width; height: 36; model: ["Tous les niveaux", "Licence 1", "Licence 2", "Licence 3", "Master 1"]
                                background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6 }
                                contentItem: Text { text: parent.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12 }
                            }
                        }
                        
                        Column {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: "Semestre"; font.pixelSize: 12; color: "#6B7280" }
                            ComboBox { 
                                width: parent.width; height: 36; model: ["Semestre 1", "Semestre 2"]
                                background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6 }
                                contentItem: Text { text: parent.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12 }
                            }
                        }
                        
                        Column {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: "Salle"; font.pixelSize: 12; color: "#6B7280" }
                            ComboBox { 
                                width: parent.width; height: 36; model: ["Toutes les salles", "Salle A101", "Salle A102", "Salle B201"]
                                background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6 }
                                contentItem: Text { text: parent.currentText; font.pixelSize: 13; color: "#374151"; verticalAlignment: Text.AlignVCenter; leftPadding: 12 }
                            }
                        }
                        
                        Rectangle {
                            Layout.preferredWidth: 180; Layout.preferredHeight: 36; radius: 6; color: "#2563EB"
                            Layout.alignment: Qt.AlignBottom
                            RowLayout {
                                anchors.centerIn: parent; spacing: 8
                                Text { text: "📅"; color: "white"; font.pixelSize: 14 }
                                Text { text: "Afficher l'emploi du temps"; color: "white"; font.pixelSize: 13; font.weight: Font.Medium }
                            }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.opacity=0.9; onExited: parent.opacity=1.0 }
                        }
                    }
                }

                // --- MAIN CALENDAR SECTION ---
                Rectangle {
                    Layout.fillWidth: true; Layout.minimumHeight: 600; radius: 12; color: "white"; border.color: "#E5E7EB"; border.width: 1
                    layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.05; shadowBlur: 10; shadowVerticalOffset: 2 }
                    clip: true
                    
                    ColumnLayout {
                        anchors.fill: parent; spacing: 0
                        
                        // Calendar Header
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 60; color: "transparent"
                            Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom }
                            
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 20
                                RowLayout {
                                    spacing: 8
                                    Text { text: "📅"; color: "#3B82F6"; font.pixelSize: 18 }
                                    Text { text: "Vue Hebdomadaire"; font.family: "Inter"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                                }
                                Item { Layout.fillWidth: true }
                                RowLayout {
                                    spacing: 12
                                    Rectangle {
                                        width: 100; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"
                                        Text { anchors.centerIn: parent; text: "Aujourd'hui"; color: "#374151"; font.pixelSize: 13; font.weight: Font.Medium }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color="#F9FAFB"; onExited: parent.color="white" }
                                    }
                                    RowLayout {
                                        spacing: 4
                                        Rectangle { width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"; Text { anchors.centerIn: parent; text: "<"; color: "#374151" } MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color="#F9FAFB"; onExited: parent.color="white" } }
                                        Rectangle { width: 32; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"; Text { anchors.centerIn: parent; text: ">"; color: "#374151" } MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true; onEntered: parent.color="#F9FAFB"; onExited: parent.color="white" } }
                                    }
                                }
                            }
                        }
                        
                        // Calendar Grid
                        Flickable {
                            Layout.fillWidth: true; Layout.fillHeight: true
                            contentWidth: gridLayout.width
                            contentHeight: gridLayout.height
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            
                            GridLayout {
                                id: gridLayout
                                columns: 7
                                rowSpacing: 0
                                columnSpacing: 0
                                width: Math.max(parent.width, 1000)
                                
                                // Header Row (Days)
                                Rectangle { Layout.preferredWidth: 100; Layout.preferredHeight: 60; color: "transparent"; Rectangle { width: 1; height: parent.height; color: "#E5E7EB"; anchors.right: parent.right } Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom } }
                                Repeater {
                                    model: root.days
                                    Rectangle {
                                        Layout.fillWidth: true; Layout.preferredHeight: 60; color: "transparent"
                                        Rectangle { width: 1; height: parent.height; color: "#E5E7EB"; anchors.right: parent.right; visible: index < 5 }
                                        Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom }
                                        Text { anchors.centerIn: parent; text: modelData; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 13; font.weight: Font.Medium; color: "#374151"; lineHeight: 1.2 }
                                    }
                                }
                                
                                // Time Rows
                                Repeater {
                                    model: 35 // 5 rows * 7 cols
                                    Rectangle {
                                        property int r: Math.floor(index / 7)
                                        property int c: index % 7
                                        
                                        Layout.preferredWidth: c === 0 ? 100 : -1
                                        Layout.fillWidth: c !== 0
                                        Layout.preferredHeight: 90
                                        color: "transparent"
                                        
                                        Rectangle { width: 1; height: parent.height; color: "#E5E7EB"; anchors.right: parent.right; visible: parent.c < 6 }
                                        Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom; visible: parent.r < 4 }
                                        
                                        // If column 0, show time
                                        Text {
                                            visible: parent.c === 0
                                            anchors.centerIn: parent
                                            text: parent.r < root.times.length ? root.times[parent.r] : ""
                                            font.pixelSize: 12
                                            font.weight: Font.Medium
                                            color: "#6B7280"
                                        }
                                        
                                        // If column > 0, show event if exists
                                        Item {
                                            anchors.fill: parent
                                            anchors.margins: 4
                                            visible: parent.c > 0
                                            
                                            property var event: root.getEvent(parent.c - 1, parent.r)
                                            
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 6
                                                visible: parent.event !== null
                                                color: parent.event ? root.getCardBgColor(parent.event.color) : "transparent"
                                                
                                                Rectangle {
                                                    width: 4; height: parent.height; radius: 4
                                                    color: parent.parent.event ? root.getCardBorderColor(parent.parent.event.color) : "transparent"
                                                    anchors.left: parent.left
                                                }
                                                
                                                Column {
                                                    anchors.fill: parent
                                                    anchors.margins: 8
                                                    anchors.leftMargin: 12
                                                    spacing: 4
                                                    Text { text: parent.parent.event ? parent.parent.event.title : ""; font.pixelSize: 12; font.weight: Font.Bold; color: parent.parent.parent.event ? root.getCardBorderColor(parent.parent.parent.event.color) : "black"; elide: Text.ElideRight; width: parent.width }
                                                    Text { text: parent.parent.event ? parent.parent.event.prof : ""; font.pixelSize: 11; color: "#4B5563"; elide: Text.ElideRight; width: parent.width }
                                                    Text { text: parent.parent.event ? parent.parent.event.room : ""; font.pixelSize: 11; color: "#6B7280"; elide: Text.ElideRight; width: parent.width; font.weight: Font.Medium }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // --- BOTTOM SECTIONS ---
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20
                    
                    // Prochains cours aujourd'hui
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 80; radius: 12; color: "white"; border.color: "#E5E7EB"; border.width: 1
                        layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 20; spacing: 12
                            Text { text: "🕒"; font.pixelSize: 20; color: "#3B82F6" }
                            Text { text: "Prochains cours aujourd'hui"; font.pixelSize: 14; font.weight: Font.Medium; color: "#111827"; Layout.fillWidth: true }
                            Text { text: "2 cours restants"; font.pixelSize: 13; color: "#6B7280" }
                        }
                    }
                    
                    // Alertes & Notifications
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 80; radius: 12; color: "white"; border.color: "#E5E7EB"; border.width: 1
                        layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 20; spacing: 12
                            Text { text: "🔔"; font.pixelSize: 20; color: "#F97316" }
                            Text { text: "Alertes & Notifications"; font.pixelSize: 14; font.weight: Font.Medium; color: "#111827"; Layout.fillWidth: true }
                            Rectangle { width: 24; height: 24; radius: 12; color: "#FEF2F2"; Text { anchors.centerIn: parent; text: "1"; color: "#EF4444"; font.pixelSize: 12; font.weight: Font.Bold } }
                        }
                    }
                    
                    // Actions rapides
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 80; radius: 12; color: "white"; border.color: "#E5E7EB"; border.width: 1
                        layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 20; spacing: 12
                            Text { text: "⚡"; font.pixelSize: 20; color: "#8B5CF6" }
                            Text { text: "Actions rapides"; font.pixelSize: 14; font.weight: Font.Medium; color: "#111827"; Layout.fillWidth: true }
                        }
                    }
                }
            }
        }
    }
}
