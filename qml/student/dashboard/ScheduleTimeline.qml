import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 300
    color: "white"
    radius: 16
    border.color: "#E2E8F0"
    border.width: 1
    layer.enabled: true
    layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }

    // Using real data if available, or fallback gracefully
    property var scheduleData: studentService.schedule

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Aujourd'hui"
                font.family: "Inter"
                color: "#1A2B3C"
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
            
            Item { Layout.fillWidth: true }
            
            // Week days shortcut 
            RowLayout {
                spacing: 8
                Repeater {
                    model: ["L", "M", "M", "J", "V"]
                    Rectangle {
                        width: 24; height: 24; radius: 12
                        color: index === 0 ? "#0284C7" : "transparent"
                        Text {
                            text: modelData
                            anchors.centerIn: parent
                            color: index === 0 ? "white" : "#94A3B8"
                            font.pixelSize: 12
                            font.weight: index === 0 ? Font.Bold : Font.Normal
                        }
                    }
                }
            }
        }
        
        // Timeline List
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: scheduleData && scheduleData.length > 0 ? scheduleData : 3 // fallback to mock 3 items if empty
            spacing: 0
            
            delegate: Item {
                width: ListView.view.width
                height: 70
                
                property bool isReal: typeof modelData === "object"
                property string courseName: isReal ? modelData.cours : (index===0?"Programmation C++":(index===1?"Base de données":"Algorithmique"))
                property string courseTime: isReal ? modelData.heure_debut : (index===0?"09:00":(index===1?"11:00":"14:00"))
                property int statusType: index === 0 ? 1 : (index === 1 ? 0 : -1) // 1=Terminé, 0=En cours, -1=A venir
                
                RowLayout {
                    anchors.fill: parent
                    spacing: 15
                    
                    // Time
                    Text {
                        text: courseTime
                        font.family: "Inter"
                        color: statusType === 0 ? "#1A2B3C" : "#94A3B8"
                        font.pixelSize: 14
                        font.weight: statusType === 0 ? Font.Bold : Font.Medium
                        Layout.preferredWidth: 45
                    }
                    
                    // Timeline Line & Node
                    Item {
                        Layout.preferredWidth: 20
                        Layout.fillHeight: true
                        
                        // Vertical line
                        Rectangle {
                            width: 2
                            height: parent.height
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: index === 0 ? "#10B981" : "#E2E8F0" // Green if past
                        }
                        
                        // Node dot
                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            anchors.centerIn: parent
                            color: statusType === 0 ? "white" : (statusType === 1 ? "#10B981" : "#E2E8F0")
                            border.color: statusType === 0 ? "#0284C7" : (statusType === 1 ? "#10B981" : "#CBD5E1")
                            border.width: statusType === 0 ? 3 : 1
                        }
                    }
                    
                    // Course Details
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        radius: 8
                        color: statusType === 0 ? "#F0F9FF" : "transparent" // Highlight current course
                        border.color: statusType === 0 ? "#BAE6FD" : "transparent"
                        border.width: 1
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15
                            
                            Text {
                                text: courseName
                                font.family: "Inter"
                                color: statusType === 0 ? "#0369A1" : "#334155"
                                font.pixelSize: 15
                                font.weight: statusType === 0 ? Font.DemiBold : Font.Medium
                                Layout.fillWidth: true
                            }
                            
                            // Badge Status
                            Rectangle {
                                width: statusText.width + 16
                                height: 22
                                radius: 11
                                color: statusType === 0 ? "#0284C7" : (statusType === 1 ? "#F1F5F9" : "transparent")
                                border.color: statusType === -1 ? "#E2E8F0" : "transparent"
                                border.width: 1
                                
                                Text {
                                    id: statusText
                                    text: statusType === 0 ? "En cours" : (statusType === 1 ? "Terminé" : "À venir")
                                    anchors.centerIn: parent
                                    color: statusType === 0 ? "white" : "#64748B"
                                    font.family: "Inter"
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
