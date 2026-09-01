import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    color: "white"
    radius: 12
    height: 280
    
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
                text: "📄"
                font.pixelSize: 18
            }
            Text {
                text: "Résumé académique"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: "#111827"
                Layout.fillWidth: true
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 16
            columnSpacing: 16
            
            // GPA
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#F8FAFC"
                radius: 8
                border.width: 1
                border.color: "#F1F5F9"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    RowLayout {
                        Text { text: "📊"; font.pixelSize: 16 }
                        Text {
                            text: "Moyenne générale"
                            font.family: "Inter"
                            font.pixelSize: 13
                            color: "#64748B"
                        }
                    }
                    Text {
                        text: (Number(studentService.academicProgress.moyenne || 90) / 25).toFixed(2) + " / 4.00" // convert out of 100 to out of 4.00 for demo
                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#0F172A"
                    }
                }
            }
            
            // Credits
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#F8FAFC"
                radius: 8
                border.width: 1
                border.color: "#F1F5F9"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    RowLayout {
                        Text { text: "🎓"; font.pixelSize: 16 }
                        Text {
                            text: "Crédits validés"
                            font.family: "Inter"
                            font.pixelSize: 13
                            color: "#64748B"
                        }
                    }
                    Text {
                        text: studentService.academicProgress.credits_obtenus || "93"
                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#0F172A"
                    }
                }
            }
            
            // Courses
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#F8FAFC"
                radius: 8
                border.width: 1
                border.color: "#F1F5F9"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    RowLayout {
                        Text { text: "✅"; font.pixelSize: 16 }
                        Text {
                            text: "Cours validés"
                            font.family: "Inter"
                            font.pixelSize: 13
                            color: "#64748B"
                        }
                    }
                    Text {
                        text: "28" // Mock data for now
                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#0F172A"
                    }
                }
            }
            
            // Attendance
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#F8FAFC"
                radius: 8
                border.width: 1
                border.color: "#F1F5F9"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    RowLayout {
                        Text { text: "👥"; font.pixelSize: 16 }
                        Text {
                            text: "Taux d'assiduité"
                            font.family: "Inter"
                            font.pixelSize: 13
                            color: "#64748B"
                        }
                    }
                    Text {
                        text: "92%"
                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#0F172A"
                    }
                }
            }
        }
    }
}
