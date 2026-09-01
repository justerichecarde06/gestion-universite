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

    property bool isEditing: false

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
                text: "Coordonnées & Contact"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: "#032B4A"
                Layout.fillWidth: true
            }
            
            Button {
                text: root.isEditing ? "Annuler" : "Modifier"
                flat: true
                onClicked: {
                    if (root.isEditing) {
                        // Reset fields
                        emailField.text = studentService.profile.email || ""
                        phoneField.text = studentService.profile.telephone || ""
                        addressField.text = studentService.profile.adresse || ""
                        cityField.text = studentService.profile.ville || ""
                    }
                    root.isEditing = !root.isEditing
                }
            }
            
            Button {
                text: "Enregistrer"
                visible: root.isEditing
                background: Rectangle {
                    color: "#032B4A"
                    radius: 6
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.family: "Inter"
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    var data = {
                        "email": emailField.text,
                        "telephone": phoneField.text,
                        "adresse": addressField.text,
                        "ville": cityField.text
                    }
                    var result = studentService.updateProfile(data)
                    if (result.success) {
                        root.isEditing = false
                        // TODO: trigger global notification
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

            // Email
            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true
                Text { text: "Email personnel"; font.pixelSize: 12; color: "#6B7280" }
                TextField {
                    id: emailField
                    Layout.fillWidth: true
                    text: studentService.profile.email || ""
                    readOnly: !root.isEditing
                    background: Rectangle {
                        color: root.isEditing ? "white" : "#F9FAFB"
                        border.color: root.isEditing ? "#D1D5DB" : "transparent"
                        radius: 6
                    }
                }
            }
            
            // Phone
            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true
                Text { text: "Téléphone"; font.pixelSize: 12; color: "#6B7280" }
                TextField {
                    id: phoneField
                    Layout.fillWidth: true
                    text: studentService.profile.telephone || ""
                    readOnly: !root.isEditing
                    background: Rectangle {
                        color: root.isEditing ? "white" : "#F9FAFB"
                        border.color: root.isEditing ? "#D1D5DB" : "transparent"
                        radius: 6
                    }
                }
            }
            
            // Address
            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true
                Layout.columnSpan: 2
                Text { text: "Adresse"; font.pixelSize: 12; color: "#6B7280" }
                TextField {
                    id: addressField
                    Layout.fillWidth: true
                    text: studentService.profile.adresse || ""
                    readOnly: !root.isEditing
                    background: Rectangle {
                        color: root.isEditing ? "white" : "#F9FAFB"
                        border.color: root.isEditing ? "#D1D5DB" : "transparent"
                        radius: 6
                    }
                }
            }
            
            // City
            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true
                Text { text: "Ville"; font.pixelSize: 12; color: "#6B7280" }
                TextField {
                    id: cityField
                    Layout.fillWidth: true
                    text: studentService.profile.ville || ""
                    readOnly: !root.isEditing
                    background: Rectangle {
                        color: root.isEditing ? "white" : "#F9FAFB"
                        border.color: root.isEditing ? "#D1D5DB" : "transparent"
                        radius: 6
                    }
                }
            }
            
            // Date of birth (ReadOnly always)
            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true
                Text { text: "Date de naissance 🔒"; font.pixelSize: 12; color: "#6B7280" }
                TextField {
                    Layout.fillWidth: true
                    text: studentService.profile.date_naissance || "Non renseignée"
                    readOnly: true
                    background: Rectangle { color: "#F9FAFB"; radius: 6 }
                    color: "#6B7280"
                }
            }
        }
    }
}
