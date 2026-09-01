import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Dialogs

Rectangle {
    id: root
    width: parent.width
    height: 310
    color: "white"
    radius: 12
    
    // Drop shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowOpacity: 0.05
        shadowBlur: 15
        shadowVerticalOffset: 4
    }

    // Top Blue Banner
    Rectangle {
        id: blueBanner
        width: parent.width
        height: 240
        color: "#0348B4" // Main vibrant blue
        
        // Ensure only top corners are rounded
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: ShaderEffectSource {
                sourceItem: Rectangle {
                    width: blueBanner.width
                    height: blueBanner.height
                    radius: 12
                    Rectangle {
                        width: parent.width
                        height: 12
                        anchors.bottom: parent.bottom
                        color: "black"
                    }
                }
            }
        }

        // Faint university image pattern or gradient (using gradient for now to emulate the rich texture)
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#002875" }
                GradientStop { position: 1.0; color: "#0A5FD8" }
            }
            opacity: 0.7
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 32
            anchors.bottomMargin: 24
            spacing: 32
            
            // Avatar Section
            Item {
                width: 140
                height: 140
                Layout.alignment: Qt.AlignVCenter
                
                Rectangle {
                    id: avatarBg
                    width: 140
                    height: 140
                    radius: 70
                    color: "white"
                    border.width: 4
                    border.color: "white"
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowOpacity: 0.3
                        shadowBlur: 20
                    }
                    
                    Image {
                        id: avatarImg
                        anchors.fill: parent
                        anchors.margins: 4
                        source: studentService.profile.photo_url ? "file:///" + studentService.profile.photo_url : "qrc:/assets/default_avatar.png"
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            maskEnabled: true
                            maskSource: ShaderEffectSource {
                                sourceItem: Rectangle {
                                    width: avatarImg.width
                                    height: avatarImg.height
                                    radius: width / 2
                                }
                            }
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: (studentService.profile.prenom ? studentService.profile.prenom.charAt(0) : "") + 
                              (studentService.profile.nom ? studentService.profile.nom.charAt(0) : "")
                        font.pixelSize: 48
                        font.weight: Font.Bold
                        color: "#032B4A"
                        visible: !studentService.profile.photo_url
                    }
                    
                    // Edit button overlay
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: "#0056D2"
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.margins: 2
                        border.width: 3
                        border.color: "white"
                        
                        Text {
                            anchors.centerIn: parent
                            text: "📷"
                            font.pixelSize: 16
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: fileDialog.open()
                        }
                    }
                }
            }

            // Info Section
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 12

                // Name + verified check
                RowLayout {
                    spacing: 12
                    Text {
                        text: (studentService.profile.prenom || "") + " " + (studentService.profile.nom || "")
                        font.family: "Inter"
                        font.pixelSize: 32
                        font.weight: Font.Bold
                        color: "white"
                    }
                    Rectangle {
                        width: 24
                        height: 24
                        radius: 12
                        color: "#31C48D" // Green
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "white"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                        }
                    }
                }

                Text {
                    text: "Matricule : " + (studentService.profile.matricule || "ETU-2026-001")
                    font.family: "Inter"
                    font.pixelSize: 15
                    color: "#E5E7EB"
                }

                // Tags
                RowLayout {
                    spacing: 12
                    
                    // Field Tag
                    Rectangle {
                        width: fieldRow.width + 24
                        height: 34
                        radius: 8
                        color: Qt.rgba(1, 1, 1, 0.15)
                        border.color: Qt.rgba(1, 1, 1, 0.3)
                        border.width: 1
                        
                        RowLayout {
                            id: fieldRow
                            anchors.centerIn: parent
                            spacing: 8
                            Text { text: "🏢"; font.pixelSize: 14 }
                            Text {
                                text: studentService.profile.filiere || "Science Informatique"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: "white"
                            }
                        }
                    }
                    
                    // Level Tag
                    Rectangle {
                        width: levelText.width + 24
                        height: 34
                        radius: 8
                        color: Qt.rgba(1, 1, 1, 0.15)
                        border.color: Qt.rgba(1, 1, 1, 0.3)
                        border.width: 1
                        
                        Text {
                            id: levelText
                            anchors.centerIn: parent
                            text: studentService.profile.niveau || "2e année"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "white"
                        }
                    }
                }
                
                // Status and Year
                RowLayout {
                    spacing: 16
                    Layout.topMargin: 4
                    
                    Rectangle {
                        width: statusRow.width + 24
                        height: 30
                        radius: 15
                        color: "#31C48D" // Green bg for active
                        
                        RowLayout {
                            id: statusRow
                            anchors.centerIn: parent
                            spacing: 6
                            Text {
                                text: studentService.profile.statut || "Actif"
                                font.family: "Inter"
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: "white"
                            }
                        }
                    }
                    
                    Text {
                        text: "Année académique 2026-2027"
                        font.family: "Inter"
                        font.pixelSize: 14
                        color: "#E5E7EB"
                    }
                }
            }

            // Edit Profile Button on Right
            Item {
                Layout.fillHeight: true
                width: 160
                
                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 160
                    height: 44
                    radius: 8
                    color: "#111827" // Dark button
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text { text: "✏️"; font.pixelSize: 14 }
                        Text {
                            text: "Modifier mon profil"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "white"
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.9
                        onExited: parent.opacity = 1.0
                    }
                }
            }
        }
    }

    // Tabs below banner
    RowLayout {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 24
        anchors.bottomMargin: 0
        height: 70
        spacing: 32

        Repeater {
            model: ["Aperçu", "Informations", "Parcours académique", "Documents", "Sécurité", "Activité"]
            
            Item {
                Layout.fillHeight: true
                width: tabText.width
                
                Text {
                    id: tabText
                    anchors.centerIn: parent
                    text: modelData
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: index === 0 ? Font.Bold : Font.Medium
                    color: index === 0 ? "#0056D2" : "#6B7280"
                }
                
                // Active tab indicator
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width + 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 4
                    radius: 2
                    color: "#0056D2"
                    visible: index === 0
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    // In a real app this would change the visible state
                }
            }
        }
        
        Item { Layout.fillWidth: true } // Spacer
    }
    
    FileDialog {
        id: fileDialog
        title: "Choisir une photo de profil"
        nameFilters: ["Images (*.png *.jpg *.jpeg)"]
        onAccepted: {
            var path = selectedFile.toString()
            if (path.startsWith("file:///")) {
                path = path.substring(8)
            } else if (path.startsWith("file://")) {
                path = path.substring(7)
            }
            studentService.updateProfilePhoto(path)
        }
    }
}

