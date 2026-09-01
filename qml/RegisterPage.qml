import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "components"

Item {
    id: root
    anchors.fill: parent

    signal backToLogin()
    signal registrationSuccess()

    // Form data
    property string nom: ""
    property string prenom: ""
    property string phone: ""
    property string email: ""
    property string faculte: ""
    property string filiere: ""
    property string niveau: ""
    property string password: ""
    
    // Wizard state
    property int currentStep: 1
    property int totalSteps: 4

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

            Canvas {
                anchors.fill: parent
                opacity: 0.15
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.fillStyle = "white";
                    
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width * 0.8, 0);
                    ctx.lineTo(0, height * 0.5);
                    ctx.fill();
                    
                    ctx.beginPath();
                    ctx.moveTo(width, height * 0.2);
                    ctx.lineTo(width, height);
                    ctx.lineTo(width * 0.3, height);
                    ctx.fill();
                    
                    ctx.beginPath();
                    ctx.moveTo(width * 0.5, height * 0.3);
                    ctx.lineTo(width * 0.9, height * 0.7);
                    ctx.lineTo(width * 0.2, height * 0.8);
                    ctx.fill();
                }
            }

            Column {
                anchors.centerIn: parent
                width: parent.width * 0.8
                spacing: 24

                Text {
                    text: "REJOIGNEZ-NOUS"
                    font.family: "IBM Plex Mono"
                    color: "#FF7A0F"
                    font.letterSpacing: 2.0
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Votre Avenir\nCommence Ici"
                    font.family: "Fraunces"
                    color: "white"
                    font.pixelSize: 34
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Créez votre compte étudiant pour accéder à\ntoutes les ressources de l'USFAH."
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
                width: 400
                height: 400
                radius: 200
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: -100
                color: "#FF7A0F"
                opacity: 0.05
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 1.0; shadowOpacity: 1.0 }
            }

            Flickable {
                anchors.fill: parent
                contentHeight: loginCard.height + 100
                contentWidth: parent.width
                clip: true

                Rectangle {
                    id: loginCard
                    width: Math.min(parent.width * 0.8, 480)
                    height: cardContent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"

                    Column {
                        id: cardContent
                        width: parent.width
                        spacing: 24

                        Column {
                            spacing: 8
                            
                            Text {
                                text: "INSCRIPTION ÉTUDIANT"
                                font.family: "IBM Plex Mono"
                                color: "#01B4BA"
                                font.letterSpacing: 1.5
                                font.pixelSize: 11
                                font.weight: Font.DemiBold
                            }

                            Text {
                                text: "Créer un compte"
                                font.family: "Fraunces"
                                color: "#032B4A"
                                font.pixelSize: 32
                                font.weight: Font.Bold
                            }
                            
                            // Progress bar
                            RowLayout {
                                width: parent.width
                                spacing: 8
                                visible: currentStep <= totalSteps
                                
                                Repeater {
                                    model: totalSteps
                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 4
                                        radius: 2
                                        color: index + 1 <= currentStep ? "#01B4BA" : "#E5E7EB"
                                    }
                                }
                            }
                            Text {
                                visible: currentStep <= totalSteps
                                text: "Étape " + currentStep + " sur " + totalSteps
                                font.family: "Inter"
                                font.pixelSize: 12
                                color: "#6B7280"
                            }
                        }

                        // Form Fields - Step 1: Personal Info
                        Column {
                            width: parent.width
                            spacing: 16
                            visible: currentStep === 1

                            StyledTextField {
                                id: prenomField
                                labelText: "Prénom"
                                placeholder: "ex : Jean"
                                iconText: "👤"
                                text: root.prenom
                            }
                            
                            StyledTextField {
                                id: nomField
                                labelText: "Nom"
                                placeholder: "ex : Dupont"
                                iconText: "👤"
                                text: root.nom
                            }

                            StyledTextField {
                                id: phoneField
                                labelText: "Téléphone"
                                placeholder: "ex : +509 34 56 78 90"
                                iconText: "📱"
                                text: root.phone
                            }

                            StyledTextField {
                                id: emailField
                                labelText: "Email"
                                placeholder: "ex : jean@usfah.edu.ht"
                                iconText: "✉"
                                text: root.email
                            }
                        }
                        
                        // Form Fields - Step 2: Academic Info
                        Column {
                            width: parent.width
                            spacing: 16
                            visible: currentStep === 2
                            
                            Text {
                                text: "Informations Académiques"
                                font.family: "Inter"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                color: "#111827"
                            }

                            // Facultés (Mocked list, in real app fetch from DB)
                            Column {
                                width: parent.width
                                spacing: 6
                                Text { text: "Faculté"; font.family: "Inter"; font.pixelSize: 13; color: "#374151" }
                                ComboBox {
                                    id: faculteCombo
                                    width: parent.width
                                    model: ["Sélectionner", "Faculté des Sciences", "Faculté de Médecine", "Faculté des Lettres", "Faculté de Droit"]
                                    onCurrentTextChanged: root.faculte = (currentIndex > 0) ? currentText : ""
                                }
                            }
                            
                            Column {
                                width: parent.width
                                spacing: 6
                                Text { text: "Filière / Programme"; font.family: "Inter"; font.pixelSize: 13; color: "#374151" }
                                ComboBox {
                                    id: filiereCombo
                                    width: parent.width
                                    model: ["Sélectionner", "Science Informatique", "Génie Civil", "Médecine Générale", "Droit des Affaires"]
                                    onCurrentTextChanged: root.filiere = (currentIndex > 0) ? currentText : ""
                                }
                            }
                            
                            Column {
                                width: parent.width
                                spacing: 6
                                Text { text: "Niveau d'étude"; font.family: "Inter"; font.pixelSize: 13; color: "#374151" }
                                ComboBox {
                                    id: niveauCombo
                                    width: parent.width
                                    model: ["Sélectionner", "1re année", "2e année", "3e année", "4e année", "Master 1", "Master 2"]
                                    onCurrentTextChanged: root.niveau = (currentIndex > 0) ? currentText : ""
                                }
                            }
                        }
                        
                        // Form Fields - Step 3: Security
                        Column {
                            width: parent.width
                            spacing: 16
                            visible: currentStep === 3
                            
                            Text {
                                text: "Sécurité"
                                font.family: "Inter"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                color: "#111827"
                            }
                            
                            StyledTextField {
                                id: passwordField
                                labelText: "Mot de passe"
                                placeholder: "••••••••"
                                iconText: "🔒"
                                isPassword: true
                                onTextChanged: root.password = text
                            }
                            
                            // Strength indicator
                            RowLayout {
                                width: parent.width
                                spacing: 4
                                Rectangle { Layout.fillWidth: true; height: 4; radius: 2; color: root.password.length > 0 ? (root.password.length > 7 ? "#31C48D" : "#FF5A5F") : "#E5E7EB" }
                                Rectangle { Layout.fillWidth: true; height: 4; radius: 2; color: root.password.length > 7 && /[A-Z]/.test(root.password) ? "#31C48D" : "#E5E7EB" }
                                Rectangle { Layout.fillWidth: true; height: 4; radius: 2; color: root.password.length > 7 && /[0-9]/.test(root.password) && /[^A-Za-z0-9]/.test(root.password) ? "#31C48D" : "#E5E7EB" }
                            }
                            Text {
                                text: root.password.length === 0 ? "Requis : 8 caractères, majuscule, chiffre" : (root.password.length > 7 && /[A-Z]/.test(root.password) && /[0-9]/.test(root.password) ? "Mot de passe fort" : "Mot de passe faible")
                                font.family: "Inter"
                                font.pixelSize: 11
                                color: root.password.length > 7 && /[A-Z]/.test(root.password) && /[0-9]/.test(root.password) ? "#31C48D" : "#6B7280"
                            }
                            
                            StyledTextField {
                                id: confirmPasswordField
                                labelText: "Confirmer le mot de passe"
                                placeholder: "••••••••"
                                iconText: "🔒"
                                isPassword: true
                            }
                        }

                        // Form Fields - Step 4: Summary
                        Column {
                            width: parent.width
                            spacing: 16
                            visible: currentStep === 4
                            
                            Text {
                                text: "Résumé de vos informations"
                                font.family: "Inter"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                color: "#111827"
                            }
                            
                            Rectangle {
                                width: parent.width
                                color: "#F9FAFB"
                                radius: 8
                                border.color: "#E5E7EB"
                                border.width: 1
                                height: summaryLayout.implicitHeight + 32
                                
                                ColumnLayout {
                                    id: summaryLayout
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 12
                                    
                                    Text { text: "Personnel"; font.bold: true; color: "#374151" }
                                    Text { text: "Nom: " + root.prenom + " " + root.nom; color: "#4B5563" }
                                    Text { text: "Email: " + root.email; color: "#4B5563" }
                                    Text { text: "Téléphone: " + root.phone; color: "#4B5563" }
                                    
                                    Item { Layout.fillWidth: true; height: 1; Rectangle { anchors.fill: parent; color: "#E5E7EB" } }
                                    
                                    Text { text: "Académique"; font.bold: true; color: "#374151"; Layout.topMargin: 8 }
                                    Text { text: "Faculté: " + root.faculte; color: "#4B5563" }
                                    Text { text: "Filière: " + root.filiere; color: "#4B5563" }
                                    Text { text: "Niveau: " + root.niveau; color: "#4B5563" }
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
                        }
                        
                        // Step 5: Success
                        Column {
                            width: parent.width
                            spacing: 16
                            visible: currentStep === 5
                            
                            Rectangle {
                                width: 64
                                height: 64
                                radius: 32
                                color: "#31C48D"
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: "✓"
                                    color: "white"
                                    font.pixelSize: 32
                                    anchors.centerIn: parent
                                }
                            }
                            
                            Text {
                                text: "Demande envoyée"
                                font.family: "Fraunces"
                                font.pixelSize: 24
                                font.weight: Font.Bold
                                color: "#111827"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            
                            Text {
                                text: "Votre demande d'inscription a bien été enregistrée.\n\nVotre compte doit maintenant être vérifié et approuvé par l'administration.\nVous recevrez une notification lorsque votre accès sera activé."
                                font.family: "Inter"
                                font.pixelSize: 14
                                color: "#4B5563"
                                horizontalAlignment: Text.AlignHCenter
                                lineHeight: 1.5
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // Navigation Buttons
                        RowLayout {
                            width: parent.width
                            spacing: 16
                            visible: currentStep <= totalSteps

                            PrimaryButton {
                                Layout.fillWidth: true
                                text: "Retour"
                                visible: currentStep > 1
                                // Add border programmatically inside the button component or just use a custom rect if styling doesn't support border easily
                                onClicked: currentStep--
                            }
                            
                            PrimaryButton {
                                id: nextBtn
                                Layout.fillWidth: true
                                text: currentStep === totalSteps ? "Confirmer et Créer" : "Suivant"
                                
                                enabled: {
                                    if (currentStep === 1) return prenomField.text.length > 1 && nomField.text.length > 1 && emailField.text.includes("@");
                                    if (currentStep === 2) return root.faculte !== "" && root.filiere !== "" && root.niveau !== "";
                                    if (currentStep === 3) return passwordField.text.length >= 8 && passwordField.text === confirmPasswordField.text;
                                    return true; // Step 4
                                }
                                
                                onClicked: {
                                    if (currentStep === 1) {
                                        root.prenom = prenomField.text
                                        root.nom = nomField.text
                                        root.phone = phoneField.text
                                        root.email = emailField.text
                                        currentStep++
                                    } else if (currentStep === 2) {
                                        currentStep++
                                    } else if (currentStep === 3) {
                                        currentStep++
                                    } else if (currentStep === 4) {
                                        isLoading = true
                                        enabled = false
                                        authManager.registerStudent(root.email, root.password, root.nom, root.prenom, root.phone, root.faculte, root.filiere, root.niveau)
                                    }
                                }
                            }
                        }
                        
                        // Back to login on Success
                        PrimaryButton {
                            width: parent.width
                            visible: currentStep === 5
                            text: "Retour à la connexion"
                            onClicked: root.backToLogin()
                        }

                        // Back to login link
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4
                            visible: currentStep === 1
                            
                            Text {
                                text: "Vous avez déjà un compte ?"
                                font.family: "Inter"
                                font.pixelSize: 13
                                color: "#6B7280"
                            }
                            
                            Text {
                                text: "Se connecter"
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
    }

    Connections {
        target: authManager
        function onRegisterSuccess() {
            nextBtn.isLoading = false;
            nextBtn.enabled = true;
            currentStep = 5; // Show success screen
        }
        function onRegisterFailed(msg) {
            nextBtn.isLoading = false;
            nextBtn.enabled = true;
            formErrorBanner.text = msg;
        }
    }
}
