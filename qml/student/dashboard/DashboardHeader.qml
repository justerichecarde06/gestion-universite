import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    Layout.fillWidth: true
    implicitHeight: 80
    
    signal profileClicked()
    signal logoutClicked()

    property string prenom: studentService.profile.prenom ? studentService.profile.prenom : "Étudiant"
    property string dateDuJour: Qt.formatDateTime(new Date(), "dddd d MMMM yyyy")
    property string anneeAcademique: "2026 - 2027"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        
        // Left part: Welcome & Date
        Column {
            Layout.alignment: Qt.AlignVCenter
            spacing: 4
            
            Text {
                text: "Bonjour, " + root.prenom + " 👋"
                font.family: "Inter"
                color: "#1A2B3C"
                font.pixelSize: 26
                font.weight: Font.Bold
            }
            
            Text {
                text: "Voici un résumé de votre activité universitaire. • " + root.dateDuJour + " • Année " + root.anneeAcademique
                font.family: "Inter"
                color: "#64748B"
                font.pixelSize: 14
                font.weight: Font.Medium
            }
        }
        
        Item { Layout.fillWidth: true }
        
        // Right part: Actions & Avatar
        RowLayout {
            spacing: 20
            
            // Notification Icon
            Rectangle {
                width: 44
                height: 44
                radius: 22
                color: "white"
                border.color: "#E2E8F0"
                border.width: 1
                
                Text { text: "🔔"; anchors.centerIn: parent; font.pixelSize: 18 }
                
                // Unread indicator
                Rectangle {
                    width: 10
                    height: 10
                    radius: 5
                    color: "#EF4444"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 10
                    anchors.rightMargin: 10
                }
            }
            
            // Avatar & Menu Dropdown Mockup
            Rectangle {
                Layout.preferredWidth: 160
                Layout.preferredHeight: 44
                radius: 22
                color: "white"
                border.color: "#E2E8F0"
                border.width: 1
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.profileClicked()
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 10
                    
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: "#E4EDF3"
                        Text { 
                            text: root.prenom.charAt(0).toUpperCase()
                            anchors.centerIn: parent
                            color: "#214358"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                        }
                    }
                    
                    Text {
                        text: "Profil ▾"
                        color: "#1A2B3C"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        Layout.fillWidth: true
                    }
                }
            }
            
            // Logout
            Rectangle {
                width: 44
                height: 44
                radius: 22
                color: "#FEE2E2" // Light red
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.logoutClicked()
                }
                
                Text { text: "⏻"; color: "#DC2626"; anchors.centerIn: parent; font.pixelSize: 18 }
            }
        }
    }
}
