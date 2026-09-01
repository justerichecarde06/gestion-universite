import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    
    // Properties to match the overall design system
    property color mainBg: "#F0F6F9"
    property color cardBg: "#FFFFFF"
    property color textColor: "#1A202C"
    property color textLight: "#718096"
    property color tealAccent: "#00B4B1"
    property color blueAccent: "#003A69"
    property color orangeAccent: "#EF6C00"
    property color greenPositive: "#38A169"
    property color redNegative: "#E53E3E"
    
    property string fontBold: "Inter"
    property string fontRegular: "Inter"

    property var usersList: []
    
    function loadUsers(searchQuery) {
        usersList = authManager.getAllUsers(searchQuery || "");
    }
    
    Component.onCompleted: {
        loadUsers("");
    }

    Connections {
        target: authManager
        function onInvitationSuccess(message) {
            console.log(message);
            addUserPopup.close();
            loadUsers(""); // Refresh the list
            nameInput.text = "";
            emailInput.text = "";
        }
        function onInvitationFailed(errorMessage) {
            console.error(errorMessage);
        }
        function onRegistrationRequestsChanged() {
            // When a user is approved, refresh the list
            loadUsers(searchInput.text);
        }
    }

    Rectangle {
        anchors.fill: parent
        color: root.mainBg

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 40
            spacing: 24

            // --- HEADER SECTION ---
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "Gestion des Utilisateurs"
                    font.family: root.fontBold
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: root.textColor
                }
                
                Item { Layout.fillWidth: true } // Spacer
                
                // Search Bar
                Rectangle {
                    width: 250
                    height: 40
                    radius: 8
                    color: "white"
                    border.color: "#E2E8F0"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8
                        
                        Text {
                            text: "🔍"
                            color: root.textLight
                            font.pixelSize: 14
                        }
                        
                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            font.pixelSize: 14
                            color: root.textColor
                            property string placeholderText: "Rechercher..."
                            
                            Text {
                                text: parent.placeholderText
                                color: "#A0AEC0"
                                visible: !parent.text && !parent.activeFocus
                                font.pixelSize: 14
                            }
                            
                            onTextChanged: loadUsers(text)
                        }
                    }
                }
                
                // Add Button
                Rectangle {
                    width: 180
                    height: 40
                    radius: 8
                    color: root.tealAccent
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Text {
                            text: "+"
                            color: "white"
                            font.pixelSize: 18
                            font.weight: Font.Bold
                        }
                        Text {
                            text: "Nouveau Profil"
                            color: "white"
                            font.family: root.fontBold
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.8
                        onExited: parent.opacity = 1.0
                        onClicked: {
                            addUserPopup.open()
                        }
                    }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }

            // --- DATA TABLE ---
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: root.cardBg
                radius: 12
                
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05; shadowColor: "#40000000" }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    // Table Header
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        color: "#F8FAFC"
                        radius: 12
                        
                        Rectangle { // Bottom flat for seamless integration
                            width: parent.width
                            height: parent.radius
                            color: parent.color
                            anchors.bottom: parent.bottom
                        }
                        
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "#E2E8F0"
                            anchors.bottom: parent.bottom
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            spacing: 16
                            
                            Text { text: "UTILISATEUR"; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textLight; Layout.preferredWidth: 250 }
                            Text { text: "RÔLE"; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textLight; Layout.preferredWidth: 150 }
                            Text { text: "EMAIL"; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textLight; Layout.fillWidth: true }
                            Text { text: "STATUT"; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textLight; Layout.preferredWidth: 100 }
                            Text { text: "ACTIONS"; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textLight; Layout.preferredWidth: 80; horizontalAlignment: Text.AlignHCenter }
                        }
                    }

                    // Table Body (ListView)
                    ListView {
                        id: usersListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        
                        model: root.usersList
                        
                        delegate: Rectangle {
                            width: usersListView.width
                            height: 70
                            color: hoverArea.containsMouse ? "#F7FAFC" : "transparent"
                            
                            Rectangle {
                                width: parent.width
                                height: 1
                                color: "#EDF2F7"
                                anchors.bottom: parent.bottom
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 20
                                anchors.rightMargin: 20
                                spacing: 16
                                
                                // User Column
                                RowLayout {
                                    Layout.preferredWidth: 250
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 40
                                        height: 40
                                        radius: 20
                                        color: modelData.role === "Étudiant" ? "#E6FFFA" : (modelData.role === "Professeur" ? "#EBF8FF" : "#FFF5EB")
                                        
                                        Text {
                                            text: modelData.initials
                                            color: modelData.role === "Étudiant" ? root.tealAccent : (modelData.role === "Professeur" ? root.blueAccent : root.orangeAccent)
                                            font.pixelSize: 14
                                            font.weight: Font.Bold
                                            anchors.centerIn: parent
                                        }
                                    }
                                    
                                    Column {
                                        Text { text: modelData.name; font.pixelSize: 14; font.weight: Font.DemiBold; color: root.textColor }
                                        Text { text: modelData.matricule ? "ID: " + modelData.matricule : "ID: N/A"; font.pixelSize: 11; color: root.textLight }
                                    }
                                }
                                
                                // Role Column
                                Rectangle {
                                    Layout.preferredWidth: 150
                                    height: 24
                                    radius: 12
                                    color: modelData.role === "Étudiant" ? "#E6FFFA" : (modelData.role === "Professeur" ? "#EBF8FF" : "#FFF5EB")
                                    Layout.alignment: Qt.AlignVCenter
                                    
                                    Text {
                                        text: modelData.role
                                        color: modelData.role === "Étudiant" ? root.tealAccent : (modelData.role === "Professeur" ? root.blueAccent : root.orangeAccent)
                                        font.pixelSize: 11
                                        font.weight: Font.DemiBold
                                        anchors.centerIn: parent
                                    }
                                }
                                
                                // Email Column
                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.email
                                    font.pixelSize: 13
                                    color: root.textLight
                                    elide: Text.ElideRight
                                }
                                
                                // Status Column
                                RowLayout {
                                    Layout.preferredWidth: 100
                                    spacing: 6
                                    
                                    Rectangle {
                                        width: 8
                                        height: 8
                                        radius: 4
                                        color: modelData.status === "Actif" ? root.greenPositive : root.redNegative
                                    }
                                    
                                    Text {
                                        text: modelData.status
                                        font.pixelSize: 13
                                        color: modelData.status === "Actif" ? root.greenPositive : root.redNegative
                                    }
                                }
                                
                                // Actions Column
                                RowLayout {
                                    Layout.preferredWidth: 80
                                    spacing: 12
                                    
                                    Text {
                                        text: "✎"
                                        font.pixelSize: 18
                                        color: editMouse.containsMouse ? root.blueAccent : root.textLight
                                        MouseArea {
                                            id: editMouse
                                            anchors.fill: parent
                                            anchors.margins: -5
                                            cursorShape: Qt.PointingHandCursor
                                            hoverEnabled: true
                                            onClicked: {
                                                console.log("Edit user:", modelData.name)
                                                // Functionality for Edit could open the popup pre-filled
                                            }
                                        }
                                    }
                                    
                                    Text {
                                        text: "🗑"
                                        font.pixelSize: 18
                                        color: deleteMouse.containsMouse ? root.redNegative : root.textLight
                                        MouseArea {
                                            id: deleteMouse
                                            anchors.fill: parent
                                            anchors.margins: -5
                                            cursorShape: Qt.PointingHandCursor
                                            hoverEnabled: true
                                            onClicked: {
                                                console.log("Delete user:", modelData.name)
                                                // Functionality to delete via authManager
                                            }
                                        }
                                    }
                                }
                            }
                            
                            MouseArea {
                                id: hoverArea
                                anchors.fill: parent
                                hoverEnabled: true
                                z: -1 // Behind the buttons
                            }
                        }
                        
                        // Add/Remove animation
                        add: Transition {
                            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
                            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 300 }
                        }
                        remove: Transition {
                            NumberAnimation { property: "opacity"; to: 0; duration: 200 }
                        }
                        displaced: Transition {
                            NumberAnimation { properties: "x,y"; duration: 200 }
                        }
                    }
                }
            }
        }
    }

    // --- ADD USER POPUP ---
    Popup {
        id: addUserPopup
        width: 400
        height: 380
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle {
            color: root.cardBg
            radius: 12
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 15; shadowOpacity: 0.2; shadowColor: "#40000000" }
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            
            Text {
                text: "Ajouter un Profil"
                font.family: root.fontBold
                font.pixelSize: 20
                font.weight: Font.Bold
                color: root.textColor
            }
            
            // Name Field
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Text { text: "Nom Complet"; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textLight }
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E2E8F0"; color: "#F8FAFC"
                    TextInput {
                        id: nameInput
                        anchors.fill: parent; anchors.margins: 10
                        font.pixelSize: 14; color: root.textColor; verticalAlignment: TextInput.AlignVCenter
                        clip: true
                    }
                }
            }
            
            // Email Field
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Text { text: "Adresse Email"; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textLight }
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E2E8F0"; color: "#F8FAFC"
                    TextInput {
                        id: emailInput
                        anchors.fill: parent; anchors.margins: 10
                        font.pixelSize: 14; color: root.textColor; verticalAlignment: TextInput.AlignVCenter
                        clip: true
                    }
                }
            }
            
            // Role Combobox mock
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Text { text: "Rôle de l'utilisateur"; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textLight }
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 6; border.color: "#E2E8F0"; color: "#F8FAFC"
                    ComboBox {
                        id: roleCombo
                        anchors.fill: parent
                        model: ["Étudiant", "Professeur", "Administrateur"]
                        background: Item {} // Transparent inside Rectangle
                        font.pixelSize: 14
                    }
                }
            }
            
            Item { Layout.fillHeight: true } // Spacer
            
            // Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 8; color: "#F1F5F9"
                    Text { text: "Annuler"; color: root.textLight; font.weight: Font.DemiBold; anchors.centerIn: parent }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                        onEntered: parent.color = "#E2E8F0"; onExited: parent.color = "#F1F5F9"
                        onClicked: addUserPopup.close()
                    }
                }
                
                Rectangle {
                    Layout.fillWidth: true; height: 40; radius: 8; color: root.tealAccent
                    Text { text: "Créer"; color: "white"; font.weight: Font.DemiBold; anchors.centerIn: parent }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                        onEntered: parent.opacity = 0.8; onExited: parent.opacity = 1.0
                        onClicked: {
                            if (nameInput.text.trim() !== "" && emailInput.text.trim() !== "") {
                                var parts = nameInput.text.trim().split(" ");
                                var prenom = parts[0];
                                var nom = parts.length > 1 ? parts.slice(1).join(" ") : "";
                                
                                var dbRole = "student";
                                if (roleCombo.currentText === "Professeur") dbRole = "professor";
                                else if (roleCombo.currentText === "Administrateur") dbRole = "admin";
                                else if (roleCombo.currentText === "Secrétaire") dbRole = "secretary";
                                else if (roleCombo.currentText === "Comptable") dbRole = "accountant";
                                
                                authManager.invitePersonnel(emailInput.text.trim(), nom, prenom, dbRole);
                            }
                        }
                    }
                }
            }
        }
    }
}
