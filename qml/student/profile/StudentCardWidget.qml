import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    color: "white"
    radius: 12
    height: 380
    
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowOpacity: 0.05
        shadowBlur: 15
        shadowVerticalOffset: 4
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "🛡️"
                font.pixelSize: 18
            }
            Text {
                text: "Carte étudiant"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: "#111827"
                Layout.fillWidth: true
            }
            Text {
                text: "⋮"
                font.pixelSize: 24
                color: "#6B7280"
                font.weight: Font.Bold
            }
        }

        // The ID Card
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            radius: 12
            color: "white"
            border.width: 1
            border.color: "#E5E7EB"
            clip: true
            
            // Top Dark Blue Header
            Rectangle {
                width: parent.width
                height: 60
                color: "#0B2745" // Very dark blue
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    Text { text: "📖"; font.pixelSize: 24; color: "white" } // Logo placeholder
                    ColumnLayout {
                        spacing: -2
                        Text {
                            text: "UNIVERSITÉ"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            color: "white"
                        }
                        Text {
                            text: "EXCELLENCE"
                            font.family: "Inter"
                            font.pixelSize: 12
                            color: "white"
                            opacity: 0.8
                        }
                    }
                }
            }
            
            // Bottom White Area
            Item {
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 60
                anchors.bottom: parent.bottom
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    // Small Photo
                    Rectangle {
                        width: 70
                        height: 70
                        radius: 35
                        color: "#F3F4F6"
                        clip: true
                        
                        Image {
                            anchors.fill: parent
                            source: studentService.profile.photo_url ? "file:///" + studentService.profile.photo_url : "qrc:/assets/default_avatar.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    
                    // Info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: (studentService.profile.prenom || "") + " " + (studentService.profile.nom || "")
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.Bold
                            color: "#111827"
                        }
                        Text {
                            text: studentService.profile.matricule || "ETU-2026-001"
                            font.family: "Inter"
                            font.pixelSize: 12
                            color: "#4B5563"
                        }
                        Text {
                            text: (studentService.profile.filiere || "Science Informatique") + "\n" + (studentService.profile.niveau || "2e année")
                            font.family: "Inter"
                            font.pixelSize: 12
                            color: "#6B7280"
                            Layout.topMargin: 4
                        }
                        
                        RowLayout {
                            Layout.topMargin: 6
                            spacing: 4
                            Text {
                                text: "Statut :"
                                font.family: "Inter"
                                font.pixelSize: 12
                                color: "#6B7280"
                            }
                            Text {
                                text: studentService.profile.statut || "Actif"
                                font.family: "Inter"
                                font.pixelSize: 12
                                font.weight: Font.Medium
                                color: "#31C48D" // Green
                            }
                        }
                    }
                    
                    // QR Code (Placeholder)
                    Rectangle {
                        width: 60
                        height: 60
                        color: "white"
                        Layout.alignment: Qt.AlignVCenter
                        
                        Image {
                            anchors.fill: parent
                            // Using a placeholder QR code image or generated icon
                            // For now, draw some boxes to emulate a QR code
                            Rectangle { width: 15; height: 15; color: "black"; anchors.left: parent.left; anchors.top: parent.top }
                            Rectangle { width: 15; height: 15; color: "black"; anchors.right: parent.right; anchors.top: parent.top }
                            Rectangle { width: 15; height: 15; color: "black"; anchors.left: parent.left; anchors.bottom: parent.bottom }
                            Rectangle { width: 8; height: 8; color: "black"; anchors.right: parent.right; anchors.bottom: parent.bottom }
                            Grid {
                                anchors.centerIn: parent
                                columns: 3
                                spacing: 2
                                Repeater {
                                    model: 9
                                    Rectangle { width: 6; height: 6; color: index%2==0 ? "black" : "transparent" }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 8
                color: "#0056D2"
                
                Text {
                    anchors.centerIn: parent
                    text: "Télécharger"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "white"
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.opacity = 0.9
                    onExited: parent.opacity = 1.0
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 8
                color: "white"
                border.width: 1
                border.color: "#D1D5DB"
                
                Text {
                    anchors.centerIn: parent
                    text: "Imprimer"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#374151"
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.color = "#F9FAFB"
                    onExited: parent.color = "white"
                }
            }
        }
    }
}
