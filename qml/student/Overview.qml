import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "dashboard" as DashboardComponents

Item {
    id: root
    anchors.fill: parent
    
    signal navigateTo(int index)
    signal logoutRequested()

    ScrollView {
        anchors.fill: parent
        contentWidth: Math.max(width, 1100)
        clip: true
        
        // Hide scrollbars for a cleaner look
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            width: Math.max(parent.width, 1100)
            spacing: 24
            
            // 1. Header
            DashboardComponents.DashboardHeader {
                Layout.fillWidth: true
                Layout.topMargin: 20
                onProfileClicked: root.navigateTo(1)
                onLogoutClicked: root.logoutRequested()
            }
            
            // 2. Statistiques Principales (KPIs - Pleine largeur)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 40
                Layout.rightMargin: 40
                spacing: 24

                DashboardComponents.StatsGrid {
                    Layout.fillWidth: true
                }
                
                DashboardComponents.AcademicProgress {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                }
            }
            
            // 3. Zone Principale & Informations Secondaires (Grille 2/3 - 1/3)
            GridLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 40
                Layout.rightMargin: 40
                Layout.topMargin: 10
                columnSpacing: 30
                rowSpacing: 30
                
                // Responsivité: 3 colonnes sur desktop (>1200px), 2 sur tablette (>800px), 1 sur mobile
                columns: root.width > 1200 ? 3 : (root.width > 800 ? 2 : 1)
                
                // --- COLONNE PRINCIPALE (2/3 de l'espace sur Desktop) ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.columnSpan: root.width > 1200 ? 2 : (root.width > 800 ? 1 : 1)
                    spacing: 24
                    
                    DashboardComponents.NextClassCard {
                        Layout.fillWidth: true
                        onViewScheduleClicked: root.navigateTo(5)
                    }
                    
                    DashboardComponents.ScheduleTimeline {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 400
                    }
                    
                    DashboardComponents.CurrentCoursesWidget {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 280
                        onViewAllCoursesClicked: root.navigateTo(2)
                    }
                    
                    DashboardComponents.PerformanceChart {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 350
                    }
                }
                
                // --- COLONNE LATERALE (1/3 de l'espace sur Desktop) ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.columnSpan: 1
                    spacing: 24
                    
                    DashboardComponents.ProfileCard {
                        Layout.fillWidth: true
                        onViewProfileClicked: root.navigateTo(1)
                    }
                    
                    DashboardComponents.QuickShortcuts {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 400
                        onShortcutClicked: function(target) {
                            if (target === "Notes") root.navigateTo(4)
                            else if (target === "Schedule") root.navigateTo(5)
                            else if (target === "Finance") root.navigateTo(7)
                            else if (target === "Documents") root.navigateTo(8)
                            else if (target === "Profile") root.navigateTo(1)
                            else if (target === "Enrollments") root.navigateTo(3)
                        }
                    }
                    
                    DashboardComponents.AlertsWidget {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 350
                        onViewAllNotificationsClicked: console.log("Afficher les notifications")
                    }
                    
                    DashboardComponents.RecentGrades {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 350
                        onViewAllGradesClicked: root.navigateTo(4)
                    }
                    
                    DashboardComponents.FinanceWidget {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 350
                        onViewPaymentsClicked: root.navigateTo(7)
                    }
                    
                    DashboardComponents.AttendanceWidget {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 300
                    }
                }
            }
            
            // Spacer to allow scrolling
            Item {
                Layout.preferredHeight: 40
            }
        }
    }
}
