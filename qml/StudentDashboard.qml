import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "components"
import "student" as StudentPages

Item {
    id: root
    anchors.fill: parent
    
    signal logout()
    property string userName: "Étudiant"
    // Use the first name if available in the model
    property string userFirstName: studentService.profile.prenom ? studentService.profile.prenom : "Étudiant"
    property string userEmail: studentService.profile.email ? studentService.profile.email : "etudiant@usfah.edu.ht"
    property int currentMenuIndex: 0

    // Main background color for the active area
    property color mainBgColor: "#E4EDF3"
    property color sidebarColor: "#214358"
    property color sidebarActiveTextColor: "#214358"
    property color sidebarInactiveTextColor: "#A0B4C0"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar
        Rectangle {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: 260
            color: sidebarColor

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Header / Profile Section
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 12
                        
                        // Avatar
                        Rectangle {
                            width: 70
                            height: 70
                            radius: 35
                            color: "#E4EDF3"
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Text {
                                text: root.userFirstName.charAt(0).toUpperCase()
                                anchors.centerIn: parent
                                font.pixelSize: 28
                                font.weight: Font.Bold
                                color: sidebarColor
                            }
                        }
                        
                        // User Info
                        Column {
                            spacing: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Text {
                                text: root.userFirstName + " " + (studentService.profile.nom ? studentService.profile.nom : "")
                                font.family: "Inter"
                                color: "white"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            
                            Text {
                                text: root.userEmail
                                font.family: "Inter"
                                color: "#A0B4C0"
                                font.pixelSize: 11
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }

                // Menu Items
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 10
                    spacing: 8

                    property var menuItems: [
                        { name: "Dashboard", icon: "⊞" },
                        { name: "Mon Profil", icon: "👤" },
                        { name: "Mes Cours", icon: "📚" },
                        { name: "Inscriptions", icon: "✍" },
                        { name: "Mes Notes", icon: "🎓" },
                        { name: "Emploi du temps", icon: "📅" },
                        { name: "Présences", icon: "✓" },
                        { name: "Mes Finances", icon: "＄" },
                        { name: "Documents", icon: "📄" }
                    ]

                    Repeater {
                        model: parent.menuItems
                        delegate: Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 46
                            Layout.leftMargin: 20
                            
                            // Active background with rounded left corners
                            Rectangle {
                                anchors.fill: parent
                                color: root.currentMenuIndex === index ? mainBgColor : "transparent"
                                radius: 23
                                
                                // Square off the right corners to blend with main area
                                Rectangle {
                                    width: 23
                                    height: parent.height
                                    anchors.right: parent.right
                                    color: root.currentMenuIndex === index ? mainBgColor : "transparent"
                                    visible: root.currentMenuIndex === index
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: root.currentMenuIndex = index
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 20
                                spacing: 16
                                
                                Text {
                                    text: modelData.icon
                                    color: root.currentMenuIndex === index ? sidebarActiveTextColor : sidebarInactiveTextColor
                                    font.pixelSize: 16
                                    font.family: "Segoe UI Symbol"
                                }
                                
                                Text {
                                    text: modelData.name
                                    color: root.currentMenuIndex === index ? sidebarActiveTextColor : sidebarInactiveTextColor
                                    font.family: "Inter"
                                    font.pixelSize: 14
                                    font.weight: root.currentMenuIndex === index ? Font.Bold : Font.Medium
                                }
                            }
                        }
                    }
                    
                    Item { Layout.fillHeight: true } // Spacer
                }
                
                // Logout Button
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: root.logout()
                    }
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 12
                        
                        Text {
                            text: "⏻"
                            color: sidebarInactiveTextColor
                            font.pixelSize: 16
                        }
                        
                        Text {
                            text: "Déconnexion"
                            color: sidebarInactiveTextColor
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                        }
                    }
                }
            }
        }

        // Main Content Area
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: mainBgColor
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Pages Stack
                StackLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    currentIndex: root.currentMenuIndex

                    StudentPages.Overview {
                        onNavigateTo: function(index) {
                            root.currentMenuIndex = index;
                        }
                        
                        onLogoutRequested: {
                            root.logout();
                        }
                    }
                    StudentPages.ProfileView {}
                    StudentPages.CoursesView {}
                    StudentPages.EnrollmentsView {}
                    StudentPages.GradesView {}
                    StudentPages.ScheduleView {}
                    StudentPages.AttendanceView {}
                    StudentPages.FinanceView {}
                    StudentPages.DocumentsView {}
                }
            }
        }
    }
}
