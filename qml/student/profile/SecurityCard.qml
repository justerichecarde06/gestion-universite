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
            text: "Sécurité & Mot de passe"
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
        
        ColumnLayout {
            spacing: 16
            Layout.fillWidth: true
            
            Text {
                text: "Modifier votre mot de passe"
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Medium
            }
            
            TextField {
                id: oldPwdField
                Layout.fillWidth: true
                Layout.maximumWidth: 400
                placeholderText: "Ancien mot de passe"
                echoMode: TextInput.Password
                background: Rectangle { color: "#F9FAFB"; border.color: "#D1D5DB"; radius: 6; border.width: 1 }
            }
            
            TextField {
                id: newPwdField
                Layout.fillWidth: true
                Layout.maximumWidth: 400
                placeholderText: "Nouveau mot de passe"
                echoMode: TextInput.Password
                background: Rectangle { color: "#F9FAFB"; border.color: "#D1D5DB"; radius: 6; border.width: 1 }
            }
            
            TextField {
                id: confirmPwdField
                Layout.fillWidth: true
                Layout.maximumWidth: 400
                placeholderText: "Confirmer le nouveau mot de passe"
                echoMode: TextInput.Password
                background: Rectangle { color: "#F9FAFB"; border.color: "#D1D5DB"; radius: 6; border.width: 1 }
            }
            
            Text {
                id: errorText
                color: "#E02424"
                visible: false
                font.pixelSize: 12
            }
            Text {
                id: successText
                color: "#31C48D"
                visible: false
                font.pixelSize: 12
            }
            
            Button {
                text: "Mettre à jour"
                background: Rectangle { color: "#032B4A"; radius: 6 }
                contentItem: Text { 
                    text: parent.text; color: "white"; font.family: "Inter"; font.weight: Font.Medium 
                    horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    errorText.visible = false
                    successText.visible = false
                    if (newPwdField.text === "" || oldPwdField.text === "") {
                        errorText.text = "Veuillez remplir tous les champs."
                        errorText.visible = true
                        return
                    }
                    if (newPwdField.text !== confirmPwdField.text) {
                        errorText.text = "Les nouveaux mots de passe ne correspondent pas."
                        errorText.visible = true
                        return
                    }
                    var result = studentService.changePassword(oldPwdField.text, newPwdField.text)
                    if (result.success) {
                        successText.text = result.message
                        successText.visible = true
                        oldPwdField.text = ""
                        newPwdField.text = ""
                        confirmPwdField.text = ""
                    } else {
                        errorText.text = result.message
                        errorText.visible = true
                    }
                }
            }
        }
    }
}
