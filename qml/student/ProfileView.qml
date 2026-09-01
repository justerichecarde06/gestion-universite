import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "profile" as ProfileComponents

Item {
    id: root
    anchors.fill: parent

    ScrollView {
        anchors.fill: parent
        contentWidth: parent.width
        clip: true

        ColumnLayout {
            width: parent.width - 40 // Add margin on both sides
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            spacing: 24

            // Page title is removed since the Header contains the identity context
            
            // Zone 1: Profile Header
            ProfileComponents.ProfileHeader {
                Layout.topMargin: 20
            }

            // Zone 2: The Grid of Cards
            GridLayout {
                Layout.fillWidth: true
                columns: root.width > 1400 ? 4 : (root.width > 1000 ? 2 : 1)
                rowSpacing: 24
                columnSpacing: 24
                
                // Column 1
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 24
                    ProfileComponents.PersonalInfoCard { Layout.fillWidth: true }
                    ProfileComponents.AcademicSummaryCard { Layout.fillWidth: true }
                }

                // Column 2
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 24
                    ProfileComponents.AcademicInfoCard { Layout.fillWidth: true }
                    ProfileComponents.DocumentsCard { Layout.fillWidth: true }
                }

                // Column 3
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 24
                    ProfileComponents.ProgressCard { Layout.fillWidth: true }
                    ProfileComponents.RecentActivityCard { Layout.fillWidth: true }
                }

                // Column 4
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 24
                    ProfileComponents.StudentCardWidget { Layout.fillWidth: true }
                    ProfileComponents.SecurityCard { Layout.fillWidth: true }
                    ProfileComponents.QuickActionsCard { Layout.fillWidth: true }
                }
            }
            
            // Sync Footer
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#F8FAFC"
                border.width: 1
                border.color: "#E2E8F0"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 16
                        color: "#EFF6FF"
                        Text { anchors.centerIn: parent; text: "ℹ️"; font.pixelSize: 14 }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: "Dernière synchronisation"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            color: "#1E293B"
                        }
                        Text {
                            text: "Vos informations sont synchronisées avec l'administration."
                            font.family: "Inter"
                            font.pixelSize: 13
                            color: "#64748B"
                        }
                    }
                    
                    RowLayout {
                        spacing: 8
                        Text {
                            text: "Aujourd'hui à 10:42"
                            font.family: "Inter"
                            font.pixelSize: 13
                            color: "#64748B"
                        }
                        Text { text: "🔄"; font.pixelSize: 16; color: "#0056D2" }
                    }
                }
            }
            
            Item { Layout.fillWidth: true; height: 40 } // Bottom spacing
        }
    }
}
