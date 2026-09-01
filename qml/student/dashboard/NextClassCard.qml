import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 220
    color: "#214358" // Dark background for this important card
    radius: 16
    
    signal viewScheduleClicked()
    
    layer.enabled: true
    layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 1.0; shadowOpacity: 0.15 }
    
    // Use the nextClass provided by dashboardService
    property var nextClass: dashboardService && dashboardService.nextClass && dashboardService.nextClass.cours ? dashboardService.nextClass : null
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 12
        
        RowLayout {
            Layout.fillWidth: true
            
            Rectangle {
                width: 40; height: 40; radius: 20; color: "white"; opacity: 0.2
                Text { text: "⏳"; anchors.centerIn: parent; font.pixelSize: 18 }
            }
            
            Text {
                text: "Prochain cours"
                font.family: "Inter"
                color: "#94A3B8"
                font.pixelSize: 16
                font.weight: Font.Medium
                Layout.leftMargin: 10
            }
            Item { Layout.fillWidth: true }
            
            Rectangle {
                Layout.preferredHeight: 30
                Layout.preferredWidth: 140
                radius: 15
                color: "#10B981" // Green badge
                
                Text {
                    text: "Dans 35 min" // Mock countdown
                    anchors.centerIn: parent
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                }
            }
        }
        
        Text {
            text: root.nextClass ? root.nextClass.cours : "Aucun cours prévu"
            font.family: "Inter"
            color: "white"
            font.pixelSize: 26
            font.weight: Font.Bold
        }
        
        RowLayout {
            spacing: 25
            
            // Time
            RowLayout {
                spacing: 6
                Text { text: "🕒"; color: "#94A3B8" }
                Text { text: (root.nextClass ? root.nextClass.heure_debut + " — " + root.nextClass.heure_fin : "--:--"); font.family: "Inter"; color: "#E2E8F0"; font.pixelSize: 14 }
            }
            
            // Room
            RowLayout {
                spacing: 6
                Text { text: "📍"; color: "#94A3B8" }
                Text { text: root.nextClass ? root.nextClass.salle : "--"; font.family: "Inter"; color: "#E2E8F0"; font.pixelSize: 14 }
            }
            
            // Teacher
            RowLayout {
                spacing: 6
                Text { text: "👨‍🏫"; color: "#94A3B8" }
                Text { text: root.nextClass ? root.nextClass.enseignant : "--"; font.family: "Inter"; color: "#E2E8F0"; font.pixelSize: 14 }
            }
        }
        
        Item { Layout.fillHeight: true }
        
        // View Schedule Button
        Rectangle {
            Layout.preferredWidth: 200
            Layout.preferredHeight: 36
            radius: 8
            color: "transparent"
            border.color: "#38BDF8"
            border.width: 1
            
            Text {
                text: "Voir l'emploi du temps"
                anchors.centerIn: parent
                color: "#38BDF8"
                font.family: "Inter"
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.viewScheduleClicked()
            }
        }
    }
}
