import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent

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

                // Header
                Column {
                    spacing: 4
                    Text {
                        text: "Documents Administratifs"
                        font.family: "Inter"
                        font.pixelSize: 28
                        font.weight: Font.Bold
                        color: "#111827"
                    }
                    Text {
                        text: "Vos documents sont disponibles ci-dessous."
                        font.family: "Inter"
                        font.pixelSize: 14
                        color: "#6B7280"
                    }
                }
                
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 20
                    rowSpacing: 20
                    
                    Repeater {
                        model: [
                            { title: "Carte Étudiant", desc: "Télécharger votre carte", icon: "💳", color: "#EFF6FF", iconColor: "#3B82F6" },
                            { title: "Attestation de scolarité", desc: "Année 2023-2024", icon: "📜", color: "#F0FDF4", iconColor: "#22C55E" },
                            { title: "Relevé de notes", desc: "Générer un PDF officiel", icon: "📊", color: "#FFF7ED", iconColor: "#F97316" }
                        ]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 180
                            color: "white"
                            radius: 12
                            border.color: "#E5E7EB"
                            border.width: 1
                            layer.enabled: true
                            layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                            
                            Column {
                                anchors.centerIn: parent
                                spacing: 16
                                
                                Rectangle {
                                    width: 56; height: 56; radius: 12; color: modelData.color
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Text { anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 28 }
                                }
                                
                                Column {
                                    spacing: 4
                                    Text { text: modelData.title; font.family: "Inter"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827"; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: modelData.desc; font.family: "Inter"; font.pixelSize: 13; color: "#6B7280"; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                
                                Rectangle {
                                    width: 140; height: 36; radius: 6; color: "white"; border.color: "#E5E7EB"; border.width: 1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Text { anchors.centerIn: parent; text: "Télécharger"; color: "#374151"; font.pixelSize: 13; font.weight: Font.Medium }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                                        onEntered: parent.color = "#F9FAFB"; onExited: parent.color = "white"
                                        onClicked: console.log("Download", modelData.title)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Item { Layout.fillHeight: true }
            }
        }
    }
}
