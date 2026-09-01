import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "components"

Item {
    id: root
    anchors.fill: parent

    signal passwordResetSuccessfully()
    signal cancelReset()

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ================= PANNEAU GAUCHE =================
        Rectangle {
            id: leftPanel
            Layout.fillHeight: true
            Layout.preferredWidth: root.width > 900 ? root.width * 0.42 : 0
            visible: root.width > 900
            
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#032B4A" }
                GradientStop { position: 0.5; color: "#01406D" }
                GradientStop { position: 1.0; color: "#01B4BA" }
                orientation: Gradient.Horizontal
            }

            Column {
                anchors.centerIn: parent
                width: parent.width * 0.8
                spacing: 24

                Text {
                    text: "SÉCURITÉ"
                    font.family: "IBM Plex Mono"
                    color: "#FF7A0F"
                    font.letterSpacing: 2.0
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Nouveau mot\nde passe"
                    font.family: "Fraunces"
                    color: "white"
                    font.pixelSize: 34
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Choisissez un mot de passe fort et unique\npour protéger votre compte universitaire."
                    font.family: "Inter"
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 10
                }
            }
        }

        // ================= PANNEAU DROIT =================
        Rectangle {
            id: rightPanel
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#F5FEFE"

            Rectangle {
                id: loginCard
                width: Math.min(parent.width * 0.8, 420)
                height: cardContent.height
                anchors.centerIn: parent
                color: "transparent"

                Column {
                    id: cardContent
                    width: parent.width
                    spacing: 24

                    Column {
                        spacing: 8
                        
                        Text {
                            text: "RÉINITIALISATION"
                            font.family: "IBM Plex Mono"
                            color: "#01B4BA"
                            font.letterSpacing: 1.5
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "Nouveau mot de passe"
                            font.family: "Fraunces"
                            color: "#032B4A"
                            font.pixelSize: 32
                            font.weight: Font.Bold
                        }

                        Text {
                            text: "Veuillez entrer le code de réinitialisation reçu et\nvotre nouveau mot de passe."
                            font.family: "Inter"
                            color: "#6B7280"
                            font.pixelSize: 14
                            lineHeight: 1.4
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: 16

                        StyledTextField {
                            id: tokenField
                            labelText: "Code de réinitialisation (Token)"
                            placeholder: "ex : 123456"
                            iconText: "🔑"
                            onTextChanged: formErrorBanner.text = ""
                        }

                        StyledTextField {
                            id: passwordField
                            labelText: "Nouveau mot de passe"
                            placeholder: "••••••••"
                            iconText: "🔒"
                            isPassword: true
                            onTextChanged: formErrorBanner.text = ""
                        }
                        
                        StyledTextField {
                            id: confirmPasswordField
                            labelText: "Confirmer le mot de passe"
                            placeholder: "••••••••"
                            iconText: "🔒"
                            isPassword: true
                            onTextChanged: formErrorBanner.text = ""
                        }

                        Text {
                            id: formErrorBanner
                            width: parent.width
                            color: "red"
                            font.pixelSize: 13
                            font.family: "Inter"
                            visible: text !== ""
                            wrapMode: Text.WordWrap
                        }
                        
                        Text {
                            id: formSuccessBanner
                            width: parent.width
                            color: "green"
                            font.pixelSize: 13
                            font.family: "Inter"
                            visible: text !== ""
                            wrapMode: Text.WordWrap
                        }
                    }

                    PrimaryButton {
                        id: saveButton
                        text: "Enregistrer"
                        enabled: tokenField.text.length > 0 && passwordField.text.length >= 8 && passwordField.text === confirmPasswordField.text
                        
                        onClicked: {
                            formErrorBanner.text = ""
                            if (passwordField.text !== confirmPasswordField.text) {
                                formErrorBanner.text = "Les mots de passe ne correspondent pas."
                                return
                            }
                            
                            isLoading = true;
                            enabled = false;
                            
                            authManager.resetPassword(tokenField.text, passwordField.text);
                        }
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 4
                        
                        Text {
                            text: "Annuler"
                            font.family: "Inter"
                            font.pixelSize: 13
                            color: "#01406D"
                            font.weight: Font.DemiBold
                            
                            Rectangle {
                                width: parent.width
                                height: 1
                                color: "#01B4BA"
                                anchors.bottom: parent.bottom
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.cancelReset()
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: authManager
        function onPasswordResetSuccess() {
            saveButton.isLoading = false;
            formSuccessBanner.text = "Votre mot de passe a été réinitialisé avec succès."
            successTimer.start();
        }
        function onPasswordResetError(msg) {
            saveButton.isLoading = false;
            saveButton.enabled = true;
            formErrorBanner.text = msg;
        }
    }
    
    Timer {
        id: successTimer
        interval: 2000
        onTriggered: {
            root.passwordResetSuccessfully()
        }
    }
}
