import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 350
    color: "white"
    radius: 16
    border.color: "#E2E8F0"
    border.width: 1
    layer.enabled: true
    layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }

    property int totalClasses: dashboardService ? dashboardService.attendanceTotal : 0
    property int totalAbsences: dashboardService ? dashboardService.attendanceAbsences : 0
    property real attendanceRate: dashboardService ? dashboardService.attendanceRate : 100.0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20
        
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Mon assiduité"
                font.family: "Inter"
                color: "#1A2B3C"
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 32; height: 32; radius: 8; color: "#F8FAFC"
                Text { text: "👁️"; anchors.centerIn: parent }
            }
        }
        
        // Circular Progress / Gauge Replacement using simple bars
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8
                
                Text {
                    text: root.attendanceRate.toFixed(0) + "%"
                    font.family: "Inter"
                    color: root.attendanceRate >= 90 ? "#10B981" : (root.attendanceRate >= 75 ? "#F59E0B" : "#EF4444")
                    font.pixelSize: 48
                    font.weight: Font.Bold
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "de présence globale"
                    font.family: "Inter"
                    color: "#64748B"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
        
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "#E2E8F0" }
        
        // Details
        RowLayout {
            Layout.fillWidth: true
            
            Column {
                Layout.fillWidth: true
                spacing: 4
                Text { text: "Présences"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 12 }
                Text { text: (root.totalClasses - root.totalAbsences).toString(); font.family: "Inter"; color: "#1A2B3C"; font.pixelSize: 16; font.weight: Font.Bold }
            }
            
            Rectangle { width: 1; height: 30; color: "#E2E8F0" }
            
            Column {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                spacing: 4
                Text { text: "Absences"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 12 }
                Text { text: root.totalAbsences.toString(); font.family: "Inter"; color: root.totalAbsences > 5 ? "#EF4444" : "#1A2B3C"; font.pixelSize: 16; font.weight: Font.Bold }
            }
        }
        
        Item { Layout.fillHeight: true }
        
        // Alert if needed
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            radius: 8
            color: root.attendanceRate < 80 ? "#FEF2F2" : "#F0FDF4"
            border.color: root.attendanceRate < 80 ? "#FCA5A5" : "#BBF7D0"
            border.width: 1
            visible: root.attendanceRate < 85 // Only show if somewhat bad, or just always show a message
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                spacing: 10
                
                Text { text: root.attendanceRate < 80 ? "⚠️" : "👍"; font.pixelSize: 14 }
                Text {
                    text: root.attendanceRate < 80 ? "Attention, votre assiduité est faible." : "Votre assiduité est excellente."
                    font.family: "Inter"
                    color: root.attendanceRate < 80 ? "#991B1B" : "#166534"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    Layout.fillWidth: true
                }
            }
        }
    }
}
