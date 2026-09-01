import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 350
    color: "transparent"
    
    signal viewAllCoursesClicked()

    property var coursesData: dashboardService ? dashboardService.currentCourses : []

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Mes cours actuels"
                font.family: "Inter"
                color: "#1A2B3C"
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "Voir tout"
                font.family: "Inter"
                color: "#0284C7"
                font.pixelSize: 13
                font.weight: Font.DemiBold
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.viewAllCoursesClicked()
                }
            }
        }
        
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: coursesData
            spacing: 15
            orientation: ListView.Horizontal
            
            delegate: Rectangle {
                width: 280
                height: 160
                radius: 12
                color: "white"
                border.color: "#E2E8F0"
                border.width: 1
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }
                
                property real progression: modelData.progression !== undefined ? modelData.progression : (index === 0 ? 68 : 42)
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10
                    
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: modelData.cours || "Cours"; font.family: "Inter"; color: "#1A2B3C"; font.pixelSize: 15; font.weight: Font.Bold; Layout.fillWidth: true; elide: Text.ElideRight }
                        Rectangle {
                            width: 30; height: 20; radius: 10; color: "#F1F5F9"
                            Text { text: (modelData.credits || 3) + " Cr"; anchors.centerIn: parent; font.family: "Inter"; font.pixelSize: 10; color: "#64748B"; font.weight: Font.Bold }
                        }
                    }
                    
                    Text { text: "Code: " + (modelData.code || "INF" + index); font.family: "Inter"; color: "#64748B"; font.pixelSize: 12 }
                    
                    Item { Layout.fillHeight: true }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Progression"; font.family: "Inter"; color: "#64748B"; font.pixelSize: 11 }
                            Item { Layout.fillWidth: true }
                            Text { text: progression + "%"; font.family: "Inter"; color: "#0284C7"; font.pixelSize: 12; font.weight: Font.Bold }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 6
                            radius: 3
                            color: "#F1F5F9"
                            Rectangle {
                                width: parent.width * (progression / 100)
                                height: parent.height
                                radius: 3
                                color: "#0284C7"
                            }
                        }
                    }
                }
            }
        }
    }
}
