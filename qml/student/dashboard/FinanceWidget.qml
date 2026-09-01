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
    
    signal viewPaymentsClicked()

    property var financesData: dashboardService ? dashboardService.recentPayments : []

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Situation financière"
                font.family: "Inter"
                color: "#1A2B3C"
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "Voir mes paiements"
                font.family: "Inter"
                color: "#0284C7"
                font.pixelSize: 13
                font.weight: Font.DemiBold
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.viewPaymentsClicked()
                }
            }
        }
        
        // Progress Section
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 8
                
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: (dashboardService ? dashboardService.financialPaid.toLocaleString() : "0") + " HTG payés"; font.family: "Inter"; color: "#10B981"; font.pixelSize: 14; font.weight: Font.Bold }
                    Item { Layout.fillWidth: true }
                    Text { text: "Reste: " + (dashboardService ? dashboardService.financialBalance.toLocaleString() : "0") + " HTG"; font.family: "Inter"; color: "#64748B"; font.pixelSize: 14 }
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 12
                    radius: 6
                    color: "#F1F5F9"
                    
                    Rectangle {
                        width: parent.width * (dashboardService && dashboardService.financialTotal > 0 ? (dashboardService.financialPaid / dashboardService.financialTotal) : 0)
                        height: parent.height
                        radius: 6
                        color: "#10B981" // Green
                    }
                }
            }
        }
        
        // Latest payments list
        Text {
            text: "Derniers paiements"
            font.family: "Inter"
            color: "#64748B"
            font.pixelSize: 14
            font.weight: Font.Medium
            Layout.topMargin: 10
        }
        
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: financesData
            spacing: 12
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 60
                radius: 8
                color: "#F8FAFC"
                border.color: "#E2E8F0"
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 15
                    
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: "white"
                        Text { text: "💸"; anchors.centerIn: parent; font.pixelSize: 16 }
                    }
                    
                    Column {
                        spacing: 4
                        Layout.fillWidth: true
                        Text { text: modelData.montant + " HTG"; font.family: "Inter"; color: "#1A2B3C"; font.pixelSize: 15; font.weight: Font.Bold }
                        Text { text: modelData.date + " • " + modelData.mode; font.family: "Inter"; color: "#64748B"; font.pixelSize: 12 }
                    }
                    
                    Rectangle {
                        Layout.preferredWidth: 70
                        Layout.preferredHeight: 24
                        radius: 12
                        color: modelData.statut === "Payé" ? "#D1FAE5" : "#FEF3C7"
                        
                        Text {
                            text: modelData.statut === "Payé" ? "✓ Payé" : "En attente"
                            anchors.centerIn: parent
                            color: modelData.statut === "Payé" ? "#059669" : "#D97706"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                        }
                    }
                }
            }
        }
    }
}
