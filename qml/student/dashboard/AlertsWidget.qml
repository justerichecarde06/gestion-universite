import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 350
    color: "transparent" // Container for multiple blocks
    
    signal viewAllNotificationsClicked()

    ColumnLayout {
        anchors.fill: parent
        spacing: 20
        
        // 1. Conseil Intelligent
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            radius: 12
            color: "#EFF6FF"
            border.color: "#BFDBFE"
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15
                
                Rectangle {
                    width: 40; height: 40; radius: 20; color: "#DBEAFE"
                    Text { text: "💡"; anchors.centerIn: parent; font.pixelSize: 18 }
                }
                
                Column {
                    spacing: 4
                    Layout.fillWidth: true
                    Text { text: "Conseil pour vous"; font.family: "Inter"; color: "#1E3A8A"; font.pixelSize: 12; font.weight: Font.DemiBold }
                    Text { text: "Votre moyenne a augmenté de 6% ce semestre. Continuez ainsi !"; font.family: "Inter"; color: "#1E40AF"; font.pixelSize: 13; wrapMode: Text.WordWrap; width: parent.width }
                }
            }
        }
        
        // 2. Alertes Importantes
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 12
            color: "white"
            border.color: "#E2E8F0"
            border.width: 1
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12
                
                Text {
                    text: "À votre attention"
                    font.family: "Inter"
                    color: "#1A2B3C"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
                
                // Alert 1
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Text { text: "⚠️"; font.pixelSize: 14 }
                    Text { text: "Paiement de scolarité bientôt dû (dans 3 jours)"; font.family: "Inter"; color: "#B45309"; font.pixelSize: 13; Layout.fillWidth: true }
                }
                // Alert 2
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Text { text: "✓"; font.pixelSize: 14; color: "#10B981"; font.weight: Font.Bold }
                    Text { text: "Votre relevé de notes est disponible."; font.family: "Inter"; color: "#334155"; font.pixelSize: 13; Layout.fillWidth: true }
                }
            }
        }
        
        // 3. Notifications Récentes
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: "white"
            border.color: "#E2E8F0"
            border.width: 1
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Notifications récentes"
                        font.family: "Inter"
                        color: "#1A2B3C"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "Voir toutes"
                        font.family: "Inter"
                        color: "#0284C7"
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.viewAllNotificationsClicked()
                        }
                    }
                }
                
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: notificationService ? notificationService.notifications : []
                    spacing: 15
                    
                    delegate: RowLayout {
                        width: ListView.view.width
                        spacing: 12
                        
                        Rectangle {
                            width: 32; height: 32; radius: 16; color: modelData.lu ? "#F1F5F9" : "#DBEAFE"
                            Text { 
                                text: modelData.type === "note" ? "🔔" : (modelData.type === "finance" ? "💰" : "📚")
                                anchors.centerIn: parent; font.pixelSize: 14 
                            }
                        }
                        
                        Column {
                            Layout.fillWidth: true
                            spacing: 2
                            Text { text: modelData.message; font.family: "Inter"; color: modelData.lu ? "#64748B" : "#1A2B3C"; font.pixelSize: 13; width: parent.width; elide: Text.ElideRight; font.weight: modelData.lu ? Font.Normal : Font.DemiBold }
                            Text { text: modelData.date; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 11 }
                        }
                        
                        // Mark as read button if unread
                        Rectangle {
                            width: 8; height: 8; radius: 4; color: "#3B82F6"
                            visible: !modelData.lu
                            
                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -10 // Expand click area
                                cursorShape: Qt.PointingHandCursor
                                onClicked: notificationService.markAsRead(modelData.id)
                            }
                        }
                    }
                }
            }
        }
    }
}
