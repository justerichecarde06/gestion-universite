import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent

    property int activeTab: 0 // 0 = Mes Cours, 1 = S'inscrire

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24

        // Header and Tabs
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Gestion des Cours"
                font.family: "Fraunces"
                color: "#032B4A"
                font.pixelSize: 32
                font.weight: Font.Bold
            }
            
            Item { Layout.fillWidth: true }
            
            // Tabs
            RowLayout {
                spacing: 12
                
                // Tab 1: Mes Cours
                Rectangle {
                    width: 140; height: 40; radius: 8
                    color: root.activeTab === 0 ? "#00B4B1" : "white"
                    border.color: root.activeTab === 0 ? "transparent" : "#E2E8F0"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Mes Cours"
                        color: root.activeTab === 0 ? "white" : "#4A5568"
                        font.pixelSize: 14; font.weight: Font.DemiBold
                    }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: root.activeTab = 0
                    }
                }
                
                // Tab 2: S'inscrire
                Rectangle {
                    width: 140; height: 40; radius: 8
                    color: root.activeTab === 1 ? "#00B4B1" : "white"
                    border.color: root.activeTab === 1 ? "transparent" : "#E2E8F0"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "S'inscrire"
                        color: root.activeTab === 1 ? "white" : "#4A5568"
                        font.pixelSize: 14; font.weight: Font.DemiBold
                    }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: root.activeTab = 1
                    }
                }
            }
        }

        // CONTENT: Mes Cours (Enrolled)
        ListView {
            visible: root.activeTab === 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: studentService.enrolledCourses
            spacing: 16
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            
            Text {
                visible: parent.count === 0
                text: "Vous n'êtes inscrit à aucun cours pour le moment."
                anchors.centerIn: parent
                color: "#718096"
                font.pixelSize: 16
            }
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 90
                color: "white"
                radius: 12
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 10; shadowOpacity: 0.05 }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    Rectangle {
                        width: 50; height: 50; radius: 10
                        color: "#E6FFFA"
                        Text { anchors.centerIn: parent; text: "📚"; font.pixelSize: 24 }
                    }
                    
                    Column {
                        spacing: 6
                        Text { text: modelData.code + " - " + modelData.intitule; font.pixelSize: 16; font.weight: Font.DemiBold; color: "#1A202C" }
                        Text { text: "Crédits: " + modelData.credits + " | Volume horaire: " + modelData.volume_horaire + "h | Année: " + modelData.annee_academique; font.pixelSize: 13; color: "#718096" }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Rectangle {
                        color: modelData.statut === "Validé" ? "#C6F6D5" : (modelData.statut === "Échoué" ? "#FED7D7" : "#FEEBC8")
                        radius: 6
                        width: 90
                        height: 30
                        Text {
                            anchors.centerIn: parent
                            text: modelData.statut || "Inscrit"
                            color: modelData.statut === "Validé" ? "#22543D" : (modelData.statut === "Échoué" ? "#822727" : "#7B341E")
                            font.pixelSize: 13
                            font.weight: Font.Bold
                        }
                    }
                }
            }
        }
        
        // CONTENT: S'inscrire (Available Courses)
        ListView {
            visible: root.activeTab === 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: studentService.availableCourses
            spacing: 16
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            
            Text {
                visible: parent.count === 0
                text: "Aucun nouveau cours disponible pour votre filière."
                anchors.centerIn: parent
                color: "#718096"
                font.pixelSize: 16
            }
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 90
                color: "white"
                radius: 12
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 10; shadowOpacity: 0.05 }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    Rectangle {
                        width: 50; height: 50; radius: 10
                        color: "#EBF8FF"
                        Text { anchors.centerIn: parent; text: "📖"; font.pixelSize: 24 }
                    }
                    
                    Column {
                        spacing: 6
                        Text { text: modelData.code + " - " + modelData.intitule; font.pixelSize: 16; font.weight: Font.DemiBold; color: "#1A202C" }
                        Text { text: "Crédits: " + modelData.credits + " | Volume horaire: " + modelData.volume_horaire + "h"; font.pixelSize: 13; color: "#718096" }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Rectangle {
                        width: 130
                        height: 36
                        radius: 8
                        color: "#00B4B1"
                        
                        Text {
                            anchors.centerIn: parent
                            text: "S'inscrire"
                            color: "white"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.opacity = 0.8
                            onExited: parent.opacity = 1.0
                            onClicked: {
                                if(studentService.enrollInCourse(modelData.id)) {
                                    console.log("Inscription réussie");
                                    // Optionally switch back to "Mes Cours" tab
                                    // root.activeTab = 0; 
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
