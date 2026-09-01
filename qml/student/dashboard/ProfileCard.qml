import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 320
    color: "white"
    radius: 16
    border.color: "#E2E8F0"
    border.width: 1
    
    signal viewProfileClicked()
    
    // Slight shadow
    layer.enabled: true
    layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 15
        
        // Avatar and Basic Info
        RowLayout {
            spacing: 20
            
            // Photo / Avatar
            Rectangle {
                width: 80
                height: 80
                radius: 40
                color: "#E4EDF3"
                border.color: "#214358"
                border.width: 2
                
                Text {
                    text: (studentService.profile.prenom ? studentService.profile.prenom.charAt(0).toUpperCase() : "E") +
                          (studentService.profile.nom ? studentService.profile.nom.charAt(0).toUpperCase() : "")
                    anchors.centerIn: parent
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: "#214358"
                }
            }
            
            ColumnLayout {
                spacing: 4
                
                Text {
                    text: (studentService.profile.prenom ? studentService.profile.prenom : "Étudiant") + " " + 
                          (studentService.profile.nom ? studentService.profile.nom : "")
                    font.family: "Inter"
                    color: "#1A2B3C"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                }
                
                Text {
                    text: "Matricule: " + (studentService.profile.matricule ? studentService.profile.matricule : "26-0001-USFAH")
                    font.family: "Inter"
                    color: "#64748B"
                    font.pixelSize: 14
                }
                
                // Status Badge
                Rectangle {
                    Layout.topMargin: 5
                    width: statusText.width + 20
                    height: 26
                    radius: 13
                    color: studentService.profile.statut === "Actif" ? "#D1FAE5" : "#FEF3C7" // Green or Yellow bg
                    
                    Text {
                        id: statusText
                        text: studentService.profile.statut ? studentService.profile.statut : "Actif"
                        anchors.centerIn: parent
                        color: studentService.profile.statut === "Actif" ? "#059669" : "#D97706" // Green or yellow text
                        font.family: "Inter"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                    }
                }
            }
        }
        
        // Divider
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#E2E8F0"
        }
        
        // Details Grid
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 15
            columnSpacing: 20
            
            // Filière
            Column {
                spacing: 4
                Text { text: "Filière"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 12 }
                Text { text: studentService.profile.filiere ? studentService.profile.filiere : "Génie Informatique"; font.family: "Inter"; color: "#334155"; font.pixelSize: 14; font.weight: Font.Medium }
            }
            
            // Niveau
            Column {
                spacing: 4
                Text { text: "Niveau"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 12 }
                Text { text: "Licence 3"; font.family: "Inter"; color: "#334155"; font.pixelSize: 14; font.weight: Font.Medium }
            }
            
            // Année académique
            Column {
                spacing: 4
                Text { text: "Année académique"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 12 }
                Text { text: "2026 - 2027"; font.family: "Inter"; color: "#334155"; font.pixelSize: 14; font.weight: Font.Medium }
            }
            
            // Admission
            Column {
                spacing: 4
                Text { text: "Admission"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 12 }
                Text { text: "Octobre 2024"; font.family: "Inter"; color: "#334155"; font.pixelSize: 14; font.weight: Font.Medium }
            }
        }
        
        Item { Layout.fillHeight: true } // Spacer
        
        // Action Button
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            radius: 8
            color: "#F8FAFC"
            border.color: "#E2E8F0"
            border.width: 1
            
            Text {
                text: "Voir mon profil complet"
                anchors.centerIn: parent
                font.family: "Inter"
                color: "#0F172A"
                font.pixelSize: 14
                font.weight: Font.DemiBold
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.viewProfileClicked()
            }
        }
    }
}
