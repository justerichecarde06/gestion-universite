import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    
    // Set this property when using the guard
    property string requiredPermission: ""
    property bool isAuthorized: requiredPermission === "" || authManager.hasPermission(requiredPermission)
    
    // Expose a signal to redirect the user back
    signal requestReturn()
    
    // Default content to display when authorized. Users of this component will nest their content.
    default property alias content: authorizedContent.data

    Item {
        id: authorizedContent
        anchors.fill: parent
        visible: root.isAuthorized
    }
    
    Rectangle {
        id: forbiddenScreen
        anchors.fill: parent
        color: "#F3F4F6"
        visible: !root.isAuthorized
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20
            
            Text {
                text: "⛔"
                font.pixelSize: 64
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "Accès non autorisé (403)"
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#111827"
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "Vous n'avez pas les permissions nécessaires pour accéder à ce module."
                font.family: "Inter"
                font.pixelSize: 16
                color: "#4B5563"
                Layout.alignment: Qt.AlignHCenter
            }
            
            Button {
                text: "Retour au tableau de bord"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                background: Rectangle {
                    color: "#052644"
                    radius: 8
                    implicitWidth: 200
                    implicitHeight: 45
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: root.requestReturn()
            }
        }
    }
}
