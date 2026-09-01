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
            text: "Parcours Académique"
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
            model: studentService.academicHistory
            delegate: RowLayout {
                Layout.fillWidth: true
                spacing: 16
                
                // Timeline marker
                ColumnLayout {
                    Layout.alignment: Qt.AlignTop
                    spacing: 0
                    Rectangle {
                        width: 12
                        height: 12
                        radius: 6
                        color: modelData.statut === "Terminée" ? "#10B981" : "#3B82F6"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Rectangle {
                        width: 2
                        Layout.fillHeight: true
                        Layout.minimumHeight: 60
                        color: "#E5E7EB"
                        Layout.alignment: Qt.AlignHCenter
                        visible: index < studentService.academicHistory.length - 1
                    }
                }
                
                // Content
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 4
                    
                    Text {
                        text: modelData.annee
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.Bold
                        color: "#111827"
                    }
                    Text {
                        text: modelData.filiere
                        font.family: "Inter"
                        font.pixelSize: 14
                        color: "#4B5563"
                    }
                    RowLayout {
                        spacing: 8
                        Text {
                            text: (modelData.statut === "Terminée" ? "✓ Terminée" : "● En cours")
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                            color: modelData.statut === "Terminée" ? "#10B981" : "#3B82F6"
                        }
                        Text {
                            text: "• " + modelData.cours_valides + " / " + modelData.total_cours + " cours validés"
                            font.family: "Inter"
                            font.pixelSize: 12
                            color: "#6B7280"
                        }
                    }
                    Item { height: 16; Layout.fillWidth: true } // spacer
                }
            }
        }
        
        Text {
            text: "Aucun historique académique"
            visible: studentService.academicHistory.length === 0
            font.pixelSize: 14
            color: "#6B7280"
            font.italic: true
        }
    }
}
