import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 350
    color: "transparent"
    
    signal shortcutClicked(string target)

    ColumnLayout {
        anchors.fill: parent
        spacing: 20
        
        // Quick Shortcuts
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            radius: 12
            color: "white"
            border.color: "#E2E8F0"
            border.width: 1
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Text {
                    text: "Accès rapides"
                    font.family: "Inter"
                    color: "#1A2B3C"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
                
                GridLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    columns: 3
                    rowSpacing: 10
                    columnSpacing: 10
                    
                    Repeater {
                        model: [
                            { text: "Mes Notes", icon: "📊", color: "#F0F9FF", target: "Notes" },
                            { text: "Emploi du temps", icon: "📅", color: "#FEF2F2", target: "Schedule" },
                            { text: "Mes Paiements", icon: "💰", color: "#FFFBEB", target: "Finance" },
                            { text: "Mes Documents", icon: "📄", color: "#F5F3FF", target: "Documents" },
                            { text: "Mon Profil", icon: "👤", color: "#F0FDF4", target: "Profile" },
                            { text: "S'inscrire", icon: "✍", color: "#F8FAFC", target: "Enrollments" }
                        ]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 46
                            radius: 8
                            color: modelData.color
                            border.color: "#E2E8F0"
                            border.width: 1
                            
                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                Text { text: modelData.icon; font.pixelSize: 14 }
                                Text { text: modelData.text; font.family: "Inter"; color: "#334155"; font.pixelSize: 12; font.weight: Font.Medium }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.shortcutClicked(modelData.target)
                            }
                        }
                    }
                }
            }
        }
        
        // Calendar & Events
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: "white"
            border.color: "#E2E8F0"
            border.width: 1
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "À venir"
                        font.family: "Inter"
                        color: "#1A2B3C"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }
                    Item { Layout.fillWidth: true }
                    Text { text: "Calendrier"; font.family: "Inter"; color: "#0284C7"; font.pixelSize: 12; font.weight: Font.DemiBold }
                }
                
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: [
                        { date: "25 Août", desc: "Examen de C++", type: "Exam" },
                        { date: "28 Août", desc: "Paiement scolarité", type: "Finance" },
                        { date: "02 Sept", desc: "Début des inscriptions", type: "Admin" }
                    ]
                    spacing: 12
                    
                    delegate: RowLayout {
                        width: ListView.view.width
                        spacing: 12
                        
                        Rectangle {
                            width: 44; height: 44; radius: 8
                            color: modelData.type === "Exam" ? "#FEF2F2" : (modelData.type === "Finance" ? "#FFFBEB" : "#F0F9FF")
                            
                            Column {
                                anchors.centerIn: parent
                                Text { text: modelData.date.split(" ")[0]; font.family: "Inter"; color: "#1A2B3C"; font.pixelSize: 14; font.weight: Font.Bold; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: modelData.date.split(" ")[1]; font.family: "Inter"; color: "#64748B"; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                        }
                        
                        Text {
                            Layout.fillWidth: true
                            text: modelData.desc
                            font.family: "Inter"
                            color: "#334155"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                        }
                    }
                }
            }
        }
    }
}
