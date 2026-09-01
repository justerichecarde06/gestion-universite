import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "components"

Item {
    id: root
    anchors.fill: parent

    signal backToLogin()
    signal resetTokenReceived(string email)

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
                    text: "Récupération\nde compte"
                    font.family: "Fraunces"
                    color: "white"
                    font.pixelSize: 34
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Suivez les instructions pour réinitialiser\nvotre mot de passe en toute sécurité."
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
                            text: "MOT DE PASSE OUBLIÉ"
                            font.family: "IBM Plex Mono"
                            color: "#01B4BA"
                            font.letterSpacing: 1.5
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "Réinitialiser"
                            font.family: "Fraunces"
                            color: "#032B4A"
                            font.pixelSize: 36
                            font.weight: Font.Bold
                        }

                        Text {
                            text: "Entrez l'adresse email associée à votre compte.\nNous vous enverrons un lien sécurisé permettant de créer un nouveau mot de passe."
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
                            id: emailField
                            labelText: "Email"
                            placeholder: "ex : jean@usfah.edu.ht"
                            iconText: "✉"
                            onTextChanged: {
                                formErrorBanner.text = ""
                                formSuccessBanner.text = ""
                            }
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
                        id: sendButton
                        text: "Envoyer le lien"
                        enabled: emailField.text.length > 3 && emailField.text.includes("@")
                        
                        onClicked: {
                            formErrorBanner.text = ""
                            formSuccessBanner.text = ""
                            isLoading = true;
                            enabled = false;
                            
                            authManager.requestPasswordReset(emailField.text);
                        }
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 4
                        
                        Text {
                            text: "Je me souviens de mon mot de passe."
                            font.family: "Inter"
                            font.pixelSize: 13
                            color: "#6B7280"
                        }
                        
                        Text {
                            text: "Retour"
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
                                onClicked: root.backToLogin()
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: authManager
        function onPasswordResetRequested(msg) {
            sendButton.isLoading = false;
            sendButton.enabled = true;
            formSuccessBanner.text = msg;
            
            // For demo purposes, we will proceed to the reset page after a few seconds
            successTimer.start();
        }
        function onPasswordResetFailed(msg) {
            sendButton.isLoading = false;
            sendButton.enabled = true;
            formErrorBanner.text = msg;
        }
    }
    
    Timer {
        id: successTimer
        interval: 3000
        onTriggered: {
            root.resetTokenReceived(emailField.text);
        }
    }
}
