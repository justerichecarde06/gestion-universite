import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 160
    color: "white"
    radius: 16
    border.color: "#E2E8F0"
    border.width: 1
    layer.enabled: true
    layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }

    property real progressPercentage: dashboardService ? Math.round((dashboardService.creditsValidated / 120.0) * 100) : 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 15
        
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Ma progression académique"
                font.family: "Inter"
                color: "#1A2B3C"
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 32; height: 32; radius: 16; color: "#F8FAFC"
                Text { text: "🎓"; anchors.centerIn: parent }
            }
        }
        
        // Progress Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 12
            radius: 6
            color: "#F1F5F9"
            
            Rectangle {
                width: parent.width * (root.progressPercentage / 100)
                height: parent.height
                radius: 6
                color: "#0284C7" // Blue
                
                // Add a subtle gradient or bright highlight if needed
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height / 2
                    color: "white"
                    opacity: 0.2
                    radius: 6
                }
            }
        }
        
        // Labels
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Vous avez validé " + root.progressPercentage + "% de votre parcours académique."
                font.family: "Inter"
                color: "#64748B"
                font.pixelSize: 14
            }
            Item { Layout.fillWidth: true }
            Text {
                text: root.progressPercentage + "%"
                font.family: "Inter"
                color: "#0F172A"
                font.pixelSize: 16
                font.weight: Font.Bold
            }
        }
    }
}
