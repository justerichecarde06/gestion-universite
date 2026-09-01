import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "admin"

Item {
    id: root
    anchors.fill: parent
    
    signal logout()

    // Color Palette based on the image
    property color sidebarBg: "#052644"
    property color activeMenuBg: "#08416B"
    property color inactiveMenuText: "#8FA3B8"
    property color orangeAccent: "#EF6C00"
    property color blueAccent: "#003A69"

    // Default Fonts
    property string fontBold: "Inter"
    property string fontRegular: "Inter"
    
    property int currentViewIndex: 0

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==========================================
        // SIDEBAR
        // ==========================================
        Rectangle {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: 260
            color: root.sidebarBg

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Header
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30
                        spacing: 4
                        
                        Text {
                            text: "ADMINISTRATEUR"
                            font.family: root.fontBold
                            color: root.orangeAccent
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            font.letterSpacing: 1.5
                        }
                        
                        Text {
                            text: "Portail USFAH"
                            font.family: root.fontBold
                            color: "white"
                            font.pixelSize: 22
                            font.weight: Font.Bold
                        }
                    }
                    
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "white"
                        opacity: 0.1
                        anchors.bottom: parent.bottom
                    }
                }

                // Menu Items
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    spacing: 8

                    Repeater {
                        model: [
                            { text: "Tableau de bord", icon: "🏠", index: 0 },
                            { text: "Inscriptions", icon: "📝", index: 1 },
                            { text: "Utilisateurs", icon: "👥", index: 2 },
                            { text: "Cours", icon: "📚", index: 3 },
                            { text: "Notes", icon: "🧾", index: 4 },
                            { text: "Emploi du temps", icon: "📅", index: 5 },
                            { text: "Finances", icon: "💰", index: 6 },
                            { text: "Paramètres", icon: "⚙️", index: 7 }
                        ]
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            
                            property bool isActive: root.currentViewIndex === modelData.index
                            color: isActive ? root.activeMenuBg : "transparent"
                            
                            // Left border for active
                            Rectangle {
                                width: 4
                                height: parent.height
                                color: root.orangeAccent
                                visible: isActive
                                anchors.left: parent.left
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 30
                                spacing: 16
                                
                                Text {
                                    text: modelData.icon
                                    color: isActive ? "white" : root.inactiveMenuText
                                    font.pixelSize: 18
                                }
                                
                                Text {
                                    text: modelData.text
                                    color: isActive ? "white" : root.inactiveMenuText
                                    font.family: root.fontRegular
                                    font.pixelSize: 14
                                    font.weight: isActive ? Font.DemiBold : Font.Normal
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: root.currentViewIndex = modelData.index
                                onEntered: if(!isActive) parent.color = Qt.rgba(255,255,255,0.05)
                                onExited: if(!isActive) parent.color = "transparent"
                            }
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }
                }
                
                // Logout Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    Layout.topMargin: 20
                    color: "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 30
                        spacing: 16
                        
                        Text {
                            text: "🚪"
                            color: "white"
                            font.pixelSize: 18
                        }
                        
                        Text {
                            text: "Déconnexion"
                            color: "white"
                            font.family: root.fontRegular
                            font.pixelSize: 14
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.color = Qt.rgba(255,255,255,0.05)
                        onExited: parent.color = "transparent"
                        onClicked: root.logout()
                    }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Item { Layout.fillHeight: true } // Spacer

                // User Profile
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: root.sidebarBg // transparent
                    
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "white"
                        opacity: 0.1
                        anchors.top: parent.top
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        // Avatar (Mock)
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: "#D9D9D9"
                            Layout.alignment: Qt.AlignVCenter
                            
                            Text {
                                text: "A"
                                anchors.centerIn: parent
                                color: root.blueAccent
                                font.pixelSize: 20
                                font.weight: Font.Bold
                            }
                            
                            // Online indicator
                            Rectangle {
                                width: 10
                                height: 10
                                radius: 5
                                color: "#10B981"
                                border.width: 2
                                border.color: root.sidebarBg
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            Text {
                                text: "Admin USFAH"
                                color: "white"
                                font.family: root.fontBold
                                font.pixelSize: 14
                                font.weight: Font.DemiBold
                            }
                            
                            Text {
                                text: "Administrateur"
                                color: root.inactiveMenuText
                                font.family: root.fontRegular
                                font.pixelSize: 12
                            }
                        }
                        
                        Text {
                            text: "⌄"
                            color: "white"
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }
            }
        }

        // ==========================================
        // MAIN CONTENT STACK
        // ==========================================
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.currentViewIndex

            Overview {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onRequestNavigation: function(index) {
                    root.currentViewIndex = index;
                }
            }
            
            RegistrationRequestsView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UsersView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            CoursesView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            GradesView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            ScheduleView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            FinancesView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            SettingsView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
