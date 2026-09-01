import QtQuick
import QtQuick.Controls

Button {
    id: control
    
    text: "Se connecter"
    property bool isLoading: false
    
    width: parent.width
    height: 48

    contentItem: Item {
        anchors.fill: parent
        
        Row {
            anchors.centerIn: parent
            spacing: 8
            visible: !control.isLoading

            Text {
                text: control.text
                font.family: "Inter"
                font.weight: Font.DemiBold
                font.pixelSize: 15
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "→"
                font.pixelSize: 18
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Simple loading spinner
        Text {
            anchors.centerIn: parent
            visible: control.isLoading
            text: "⌛"
            color: "white"
            font.pixelSize: 18
            RotationAnimator on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
                duration: 1000
                running: control.isLoading
            }
        }
    }

    background: Rectangle {
        radius: 10
        // Gradient Orange -> Lighter Orange
        gradient: Gradient {
            GradientStop { position: 0.0; color: control.enabled ? "#FF7A0F" : "#FDBA74" }
            GradientStop { position: 1.0; color: control.enabled ? "#FF9640" : "#FDBA74" }
            orientation: Gradient.Horizontal
        }
        
        // Shadow effect when enabled
        Rectangle {
            anchors.fill: parent
            anchors.margins: -4
            anchors.topMargin: 0
            z: -1
            radius: 14
            color: "#FF7A0F"
            opacity: control.enabled && control.down ? 0.4 : (control.enabled ? 0.25 : 0)
            visible: control.enabled
        }
    }
    
    // Changing cursor shape on hover
    MouseArea {
        anchors.fill: parent
        cursorShape: control.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.NoButton // let the button handle clicks
    }
}
