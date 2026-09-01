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
    
    signal viewAllGradesClicked()

    property var gradesData: dashboardService ? dashboardService.recentGrades : []

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 15
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Dernières notes"
                font.family: "Inter"
                color: "#1A2B3C"
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "Voir toutes mes notes"
                font.family: "Inter"
                color: "#0284C7"
                font.pixelSize: 13
                font.weight: Font.DemiBold
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.viewAllGradesClicked()
                }
            }
        }
        
        // Table Header
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10
            
            Text { text: "COURS"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 11; font.weight: Font.Bold; Layout.preferredWidth: 150 }
            Text { text: "ÉVALUATION"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 11; font.weight: Font.Bold; Layout.preferredWidth: 120 }
            Text { text: "NOTE"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 11; font.weight: Font.Bold; Layout.preferredWidth: 80 }
            Text { text: "STATUT"; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 11; font.weight: Font.Bold; Layout.fillWidth: true }
        }
        
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "#E2E8F0" }
        
        // List
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: gradesData
            spacing: 0
            
            delegate: Item {
                width: ListView.view.width
                height: 50
                
                property real gradeValue: modelData.valeur
                property string statusText: gradeValue >= 80 ? "Excellent" : (gradeValue >= 65 ? "Bon" : (gradeValue >= 50 ? "Moyen" : "À améliorer"))
                property color statusColor: gradeValue >= 80 ? "#10B981" : (gradeValue >= 65 ? "#3B82F6" : (gradeValue >= 50 ? "#F59E0B" : "#EF4444"))
                property color statusBg: gradeValue >= 80 ? "#D1FAE5" : (gradeValue >= 65 ? "#DBEAFE" : (gradeValue >= 50 ? "#FEF3C7" : "#FEE2E2"))
                
                RowLayout {
                    anchors.fill: parent
                    
                    Text { text: modelData.cours; font.family: "Inter"; color: "#1A2B3C"; font.pixelSize: 14; font.weight: Font.Medium; Layout.preferredWidth: 150; elide: Text.ElideRight }
                    Text { text: "Intra"; font.family: "Inter"; color: "#64748B"; font.pixelSize: 14; Layout.preferredWidth: 120 } // Mock eval type
                    Text { text: gradeValue + "/100"; font.family: "Inter"; color: "#0F172A"; font.pixelSize: 14; font.weight: Font.Bold; Layout.preferredWidth: 80 }
                    
                    Rectangle {
                        Layout.preferredWidth: 90
                        Layout.preferredHeight: 24
                        radius: 12
                        color: statusBg
                        
                        Text {
                            text: statusText
                            anchors.centerIn: parent
                            color: statusColor
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                        }
                    }
                    Item { Layout.fillWidth: true }
                }
                
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#F1F5F9"
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}
