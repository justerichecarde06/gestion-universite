import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent
    
    property int currentTab: 0
    property var tabs: [
        { name: "Général", icon: "⚙️" },
        { name: "Sécurité", icon: "🔒" },
        { name: "Notifications", icon: "🔔" },
        { name: "Académique", icon: "🎓" },
        { name: "Système", icon: "🖥️" },
        { name: "Sauvegarde", icon: "☁️" }
    ]

    Connections {
        target: adminSettingsService
        function onShowMessage(message, isError) {
            toast.text = message
            toast.color = isError ? "#EF4444" : "#10B981"
            toast.opacity = 1
            toastTimer.restart()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#F3F4F6"
        
        ScrollView {
            anchors.fill: parent
            contentWidth: Math.max(width, 1000)
            contentHeight: mainContent.implicitHeight + 60
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ColumnLayout {
                id: mainContent
                width: Math.max(parent.width - 60, 1000)
                x: 30; y: 30
                spacing: 24

                // HEADER
                RowLayout {
                    Layout.fillWidth: true
                    Column {
                        spacing: 4
                        Text { text: "Paramètres"; font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Gérez les paramètres globaux du portail."; font.family: "Inter"; font.pixelSize: 14; color: "#6B7280" }
                    }
                    Item { Layout.fillWidth: true }
                    RowLayout {
                        spacing: 12
                        Rectangle {
                            width: 44; height: 44; radius: 22; color: "white"; border.color: "#E5E7EB"; border.width: 1
                            Text { anchors.centerIn: parent; text: "🔔"; font.pixelSize: 20 }
                            Rectangle { width: 18; height: 18; radius: 9; color: "#EF4444"; anchors.top: parent.top; anchors.right: parent.right; Text { anchors.centerIn: parent; text: "5"; color: "white"; font.pixelSize: 10; font.weight: Font.Bold } }
                        }
                        Rectangle {
                            width: 160; height: 44; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 12; spacing: 8
                                Text { text: "📅"; font.pixelSize: 16 }
                                Text { text: "21 Juillet 2025"; font.family: "Inter"; font.pixelSize: 14; color: "#374151" }
                            }
                        }
                    }
                }

                // TABS
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    color: "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        spacing: 32
                        
                        Repeater {
                            model: root.tabs
                            delegate: Item {
                                Layout.preferredWidth: tabText.width + tabIcon.width + 12
                                Layout.fillHeight: true
                                
                                property bool isActive: root.currentTab === index
                                
                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 8
                                    Text { id: tabIcon; text: modelData.icon; font.pixelSize: 16; opacity: isActive ? 1.0 : 0.6 }
                                    Text { id: tabText; text: modelData.name; font.family: "Inter"; font.pixelSize: 14; font.weight: isActive ? Font.Bold : Font.Medium; color: isActive ? "#2563EB" : "#4B5563" }
                                }
                                
                                Rectangle {
                                    width: parent.width + 16
                                    height: 2
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    color: "#2563EB"
                                    visible: isActive
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.currentTab = index
                                }
                            }
                        }
                    }
                    
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#E5E7EB"
                        anchors.bottom: parent.bottom
                    }
                }

                // TAB CONTENTS
                StackLayout {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 600
                    currentIndex: root.currentTab

                    // TAB 0: Général
                    ColumnLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 24
                            
                            // Informations générales
                            Rectangle {
                                Layout.fillWidth: true; Layout.preferredHeight: 320
                                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                                
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 24; spacing: 16
                                    RowLayout {
                                        spacing: 12
                                        Rectangle { width: 32; height: 32; radius: 8; color: "#EFF6FF"; Text { anchors.centerIn: parent; text: "🏛️"; font.pixelSize: 16 } }
                                        Text { text: "Informations générales"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                                    }
                                    
                                    GridLayout {
                                        Layout.fillWidth: true; columns: 2; columnSpacing: 24; rowSpacing: 16
                                        Text { text: "Nom de l'établissement"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        TextField { id: etablissementField; text: adminSettingsService.generalSettings["general.nom_etablissement"] || ""; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                        
                                        Text { text: "Email de contact"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        TextField { id: emailField; text: adminSettingsService.generalSettings["general.email"] || ""; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                        
                                        Text { text: "Téléphone"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        TextField { id: telField; text: adminSettingsService.generalSettings["general.telephone"] || ""; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                        
                                        Text { text: "Adresse"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        TextField { id: adresseField; text: adminSettingsService.generalSettings["general.adresse"] || ""; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                    }
                                    
                                    Item { Layout.fillHeight: true }
                                    
                                    Rectangle {
                                        Layout.alignment: Qt.AlignRight; Layout.preferredWidth: 200; Layout.preferredHeight: 36; radius: 6; color: "#2563EB"
                                        Text { anchors.centerIn: parent; text: "💾 Enregistrer les modifications"; color: "white"; font.pixelSize: 13; font.weight: Font.Medium }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: {
                                            let s = { "general.nom_etablissement": etablissementField.text, "general.email": emailField.text, "general.telephone": telField.text, "general.adresse": adresseField.text }
                                            adminSettingsService.saveGeneralSettings(s)
                                        }}
                                    }
                                }
                            }
                            
                            // Paramètres de l'établissement
                            Rectangle {
                                Layout.fillWidth: true; Layout.preferredHeight: 320
                                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                                
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 24; spacing: 16
                                    RowLayout {
                                        spacing: 12
                                        Rectangle { width: 32; height: 32; radius: 8; color: "#F5F3FF"; Text { anchors.centerIn: parent; text: "🎛️"; font.pixelSize: 16 } }
                                        Text { text: "Paramètres de l'établissement"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                                    }
                                    
                                    GridLayout {
                                        Layout.fillWidth: true; columns: 2; columnSpacing: 24; rowSpacing: 16
                                        Text { text: "Année académique en cours"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        ComboBox { id: anneeCombo; model: ["2023 - 2024", "2024 - 2025", "2025 - 2026"]; currentIndex: 1; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                        
                                        Text { text: "Date de début des cours"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        TextField { id: debutField; text: adminSettingsService.generalSettings["etablissement.date_debut"] || ""; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                        
                                        Text { text: "Date de fin des cours"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        TextField { id: finField; text: adminSettingsService.generalSettings["etablissement.date_fin"] || ""; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                        
                                        Text { text: "Devise"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        ComboBox { id: deviseCombo; model: ["USD (Dollar américain)", "HTG (Gourde)", "EUR (Euro)"]; currentIndex: 0; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                        
                                        Text { text: "Fuseau horaire"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        ComboBox { id: tzCombo; model: ["(UTC-04:00) Port-au-Prince", "(UTC-05:00) EST"]; currentIndex: 0; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 36 } }
                                    }
                                    
                                    Item { Layout.fillHeight: true }
                                    
                                    Rectangle {
                                        Layout.alignment: Qt.AlignRight; Layout.preferredWidth: 200; Layout.preferredHeight: 36; radius: 6; color: "white"; border.color: "#2563EB"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "🔓 Enregistrer les modifications"; color: "#2563EB"; font.pixelSize: 13; font.weight: Font.Medium }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: {
                                            let s = { "etablissement.annee_academique": anneeCombo.currentText, "etablissement.date_debut": debutField.text, "etablissement.date_fin": finField.text }
                                            adminSettingsService.saveGeneralSettings(s)
                                        }}
                                    }
                                }
                            }
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 24
                            
                            // Apparence
                            Rectangle {
                                Layout.fillWidth: true; Layout.preferredHeight: 300
                                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                                
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 24; spacing: 16
                                    RowLayout {
                                        spacing: 12
                                        Rectangle { width: 32; height: 32; radius: 8; color: "#F0FDF4"; Text { anchors.centerIn: parent; text: "🛡️"; font.pixelSize: 16 } }
                                        Text { text: "Paramètres d'apparence"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                                    }
                                    
                                    Text { text: "Thème principal"; font.pixelSize: 13; color: "#4B5563" }
                                    RowLayout {
                                        spacing: 12
                                        Repeater {
                                            model: ["#2563EB", "#8B5CF6", "#F59E0B", "#EF4444", "#111827"]
                                            Rectangle { width: 24; height: 24; radius: 12; color: modelData; border.color: index===0 ? "#60A5FA" : "transparent"; border.width: 2; Text { anchors.centerIn: parent; text: "✓"; color: "white"; visible: index===0 } }
                                        }
                                    }
                                    
                                    Text { text: "Mode d'affichage"; font.pixelSize: 13; color: "#4B5563"; Layout.topMargin: 8 }
                                    RowLayout {
                                        spacing: 0
                                        Rectangle {
                                            width: 120
                                            height: 36
                                            radius: 6
                                            color: "#F3F4F6"
                                            border.color: "#2563EB"
                                            border.width: 1
                                            RowLayout {
                                                anchors.centerIn: parent
                                                spacing: 8
                                                Text { text: "☀️"; font.pixelSize: 14 }
                                                Text { text: "Clair"; color: "#111827"; font.pixelSize: 13; font.weight: Font.Medium }
                                            }
                                        }
                                        Rectangle {
                                            width: 120; height: 36; radius: 6; color: "white"; border.color: "#E5E7EB"; border.width: 1
                                            RowLayout {
                                                anchors.centerIn: parent
                                                spacing: 8
                                                Text { text: "🌙"; font.pixelSize: 14; opacity: 0.5 }
                                                Text { text: "Sombre"; color: "#6B7280"; font.pixelSize: 13 }
                                            }
                                        }
                                    }
                                    
                                    Item { Layout.fillHeight: true }
                                    Rectangle {
                                        Layout.alignment: Qt.AlignRight; Layout.preferredWidth: 100; Layout.preferredHeight: 36; radius: 6; color: "white"; border.color: "#E5E7EB"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Enregistrer"; color: "#2563EB"; font.pixelSize: 13; font.weight: Font.Medium }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: adminSettingsService.saveGeneralSettings({"apparence.theme": "blue"}) }
                                    }
                                }
                            }
                            
                            // Inscriptions
                            Rectangle {
                                Layout.fillWidth: true; Layout.preferredHeight: 300
                                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                                
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 24; spacing: 16
                                    RowLayout {
                                        spacing: 12
                                        Rectangle { width: 32; height: 32; radius: 8; color: "#FFF7ED"; Text { anchors.centerIn: parent; text: "👤"; font.pixelSize: 16 } }
                                        Text { text: "Paramètres des inscriptions"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                                    }
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: "Inscriptions ouvertes"; font.pixelSize: 13; color: "#4B5563"; Layout.fillWidth: true }
                                        Rectangle { width: 44; height: 24; radius: 12; color: "#2563EB"; Rectangle { width: 20; height: 20; radius: 10; color: "white"; anchors.right: parent.right; anchors.rightMargin: 2; anchors.verticalCenter: parent.verticalCenter } }
                                    }
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: "Méthode d'approbation"; font.pixelSize: 13; color: "#4B5563"; Layout.fillWidth: true }
                                        ComboBox { model: ["Approbation manuelle", "Automatique"]; currentIndex: 0; Layout.preferredWidth: 160; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 32 } }
                                    }
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: "Limite d'inscriptions par utilisateur"; font.pixelSize: 13; color: "#4B5563"; Layout.fillWidth: true }
                                        TextField { text: "5"; Layout.preferredWidth: 60; horizontalAlignment: Text.AlignHCenter; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 32 } }
                                    }
                                    
                                    Item { Layout.fillHeight: true }
                                    Rectangle {
                                        Layout.alignment: Qt.AlignRight; Layout.preferredWidth: 100; Layout.preferredHeight: 36; radius: 6; color: "white"; border.color: "#E5E7EB"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Enregistrer"; color: "#2563EB"; font.pixelSize: 13; font.weight: Font.Medium }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: adminSettingsService.saveGeneralSettings({"inscriptions.ouvertes": "true"}) }
                                    }
                                }
                            }
                            
                            // Autres
                            Rectangle {
                                Layout.fillWidth: true; Layout.preferredHeight: 300
                                color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                                layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                                
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 24; spacing: 16
                                    RowLayout {
                                        spacing: 12
                                        Rectangle { width: 32; height: 32; radius: 8; color: "#FEF2F2"; Text { anchors.centerIn: parent; text: "✉️"; font.pixelSize: 16 } }
                                        Text { text: "Autres paramètres"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                                    }
                                    
                                    GridLayout {
                                        Layout.fillWidth: true; columns: 2; columnSpacing: 16; rowSpacing: 16
                                        Text { text: "Langue par défaut"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        ComboBox { model: ["Français", "Anglais"]; currentIndex: 0; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 32 } }
                                        
                                        Text { text: "Format de date"; font.pixelSize: 13; color: "#4B5563"; Layout.alignment: Qt.AlignVCenter }
                                        ComboBox { model: ["DD/MM/YYYY", "MM/DD/YYYY"]; currentIndex: 0; Layout.fillWidth: true; background: Rectangle { color: "white"; border.color: "#E5E7EB"; border.width: 1; radius: 6; implicitHeight: 32 } }
                                    }
                                    
                                    Item { Layout.fillHeight: true }
                                    Rectangle {
                                        Layout.alignment: Qt.AlignRight; Layout.preferredWidth: 100; Layout.preferredHeight: 36; radius: 6; color: "white"; border.color: "#E5E7EB"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Enregistrer"; color: "#2563EB"; font.pixelSize: 13; font.weight: Font.Medium }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: adminSettingsService.saveGeneralSettings({"autres.langue": "Français"}) }
                                    }
                                }
                            }
                        }
                    }

                    // TAB 1: Sécurité
                    ColumnLayout {
                        spacing: 24
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 300
                            color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 24; spacing: 16
                                Text { text: "Paramètres de Sécurité"; font.pixelSize: 20; font.weight: Font.Bold; color: "#111827" }
                                RowLayout {
                                    Text { text: "Authentification à double facteur (2FA)"; font.pixelSize: 14; color: "#4B5563"; Layout.fillWidth: true }
                                    Switch { id: mfaSwitch; checked: adminSettingsService.securitySettings["sec.mfa_enabled"] === "true" }
                                }
                                RowLayout {
                                    Text { text: "Expiration des mots de passe (jours)"; font.pixelSize: 14; color: "#4B5563"; Layout.fillWidth: true }
                                    TextField { id: pwdExp; text: adminSettingsService.securitySettings["sec.password_expiration_days"] || "90" }
                                }
                                Item { Layout.fillHeight: true }
                                Button {
                                    text: "Enregistrer la sécurité"
                                    onClicked: adminSettingsService.saveSecuritySettings({"sec.mfa_enabled": mfaSwitch.checked ? "true" : "false", "sec.password_expiration_days": pwdExp.text})
                                }
                            }
                        }
                    }

                    // TAB 2: Notifications
                    ColumnLayout {
                        spacing: 24
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 300
                            color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 24; spacing: 16
                                Text { text: "Configurations des Notifications"; font.pixelSize: 20; font.weight: Font.Bold; color: "#111827" }
                                CheckBox { id: notifInscr; text: "Email à chaque nouvelle inscription"; checked: adminSettingsService.notificationSettings["notif.email_nouvelle_inscription"] === "true" }
                                CheckBox { id: notifPay; text: "Email lors des paiements validés"; checked: adminSettingsService.notificationSettings["notif.email_paiement"] === "true" }
                                Item { Layout.fillHeight: true }
                                Button {
                                    text: "Enregistrer notifications"
                                    onClicked: adminSettingsService.saveNotificationSettings({"notif.email_nouvelle_inscription": notifInscr.checked ? "true" : "false", "notif.email_paiement": notifPay.checked ? "true" : "false"})
                                }
                            }
                        }
                    }

                    // TAB 3: Académique
                    ColumnLayout {
                        spacing: 24
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 300
                            color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 24; spacing: 16
                                Text { text: "Politique Académique"; font.pixelSize: 20; font.weight: Font.Bold; color: "#111827" }
                                RowLayout {
                                    Text { text: "Note minimale de passage"; font.pixelSize: 14; color: "#4B5563"; Layout.fillWidth: true }
                                    TextField { id: notePass; text: adminSettingsService.academicSettings["acad.note_passage"] || "60" }
                                }
                                Item { Layout.fillHeight: true }
                                Button {
                                    text: "Enregistrer académique"
                                    onClicked: adminSettingsService.saveAcademicSettings({"acad.note_passage": notePass.text})
                                }
                            }
                        }
                    }

                    // TAB 4: Système
                    ColumnLayout {
                        spacing: 24
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 300
                            color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 24; spacing: 16
                                Text { text: "État du Système"; font.pixelSize: 20; font.weight: Font.Bold; color: "#111827" }
                                Text { text: "Version du portail: v1.0.0 (Stable)"; font.pixelSize: 14; color: "#4B5563" }
                                Text { text: "Dernière mise à jour: Aujourd'hui"; font.pixelSize: 14; color: "#4B5563" }
                                Item { Layout.fillHeight: true }
                            }
                        }
                    }

                    // TAB 5: Sauvegarde
                    ColumnLayout {
                        spacing: 24
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 300
                            color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 24; spacing: 16
                                Text { text: "Sauvegarde & Restauration"; font.pixelSize: 20; font.weight: Font.Bold; color: "#111827" }
                                Text { text: "Dernière sauvegarde réussie: " + (adminSettingsService.backupSettings["backup.last_backup_date"] || "Inconnue"); font.pixelSize: 14; color: "#16A34A" }
                                RowLayout {
                                    Text { text: "Sauvegarde automatique"; font.pixelSize: 14; color: "#4B5563"; Layout.fillWidth: true }
                                    Switch { id: autoBackup; checked: adminSettingsService.backupSettings["backup.auto_backup"] === "true" }
                                }
                                Item { Layout.fillHeight: true }
                                RowLayout {
                                    Button {
                                        text: "Sauvegarder auto"
                                        onClicked: adminSettingsService.saveBackupSettings({"backup.auto_backup": autoBackup.checked ? "true" : "false"})
                                    }
                                    Button {
                                        text: "Déclencher une sauvegarde manuelle"
                                        onClicked: adminSettingsService.triggerBackup()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Toast Notification
    Rectangle {
        id: toast
        width: 300
        height: 50
        radius: 8
        color: "#10B981" // Green success by default
        opacity: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        layer.enabled: true
        layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.1; shadowBlur: 10 }
        
        property alias text: toastText.text
        
        Text {
            id: toastText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 14
            font.weight: Font.Medium
        }
        
        Behavior on opacity { NumberAnimation { duration: 300 } }
        
        Timer {
            id: toastTimer
            interval: 3000
            onTriggered: toast.opacity = 0
        }
    }
}
