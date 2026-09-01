import QtQuick
import QtQuick.Controls

Item {
    id: control
    
    property string labelText: ""
    property string placeholder: ""
    property bool isPassword: false
    property string errorText: ""
    property alias text: textField.text
    property alias textFieldItem: textField
    property string iconText: "" // Text-based icon for simplicity if no image

    width: parent.width
    height: 70

    Column {
        anchors.fill: parent
        spacing: 4

        Text {
            text: control.labelText
            font.family: "IBM Plex Mono" // Fallback: Consolas
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2
            font.pixelSize: 11
            color: "#032B4A"
            font.weight: Font.DemiBold
        }

        Rectangle {
            width: parent.width
            height: 44
            radius: 4
            border.width: control.errorText !== "" ? 1 : (textField.activeFocus ? 2 : 1)
            border.color: control.errorText !== "" ? "red" : (textField.activeFocus ? "#01B4BA" : "#D1D5DB")
            color: "white"
            
            // Subtle glow effect on focus
            Rectangle {
                anchors.fill: parent
                radius: 4
                color: "transparent"
                border.width: textField.activeFocus ? 3 : 0
                border.color: "#01B4BA"
                opacity: 0.15
                visible: textField.activeFocus && control.errorText === ""
            }

            Row {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: control.iconText
                    font.pixelSize: 18
                    color: textField.activeFocus ? "#01B4BA" : "#9CA3AF"
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: textField
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - (isPassword ? 70 : 30) // leave space for icon and eye button
                    placeholderText: control.placeholder
                    echoMode: control.isPassword && !eyeButton.checked ? TextInput.Password : TextInput.Normal
                    background: Item {}
                    font.family: "Inter"
                    font.pixelSize: 14
                    color: "#032B4A"
                    selectByMouse: true
                    
                    Keys.onEnterPressed: control.Keys.pressed(event)
                    Keys.onReturnPressed: control.Keys.pressed(event)
                }
            }

            // Eye button for password
            MouseArea {
                id: eyeButton
                property bool checked: false
                width: 30
                height: parent.height
                anchors.right: parent.right
                visible: control.isPassword
                cursorShape: Qt.PointingHandCursor
                
                Text {
                    text: eyeButton.checked ? "👁️" : "👁️‍🗨️" // simple unicode fallback for eye icon
                    anchors.centerIn: parent
                    font.pixelSize: 16
                    color: "#9CA3AF"
                }

                onClicked: {
                    eyeButton.checked = !eyeButton.checked
                }
            }
        }

        Text {
            text: control.errorText
            color: "red"
            font.pixelSize: 11
            font.family: "Inter"
            visible: control.errorText !== ""
        }
    }
}
