import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "../components"

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
                        text: "Inscriptions aux Cours"
                        font.family: "Inter"
                        font.pixelSize: 28
                        font.weight: Font.Bold
                        color: "#111827"
                    }
                    Text {
                        text: "Parcourez les cours disponibles et inscrivez-vous."
                        font.family: "Inter"
                        font.pixelSize: 14
                        color: "#6B7280"
                    }
                }

                // Content list
                Repeater {
                    model: studentService.availableCourses
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        color: "white"
                        radius: 12
                        border.color: "#E5E7EB"
                        border.width: 1
                        layer.enabled: true
                        layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16
                            
                            Rectangle {
                                width: 40; height: 40; radius: 8; color: "#EFF6FF"
                                Text { anchors.centerIn: parent; text: "📘"; font.pixelSize: 20 }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: modelData.code + " - " + modelData.intitule; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                                Text { text: "Crédits: " + modelData.credits + " | Vol. Horaire: " + modelData.volume_horaire + "h"; font.pixelSize: 13; color: "#6B7280" }
                            }
                            Item { Layout.fillWidth: true }
                            
                            Rectangle {
                                width: 120; height: 40; radius: 6; color: "#2563EB"
                                Text { anchors.centerIn: parent; text: "S'inscrire"; color: "white"; font.pixelSize: 14; font.weight: Font.Medium }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onEntered: parent.opacity = 0.9
                                    onExited: parent.opacity = 1.0
                                    onClicked: studentService.enrollInCourse(modelData.id)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
