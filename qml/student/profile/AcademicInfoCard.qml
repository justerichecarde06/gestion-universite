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

        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Informations Universitaires"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: "#032B4A"
                Layout.fillWidth: true
            }
            
            Rectangle {
                color: "#F3F4F6"
                radius: 4
                implicitWidth: layout.implicitWidth + 12
                implicitHeight: layout.implicitHeight + 12
                RowLayout {
                    id: layout
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "🔒"; font.pixelSize: 12 }
                    Text { 
                        text: "Géré par l'administration"
                        font.family: "Inter"
                        font.pixelSize: 12
                        color: "#6B7280"
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#E5E7EB"
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 16
            columnSpacing: 32

            Repeater {
                model: [
                    { label: "Matricule", value: studentService.profile.matricule || "N/A" },
                    { label: "Filière", value: studentService.profile.filiere || "N/A" },
                    { label: "Niveau", value: studentService.profile.niveau || "N/A" },
                    { label: "Statut", value: studentService.profile.statut || "N/A" },
                    { label: "Année d'admission", value: "2023" }, // Dummy or could be extracted
                    { label: "Faculté", value: "Sciences et Technologies" } // Dummy
                ]
                
                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true
                    
                    Text { 
                        text: modelData.label 
                        font.pixelSize: 12 
                        color: "#6B7280" 
                        font.family: "Inter"
                    }
                    Text { 
                        text: modelData.value 
                        font.pixelSize: 14 
                        color: "#111827" 
                        font.weight: Font.Medium
                        font.family: "Inter"
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
