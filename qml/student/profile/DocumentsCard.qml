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
            text: "Mes Documents"
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
            model: studentService.profileDocuments
            delegate: Rectangle {
                Layout.fillWidth: true
                height: 60
                color: "#F9FAFB"
                radius: 8
                border.color: "#E5E7EB"
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    Text { text: "📄"; font.pixelSize: 20 }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: modelData.nom
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "#111827"
                        }
                        Text {
                            text: modelData.date + " • " + modelData.type
                            font.family: "Inter"
                            font.pixelSize: 12
                            color: "#6B7280"
                        }
                    }
                    
                    Button {
                        text: "Télécharger"
                        flat: true
                        onClicked: {
                            console.log("Télécharger document: " + modelData.chemin)
                        }
                    }
                }
            }
        }
        
        Text {
            text: "Aucun document disponible"
            visible: studentService.profileDocuments.length === 0
            font.pixelSize: 14
            color: "#6B7280"
            font.italic: true
        }
    }
}
