import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    color: "white"
    radius: 12
    height: contentCol.height + 40
    
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowOpacity: 0.05
        shadowBlur: 15
        shadowVerticalOffset: 4
    }

    ColumnLayout {
        id: contentCol
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 20

        Text {
            text: "Activité Récente"
            font.family: "Inter"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            color: "#032B4A"
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#E5E7EB"
        }

        Repeater {
            model: studentService.recentActivity
            delegate: ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#3B82F6"
                    }
                    
                    Text {
                        text: modelData.action
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: "#111827"
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: modelData.date
                        font.family: "Inter"
                        font.pixelSize: 12
                        color: "#6B7280"
                    }
                }
                
                Text {
                    text: modelData.details
                    font.family: "Inter"
                    font.pixelSize: 12
                    color: "#6B7280"
                    Layout.leftMargin: 16
                    visible: text !== ""
                }
            }
        }
        
        Text {
            text: "Aucune activité récente"
            visible: studentService.recentActivity.length === 0
            font.pixelSize: 14
            color: "#6B7280"
            font.italic: true
        }
    }
}
