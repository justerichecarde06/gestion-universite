import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import QtQuick.Effects
import "components"

Item {
    id: root
    anchors.fill: parent

    signal loginAccepted(string role, string name)
    signal registerRequested()
    signal forgotPasswordRequested()

    Settings {
        id: settings
        category: "Login"
        property string savedIdentifier: ""
        property string savedPassword: ""
        property bool rememberMe: false
    }

    Component.onCompleted: {
        if (settings.rememberMe) {
            identifierField.text = settings.savedIdentifier;
            passwordField.text = settings.savedPassword;
            rememberMeCheckbox.checked = true;
        }
    }

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
                orientation: Gradient.Horizontal // Diagonal approximation
            }

            // Decor: abstract triangles
            Canvas {
                anchors.fill: parent
                opacity: 0.15
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.fillStyle = "white";
                    
                    // Triangle 1
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width * 0.8, 0);
                    ctx.lineTo(0, height * 0.5);
                    ctx.fill();
                    
                    // Triangle 2
                    ctx.beginPath();
                    ctx.moveTo(width, height * 0.2);
                    ctx.lineTo(width, height);
                    ctx.lineTo(width * 0.3, height);
                    ctx.fill();
                    
                    // Triangle 3 (center)
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

                // Logo in a circle
                Rectangle {
                    width: 172
                    height: 172
                    radius: 86
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    // Shadow
                    Rectangle {
                        anchors.fill: parent
                        radius: 86
                        color: "black"
                        opacity: 0.2
                        z: -1
                        anchors.verticalCenterOffset: 4
                    }

                    Image {
                        source: "qrc:/assets/logo_usfah.png"
                        anchors.centerIn: parent
                        width: 140
                        height: 140
                        fillMode: Image.PreserveAspectFit
                        // Fallback text if image missing
                        Text {
                            anchors.centerIn: parent
                            text: "USFAH"
                            font.bold: true
                            font.pixelSize: 24
                            color: "#01406D"
                            visible: parent.status === Image.Error || parent.status === Image.Null
                        }
                    }
                }

                // PORTAIL ETUDIANT
                Text {
                    text: "PORTAIL ÉTUDIANT"
                    font.family: "IBM Plex Mono"
                    color: "#FF7A0F"
                    font.letterSpacing: 2.0
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Titre
                Text {
                    text: "Université Saint François\nd'Assise d'Haïti"
                    font.family: "Fraunces" // serif fallback handled in main.qml
                    color: "white"
                    font.pixelSize: 34
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Sous-titre
                Text {
                    text: "Scientia et Fides"
                    font.family: "Fraunces"
                    font.italic: true
                    color: "white"
                    opacity: 0.8
                    font.pixelSize: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Descriptif
                Text {
                    text: "Accédez à votre espace personnel pour consulter vos\ncours, vos notes, votre emploi du temps et vos\ndocuments administratifs."
                    font.family: "Inter"
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 10
                }

                // Ligne de séparation
                Rectangle {
                    width: parent.width * 0.8
                    height: 1
                    color: "white"
                    opacity: 0.2
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Statistiques
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 40

                    Column {
                        spacing: 4
                        Text { text: "USFAH"; color: "#FF7A0F"; font.family: "Fraunces"; font.bold: true; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: "DEPUIS 1987"; color: "white"; opacity: 0.7; font.family: "IBM Plex Mono"; font.pixelSize: 10; font.letterSpacing: 1.0; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                    Column {
                        spacing: 4
                        Text { text: "7"; color: "#FF7A0F"; font.family: "Fraunces"; font.bold: true; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: "FACULTÉS"; color: "white"; opacity: 0.7; font.family: "IBM Plex Mono"; font.pixelSize: 10; font.letterSpacing: 1.0; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                    Column {
                        spacing: 4
                        Text { text: "100%"; color: "#FF7A0F"; font.family: "Fraunces"; font.bold: true; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: "EN LIGNE"; color: "white"; opacity: 0.7; font.family: "IBM Plex Mono"; font.pixelSize: 10; font.letterSpacing: 1.0; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }
            }
        }

        // ================= PANNEAU DROIT =================
        Rectangle {
            id: rightPanel
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#F5FEFE"
            
            // Subtiel radial gradient top right
            Rectangle {
                width: 400
                height: 400
                radius: 200
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: -100
                color: "#01B4BA"
                opacity: 0.05
                layer.enabled: true
                layer.effect: MultiEffect { blurEnabled: true; blurMax: 100; blur: 1.0 }
            }

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

                    // Headers
                    Column {
                        spacing: 8
                        
                        Text {
                            text: "CONNEXION — USFAH"
                            font.family: "IBM Plex Mono"
                            color: "#01B4BA"
                            font.letterSpacing: 1.5
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "Connexion"
                            font.family: "Fraunces"
                            color: "#032B4A"
                            font.pixelSize: 36
                            font.weight: Font.Bold
                        }

                        Text {
                            text: "Entrez vos identifiants pour accéder à votre espace\nuniversitaire."
                            font.family: "Inter"
                            color: "#6B7280"
                            font.pixelSize: 14
                            lineHeight: 1.4
                        }
                    }

                    // Form Fields
                    Column {
                        width: parent.width
                        spacing: 16

                        StyledTextField {
                            id: identifierField
                            labelText: "Matricule ou email"
                            placeholder: "ex : 2023-usfah-0451"
                            iconText: "✉"
                            
                            // Real-time basic validation
                            onTextChanged: {
                                errorText = ""
                            }
                        }

                        StyledTextField {
                            id: passwordField
                            labelText: "Mot de passe"
                            placeholder: "••••••••"
                            iconText: "🔒"
                            isPassword: true
                            
                            onTextChanged: {
                                errorText = ""
                            }
                        }
                        
                        // Error message banner
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

                    // Options Row
                    RowLayout {
                        width: parent.width
                        
                        Checkbox {
                            id: rememberMeCheckbox
                            Layout.alignment: Qt.AlignLeft
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "Mot de passe oublié ?"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            color: "#032B4A"
                            font.underline: true
                            
                            // Custom underline with orange color is tricky in plain text, 
                            // we can use a custom rectangle for the underline
                            Rectangle {
                                width: parent.width
                                height: 2
                                color: "#FF7A0F"
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -2
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.forgotPasswordRequested()
                                }
                            }
                        }
                    }

                    // Connect Button
                    PrimaryButton {
                        id: loginButton
                        enabled: identifierField.text.length > 0 && passwordField.text.length >= 4
                        
                        onClicked: {
                            // Reset errors
                            identifierField.errorText = ""
                            passwordField.errorText = ""
                            formErrorBanner.text = ""
                            
                            // Validations
                            let isValid = true;
                            if (passwordField.text.length < 8) {
                                passwordField.errorText = "Le mot de passe doit contenir au moins 8 caractères."
                                isValid = false;
                            }
                            
                            if (isValid) {
                                isLoading = true;
                                enabled = false;
                                
                                // Simulate network delay
                                loadingTimer.start();
                            }
                        }
                    }

                    // Need help divider
                    Item {
                        width: parent.width
                        height: 40
                        
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "#E5E7EB"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Rectangle {
                            color: "#F5FEFE"
                            width: helpText.width + 20
                            height: parent.height
                            anchors.centerIn: parent
                            
                            Text {
                                id: helpText
                                text: "BESOIN D'AIDE"
                                font.family: "IBM Plex Mono"
                                color: "#9CA3AF"
                                font.pixelSize: 10
                                font.letterSpacing: 1.0
                                anchors.centerIn: parent
                            }
                        }
                    }

                    // Register and Contact links
                    Column {
                        width: parent.width
                        spacing: 12
                        
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4
                            
                            Text {
                                text: "Pas encore de compte ?"
                                font.family: "Inter"
                                font.pixelSize: 13
                                color: "#6B7280"
                            }
                            
                            Text {
                                text: "Créer un compte"
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
                                    onClicked: root.registerRequested()
                                }
                            }
                        }
                        
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4
                            
                            Text {
                                text: "Problème de connexion ?"
                                font.family: "Inter"
                                font.pixelSize: 13
                                color: "#6B7280"
                            }
                            
                            Text {
                                text: "Contactez le service informatique"
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
                                    onClicked: console.log("Contact support")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: loadingTimer
        interval: 800 // simulate network
        onTriggered: {
            loginButton.isLoading = false;
            loginButton.enabled = true;
            authManager.login(identifierField.text, passwordField.text);
        }
    }
    
    Connections {
        target: authManager
        function onLoginSuccess(role, name) {
            console.log("Connecté en tant que:", name, "Rôle:", role);
            
            // Save settings
            settings.rememberMe = rememberMeCheckbox.checked;
            if (rememberMeCheckbox.checked) {
                settings.savedIdentifier = identifierField.text;
                settings.savedPassword = passwordField.text;
            } else {
                settings.savedIdentifier = "";
                settings.savedPassword = "";
            }
            
            root.loginAccepted(role, name);
        }
        function onLoginFailed(msg) {
            formErrorBanner.text = msg;
        }
    }
}
