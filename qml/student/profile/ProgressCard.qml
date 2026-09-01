import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes

Rectangle {
    id: root
    Layout.fillWidth: true
    color: "white"
    radius: 12
    height: 380
    
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowOpacity: 0.05
        shadowBlur: 15
        shadowVerticalOffset: 4
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "📊"
                font.pixelSize: 18
            }
            Text {
                text: "Ma progression"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: "#111827"
                Layout.fillWidth: true
            }
        }

        // Circular Progress
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            Item {
                width: 180
                height: 180
                anchors.centerIn: parent
                
                Shape {
                    anchors.fill: parent
                    // Background circle
                    ShapePath {
                        strokeColor: "#E5E7EB"
                        strokeWidth: 12
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        
                        PathAngleArc {
                            centerX: 90; centerY: 90
                            radiusX: 80; radiusY: 80
                            startAngle: 0
                            sweepAngle: 360
                        }
                    }
                    
                    // Foreground circle (Progress)
                    ShapePath {
                        strokeColor: "#0056D2"
                        strokeWidth: 12
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        
                        PathAngleArc {
                            centerX: 90; centerY: 90
                            radiusX: 80; radiusY: 80
                            startAngle: -90
                            sweepAngle: 360 * 0.77 // 77% progress
                        }
                    }
                }
                
                // Text in center
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text {
                        text: "77%"
                        font.family: "Inter"
                        font.pixelSize: 36
                        font.weight: Font.Bold
                        color: "#111827"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "93 / 120"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: "#4B5563"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "crédits validés"
                        font.family: "Inter"
                        font.pixelSize: 12
                        color: "#6B7280"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#E5E7EB"
        }

        Text {
            text: "18 crédits restants"
            font.family: "Inter"
            font.pixelSize: 14
            color: "#4B5563"
        }

        Rectangle {
            Layout.fillWidth: true
            height: 44
            radius: 8
            color: "#F3F4F6"
            
            Text {
                anchors.centerIn: parent
                text: "Voir mon parcours >"
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: "#0056D2"
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.color = "#E5E7EB"
                onExited: parent.color = "#F3F4F6"
            }
        }
    }
}
