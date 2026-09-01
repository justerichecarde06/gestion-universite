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
                        text: "Mes Notes et Résultats"
                        font.family: "Inter"
                        font.pixelSize: 28
                        font.weight: Font.Bold
                        color: "#111827"
                    }
                    Text {
                        text: "Consultez vos notes, résultats et moyennes de vos cours."
                        font.family: "Inter"
                        font.pixelSize: 14
                        color: "#6B7280"
                    }
                }

                // Content list
                Repeater {
                    model: studentService.grades
                    
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
                                width: 40; height: 40; radius: 8; color: "#F0FDF4"
                                Text { anchors.centerIn: parent; text: "📝"; font.pixelSize: 20 }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: modelData.cours + " (" + modelData.type + ")"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                                Text { text: "Date: " + modelData.date + " | Coefficient: " + modelData.coefficient; font.pixelSize: 13; color: "#6B7280" }
                            }
                            Item { Layout.fillWidth: true }
                            
                            Rectangle {
                                width: 80; height: 40; radius: 8; color: "#FFF7ED"
                                Text { anchors.centerIn: parent; text: modelData.valeur + " / 100"; font.pixelSize: 16; font.weight: Font.Bold; color: "#F97316" }
                            }
                        }
                    }
                }
            }
        }
    }
}
