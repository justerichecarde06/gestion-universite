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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 15
        
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Évolution de la moyenne"
                font.family: "Inter"
                color: "#1A2B3C"
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 32; height: 32; radius: 8; color: "#F8FAFC"
                Text { text: "📈"; anchors.centerIn: parent }
            }
        }
        
        // Custom Bar Chart using Rectangles
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            property var chartData: dashboardService ? dashboardService.performanceHistory : []
            
            // Y-Axis lines
            Column {
                anchors.fill: parent
                anchors.bottomMargin: 30
                anchors.topMargin: 20
                spacing: (parent.height - 50) / 4
                
                Repeater {
                    model: [100, 75, 50, 25, 0]
                    Item {
                        width: parent.width
                        height: 1
                        
                        Text {
                            text: modelData
                            anchors.right: parent.left
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            font.family: "Inter"
                            color: "#94A3B8"
                            font.pixelSize: 10
                        }
                        
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "#F1F5F9"
                        }
                    }
                }
            }
            
            // Bars
            Row {
                anchors.fill: parent
                anchors.leftMargin: 40
                anchors.rightMargin: 20
                anchors.bottomMargin: 30
                anchors.topMargin: 20
                spacing: (width - (5 * 30)) / 4 // 5 bars, width 30
                
                Repeater {
                    model: parent.chartData
                    Item {
                        width: 30
                        height: parent.height
                        
                        // Background full height bar (optional)
                        Rectangle {
                            anchors.fill: parent
                            color: "#F8FAFC"
                            radius: 4
                        }
                        
                        // Actual value bar
                        Rectangle {
                            width: parent.width
                            height: parent.height * (modelData.value / 100)
                            anchors.bottom: parent.bottom
                            color: index === parent.parent.chartData.length - 1 ? "#0284C7" : "#BAE6FD" // Highlight last
                            radius: 4
                            
                            Text {
                                text: modelData.value + "%"
                                anchors.bottom: parent.top
                                anchors.bottomMargin: 5
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: "Inter"
                                color: index === parent.parent.parent.chartData.length - 1 ? "#0369A1" : "#64748B"
                                font.pixelSize: 10
                                font.weight: Font.Bold
                            }
                        }
                        
                        // Label
                        Text {
                            text: modelData.label
                            anchors.top: parent.bottom
                            anchors.topMargin: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: "Inter"
                            color: "#64748B"
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }
    }
}
