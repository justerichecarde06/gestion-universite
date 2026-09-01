import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "../components"

Rectangle {
    id: root
    color: "#F3F4F6"
    
    property var requestsModel: []
    property var stats: ({"total": 0, "pending": 0, "approved": 0, "rejected": 0})
    property int itemsPerPage: 8
    property int currentPage: 1

    function loadRequests(filter) {
        requestsModel = authManager.getRegistrationRequests(filter);
        stats = authManager.getRegistrationStats();
        currentPage = 1;
    }
    
    function formatDateString(isoString) {
        if (!isoString) return { date: "N/A", time: "" };
        let d = new Date(isoString);
        if (isNaN(d.getTime())) return { date: isoString, time: "" };
        
        let months = ["jan", "fév", "mar", "avr", "mai", "juin", "juil", "août", "sep", "oct", "nov", "déc"];
        let date = d.getDate() + " " + months[d.getMonth()] + " " + d.getFullYear();
        let hours = d.getHours().toString().padStart(2, '0');
        let mins = d.getMinutes().toString().padStart(2, '0');
        return { date: date, time: hours + ":" + mins };
    }

    function getInitials(prenom, nom) {
        let first = prenom && prenom.length > 0 ? prenom.charAt(0).toUpperCase() : "";
        let last = nom && nom.length > 0 ? nom.charAt(0).toUpperCase() : "";
        return first + last;
    }
    
    function getAvatarColor(initials) {
        let colors = ["#E0E7FF", "#FCE7F3", "#DCFCE7", "#DBEAFE", "#FEE2E2", "#FEF3C7", "#F3E8FF"];
        let charCodeSum = 0;
        for (let i = 0; i < initials.length; i++) charCodeSum += initials.charCodeAt(i);
        return colors[charCodeSum % colors.length];
    }
    
    function getAvatarTextColor(initials) {
        let colors = ["#4338CA", "#BE185D", "#15803D", "#1D4ED8", "#B91C1C", "#B45309", "#7E22CE"];
        let charCodeSum = 0;
        for (let i = 0; i < initials.length; i++) charCodeSum += initials.charCodeAt(i);
        return colors[charCodeSum % colors.length];
    }

    Component.onCompleted: loadRequests("Toutes")

    Connections {
        target: authManager
        function onRegistrationRequestsChanged() {
            loadRequests(statusFilter.currentText)
        }
        function onAdminActionSuccess(msg) {
            successBanner.text = msg
            bannerTimer.start()
        }
        function onAdminActionFailed(msg) {
            errorBanner.text = msg
            bannerTimer.start()
        }
    }
    
    Timer {
        id: bannerTimer
        interval: 3000
        onTriggered: {
            successBanner.text = ""
            errorBanner.text = ""
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 24

        // Header
        RowLayout {
            Layout.fillWidth: true
            
            Column {
                spacing: 4
                Text {
                    text: "Demandes d'inscription"
                    font.family: "Inter"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: "#111827"
                }
                Text {
                    text: "Gérez les approbations des nouveaux comptes étudiants."
                    font.family: "Inter"
                    font.pixelSize: 14
                    color: "#6B7280"
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Filter
            RowLayout {
                spacing: 10
                Text {
                    text: "Filtrer:"
                    font.family: "Inter"
                    font.pixelSize: 14
                    color: "#374151"
                }
                ComboBox {
                    id: statusFilter
                    model: ["Toutes", "En attente", "Approuvées", "Rejetées", "Suspendues"]
                    font.family: "Inter"
                    background: Rectangle {
                        implicitWidth: 150
                        implicitHeight: 40
                        border.color: "#E5E7EB"
                        border.width: 1
                        radius: 8
                        color: "white"
                    }
                    onCurrentTextChanged: loadRequests(currentText)
                }
            }
        }
        
        // Stats Cards Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            
            // Total Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "white"
                radius: 12
                border.color: "#E5E7EB"
                border.width: 1
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.05; shadowBlur: 10; shadowVerticalOffset: 2 }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 24; color: "#EFF6FF"
                        Text { anchors.centerIn: parent; text: "👥"; font.pixelSize: 20; color: "#2563EB" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.total || 0; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Total demandes"; font.pixelSize: 13; color: "#6B7280" }
                    }
                }
            }
            
            // Pending Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "white"
                radius: 12
                border.color: "#E5E7EB"
                border.width: 1
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.05; shadowBlur: 10; shadowVerticalOffset: 2 }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 24; color: "#FFFBEB"
                        Text { anchors.centerIn: parent; text: "🕒"; font.pixelSize: 20; color: "#D97706" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.pending || 0; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "En attente"; font.pixelSize: 13; color: "#6B7280" }
                    }
                }
            }
            
            // Approved Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "white"
                radius: 12
                border.color: "#E5E7EB"
                border.width: 1
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.05; shadowBlur: 10; shadowVerticalOffset: 2 }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 24; color: "#F0FDF4"
                        Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 20; color: "#16A34A" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.approved || 0; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Approuvées"; font.pixelSize: 13; color: "#6B7280" }
                    }
                }
            }
            
            // Rejected Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "white"
                radius: 12
                border.color: "#E5E7EB"
                border.width: 1
                layer.enabled: true
                layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.05; shadowBlur: 10; shadowVerticalOffset: 2 }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 24; color: "#FEF2F2"
                        Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 20; color: "#DC2626" }
                    }
                    Column {
                        spacing: 2
                        Text { text: root.stats.rejected || 0; font.pixelSize: 24; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Rejetées"; font.pixelSize: 13; color: "#6B7280" }
                    }
                }
            }
        }
        
        // Notifications
        Text {
            id: successBanner
            Layout.fillWidth: true
            color: "#059669"
            font.pixelSize: 14
            font.weight: Font.Medium
            visible: text !== ""
        }
        Text {
            id: errorBanner
            Layout.fillWidth: true
            color: "#DC2626"
            font.pixelSize: 14
            font.weight: Font.Medium
            visible: text !== ""
        }

        // Main Table Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            radius: 12
            border.color: "#E5E7EB"
            border.width: 1
            clip: true
            
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.05; shadowBlur: 10; shadowVerticalOffset: 2 }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Table Header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 52
                    color: "white"
                    
                    Rectangle {
                        width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16
                        
                        Text { text: "Nom complet"; font.weight: Font.DemiBold; color: "#374151"; font.pixelSize: 13; Layout.preferredWidth: 220 }
                        Text { text: "Email"; font.weight: Font.DemiBold; color: "#374151"; font.pixelSize: 13; Layout.preferredWidth: 200 }
                        Text { text: "Filière"; font.weight: Font.DemiBold; color: "#374151"; font.pixelSize: 13; Layout.preferredWidth: 150 }
                        Text { text: "Date de demande"; font.weight: Font.DemiBold; color: "#374151"; font.pixelSize: 13; Layout.preferredWidth: 140 }
                        Text { text: "Statut"; font.weight: Font.DemiBold; color: "#374151"; font.pixelSize: 13; Layout.preferredWidth: 120 }
                        Text { text: "Actions"; font.weight: Font.DemiBold; color: "#374151"; font.pixelSize: 13; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                    }
                }

                // Table Content
                ListView {
                    id: requestsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    
                    // Client-side pagination model
                    model: {
                        if (!root.requestsModel) return 0;
                        let start = (root.currentPage - 1) * root.itemsPerPage;
                        let end = Math.min(start + root.itemsPerPage, root.requestsModel.length);
                        return root.requestsModel.slice(start, end);
                    }
                    
                    delegate: Rectangle {
                        width: parent.width
                        height: 72
                        color: index % 2 === 0 ? "#FAFAFA" : "white"
                        
                        Rectangle {
                            width: parent.width; height: 1; color: "#F3F4F6"; anchors.bottom: parent.bottom
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16
                            
                            // Name & Avatar
                            RowLayout {
                                Layout.preferredWidth: 220
                                spacing: 12
                                
                                Rectangle {
                                    width: 36; height: 36; radius: 18
                                    color: getAvatarColor(getInitials(modelData.prenom, modelData.nom))
                                    Text { 
                                        anchors.centerIn: parent
                                        text: getInitials(modelData.prenom, modelData.nom)
                                        color: getAvatarTextColor(getInitials(modelData.prenom, modelData.nom))
                                        font.pixelSize: 13
                                        font.weight: Font.Bold
                                    }
                                }
                                
                                Text { 
                                    text: modelData.prenom + " " + modelData.nom
                                    font.weight: Font.Medium; color: "#111827"; font.pixelSize: 14 
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }
                            
                            // Email
                            Text { 
                                text: modelData.email; color: "#4B5563"; font.pixelSize: 13; Layout.preferredWidth: 200 
                                elide: Text.ElideRight
                            }
                            
                            // Filiere
                            Text { 
                                text: modelData.filiere || "Non spécifié"; color: "#4B5563"; font.pixelSize: 13; Layout.preferredWidth: 150 
                            }
                            
                            // Date
                            Column {
                                Layout.preferredWidth: 140
                                spacing: 2
                                property var dateObj: formatDateString(modelData.date_creation)
                                Text { text: dateObj.date; color: "#4B5563"; font.pixelSize: 13 }
                                Text { text: dateObj.time; color: "#9CA3AF"; font.pixelSize: 12 }
                            }
                            
                            // Status Badge
                            Rectangle {
                                Layout.preferredWidth: 110
                                height: 26
                                radius: 4
                                color: {
                                    if (modelData.statut === "APPROVED" || modelData.statut === "Actif") return "#F0FDF4";
                                    if (modelData.statut === "PENDING") return "#FFFBEB";
                                    if (modelData.statut === "REJECTED") return "#FEF2F2";
                                    return "#F3F4F6"; 
                                }
                                border.color: {
                                    if (modelData.statut === "APPROVED" || modelData.statut === "Actif") return "#BBF7D0";
                                    if (modelData.statut === "PENDING") return "#FEF08A";
                                    if (modelData.statut === "REJECTED") return "#FECACA";
                                    return "#E5E7EB"; 
                                }
                                border.width: 1
                                
                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 6
                                    Text {
                                        text: {
                                            if (modelData.statut === "APPROVED" || modelData.statut === "Actif") return "✓";
                                            if (modelData.statut === "PENDING") return "🕒";
                                            if (modelData.statut === "REJECTED") return "✕";
                                            return "";
                                        }
                                        color: {
                                            if (modelData.statut === "APPROVED" || modelData.statut === "Actif") return "#16A34A";
                                            if (modelData.statut === "PENDING") return "#D97706";
                                            if (modelData.statut === "REJECTED") return "#DC2626";
                                            return "#374151";
                                        }
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        text: {
                                            if (modelData.statut === "APPROVED" || modelData.statut === "Actif") return "Approuvée";
                                            if (modelData.statut === "PENDING") return "En attente";
                                            if (modelData.statut === "REJECTED") return "Rejetée";
                                            if (modelData.statut === "SUSPENDED") return "Suspendue";
                                            return modelData.statut;
                                        }
                                        color: {
                                            if (modelData.statut === "APPROVED" || modelData.statut === "Actif") return "#16A34A";
                                            if (modelData.statut === "PENDING") return "#D97706";
                                            if (modelData.statut === "REJECTED") return "#DC2626";
                                            return "#374151";
                                        }
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                    }
                                }
                            }
                            
                            Item { Layout.fillWidth: true }
                            
                            // Actions
                            RowLayout {
                                spacing: 8
                                Layout.alignment: Qt.AlignRight
                                
                                // Approve Button
                                Rectangle {
                                    width: 32; height: 32; radius: 6; color: "#22C55E"
                                    visible: modelData.statut === "PENDING"
                                    Text { anchors.centerIn: parent; text: "✓"; color: "white"; font.pixelSize: 14; font.weight: Font.Bold }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: authManager.approveRegistration(modelData.id)
                                    }
                                }
                                
                                // Reject Button
                                Rectangle {
                                    width: 32; height: 32; radius: 6; color: "#EF4444"
                                    visible: modelData.statut === "PENDING"
                                    Text { anchors.centerIn: parent; text: "✕"; color: "white"; font.pixelSize: 14; font.weight: Font.Bold }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            var role = authManager.currentUserRole
                                            var actor = role === "secretary" ? "le secrétariat" : "l'administrateur"
                                            authManager.rejectRegistration(modelData.id, "Rejeté par " + actor + ".")
                                        }
                                    }
                                }
                                
                                // View Button
                                Rectangle {
                                    width: 32; height: 32; radius: 6; color: "#F3F4F6"; border.color: "#E5E7EB"; border.width: 1
                                    Text { anchors.centerIn: parent; text: "👁"; color: "#4B5563"; font.pixelSize: 14 }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: console.log("Voir détails", modelData.id)
                                    }
                                }
                            }
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Aucune demande d'inscription trouvée."
                        color: "#9CA3AF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        visible: root.requestsModel.length === 0
                    }
                }
                
                // Pagination Footer
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    color: "white"
                    visible: root.requestsModel.length > 0
                    
                    Rectangle {
                        width: parent.width; height: 1; color: "#E5E7EB"; anchors.top: parent.top
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        
                        Text {
                            property int startIdx: (root.currentPage - 1) * root.itemsPerPage + 1
                            property int endIdx: Math.min(root.currentPage * root.itemsPerPage, root.requestsModel.length)
                            text: "Affichage de " + startIdx + " à " + endIdx + " sur " + root.requestsModel.length + " demandes"
                            color: "#6B7280"
                            font.pixelSize: 13
                            Layout.fillWidth: true
                        }
                        
                        RowLayout {
                            spacing: 8
                            
                            // Prev Button
                            Rectangle {
                                width: 80; height: 32; radius: 6
                                border.color: "#D1D5DB"; border.width: 1
                                color: root.currentPage > 1 ? "white" : "#F9FAFB"
                                Text { anchors.centerIn: parent; text: "Précédent"; color: root.currentPage > 1 ? "#374151" : "#9CA3AF"; font.pixelSize: 13 }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: root.currentPage > 1 ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    onClicked: if(root.currentPage > 1) root.currentPage--
                                }
                            }
                            
                            // Current Page
                            Rectangle {
                                width: 32; height: 32; radius: 6
                                color: "#1E3A8A" // USFAH Dark Blue
                                Text { anchors.centerIn: parent; text: root.currentPage; color: "white"; font.pixelSize: 13; font.weight: Font.Medium }
                            }
                            
                            // Next Button
                            Rectangle {
                                width: 80; height: 32; radius: 6
                                border.color: "#D1D5DB"; border.width: 1
                                property bool hasNext: (root.currentPage * root.itemsPerPage) < root.requestsModel.length
                                color: hasNext ? "white" : "#F9FAFB"
                                Text { anchors.centerIn: parent; text: "Suivant"; color: hasNext ? "#374151" : "#9CA3AF"; font.pixelSize: 13 }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: parent.hasNext ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    onClicked: if(parent.hasNext) root.currentPage++
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
