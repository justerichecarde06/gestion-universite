import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24

        Text {
            text: "Mes Présences"
            font.family: "Fraunces"
            color: "#032B4A"
            font.pixelSize: 32
            font.weight: Font.Bold
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: studentService.attendance
            spacing: 12
            clip: true
            delegate: Rectangle {
                width: ListView.view.width
                height: 60
                color: "white"
                radius: 8
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    
                    Text { text: modelData.date; font.pixelSize: 14; color: "#6B7280"; Layout.preferredWidth: 100 }
                    Text { text: modelData.cours; font.pixelSize: 16; font.weight: Font.DemiBold; color: "#032B4A"; Layout.fillWidth: true }
                    
                    Rectangle {
                        color: modelData.present === 1 ? "#D1FAE5" : "#FEE2E2"
                        radius: 12
                        width: 80
                        height: 24
                        Text {
                            anchors.centerIn: parent
                            text: modelData.present === 1 ? "Présent" : "Absent"
                            color: modelData.present === 1 ? "#065F46" : "#991B1B"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                    }
                }
            }
        }
    }
}
