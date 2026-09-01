import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    color: "white"
    radius: 12
    height: 180
    
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowOpacity: 0.05
        shadowBlur: 15
        shadowVerticalOffset: 4
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        Text {
            text: "Actions rapides"
            font.family: "Inter"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            color: "#111827"
            Layout.fillWidth: true
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 12
            columnSpacing: 12
            
            // Action 1
            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 6
                border.width: 1
                border.color: "#E5E7EB"
                color: "white"
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "📄"; font.pixelSize: 14 }
                    Text {
                        text: "Demander un document"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.color = "#F9FAFB"
                    onExited: parent.color = "white"
                }
            }
            
            // Action 2
            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 6
                border.width: 1
                border.color: "#E5E7EB"
                color: "white"
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "💳"; font.pixelSize: 14 }
                    Text {
                        text: "Payer mes frais"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.color = "#F9FAFB"
                    onExited: parent.color = "white"
                }
            }
            
            // Action 3
            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 6
                border.width: 1
                border.color: "#E5E7EB"
                color: "white"
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "📅"; font.pixelSize: 14 }
                    Text {
                        text: "Voir mon emploi du temps"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.color = "#F9FAFB"
                    onExited: parent.color = "white"
                }
            }
            
            // Action 4
            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 6
                border.width: 1
                border.color: "#E5E7EB"
                color: "white"
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "✉️"; font.pixelSize: 14 }
                    Text {
                        text: "Contacter la scolarité"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.color = "#F9FAFB"
                    onExited: parent.color = "white"
                }
            }
        }
    }
}
