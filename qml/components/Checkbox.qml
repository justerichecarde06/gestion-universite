import QtQuick
import QtQuick.Controls

Item {
    id: control
    property string text: "Se souvenir de moi"
    property bool checked: false
    
    width: row.width
    height: 20

    Row {
        id: row
        anchors.fill: parent
        spacing: 8

        Rectangle {
            id: indicator
            width: 18
            height: 18
            radius: 4
            border.width: 1
            border.color: control.checked ? "#01B4BA" : "#D1D5DB"
            color: control.checked ? "#01B4BA" : "white"
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: "✓"
                color: "white"
                font.pixelSize: 12
                font.weight: Font.Bold
                visible: control.checked
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: control.checked = !control.checked
            }
        }

        Text {
            text: control.text
            font.family: "Inter"
            font.pixelSize: 13
            color: "#6B7280"
            anchors.verticalCenter: parent.verticalCenter
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: control.checked = !control.checked
            }
        }
    }
}
