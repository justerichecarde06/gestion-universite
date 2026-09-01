import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

// Import both admin and student views
import "admin" as AdminPages
import "student" as StudentPages
import "components"

Item {
    id: root
    anchors.fill: parent
    
    signal logout()
    
    // Style properties
    property color sidebarBg: "#052644"
    property color activeMenuBg: "#08416B"
    property color inactiveMenuText: "#8FA3B8"
    property color orangeAccent: "#EF6C00"
    
    property int currentViewIndex: 0
    property string activeComponent: "dashboard" // dashboard, users, courses, grades, etc.
    
    // ListModel for dynamic sidebar
    ListModel {
        id: menuModel
    }

    Component.onCompleted: {
        buildMenu();
    }

    // Function to dynamically build the sidebar based on permissions
    function buildMenu() {
        menuModel.clear();
        
        // Everyone gets a Dashboard
        menuModel.append({ "title": "Tableau de bord", "icon": "🏠", "component": "dashboard", "permission": "dashboard.view" });
        
        // Administrative modules
        if (authManager.hasPermission("registrations.view")) {
            menuModel.append({ "title": "Inscriptions", "icon": "📝", "component": "registrations", "permission": "registrations.view" });
        }
        if (authManager.hasPermission("users.view")) {
            menuModel.append({ "title": "Utilisateurs", "icon": "👥", "component": "users", "permission": "users.view" });
        }
        
        // Academic modules
        if (authManager.hasPermission("courses.view")) {
            menuModel.append({ "title": "Cours", "icon": "📚", "component": "courses", "permission": "courses.view" });
        }
        if (authManager.hasPermission("grades.view")) {
            menuModel.append({ "title": "Notes", "icon": "🧾", "component": "grades", "permission": "grades.view" });
        }
        // Admin: schedule management
        if (authManager.currentUserRole !== "student" && authManager.hasPermission("schedule.view")) {
            menuModel.append({ "title": "Emploi du temps", "icon": "📅", "component": "admin_schedule", "permission": "schedule.view" });
        }
        
        // Student specific modules
        if (authManager.currentUserRole === "student") {
            menuModel.append({ "title": "Emploi du temps", "icon": "📅", "component": "schedule", "permission": "" });
            menuModel.append({ "title": "Mon Profil", "icon": "👤", "component": "profile", "permission": "" });
            menuModel.append({ "title": "Mes Finances", "icon": "💰", "component": "finance", "permission": "" });
            menuModel.append({ "title": "Mes Documents", "icon": "📄", "component": "documents", "permission": "" });
        }
        
        // Financial modules (Accountant or superadmin)
        if (authManager.hasPermission("finance.view") && authManager.currentUserRole !== "student") {
            menuModel.append({ "title": "Finances", "icon": "💰", "component": "admin_finance", "permission": "finance.view" });
        }

        // Settings (Admin only)
        if (authManager.hasPermission("settings.view")) {
            menuModel.append({ "title": "Paramètres", "icon": "⚙️", "component": "settings", "permission": "settings.view" });
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==========================================
        // SIDEBAR
        // ==========================================
        Rectangle {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: 260
            color: root.sidebarBg

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Header
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30
                        spacing: 4
                        
                        Text {
                            text: {
                                var r = authManager.currentUserRole;
                                if (r === "superadmin") return "SUPER ADMIN";
                                if (r === "secretary") return "SECRÉTAIRE";
                                if (r === "accountant") return "COMPTABLE";
                                if (r === "professor") return "PROFESSEUR";
                                if (r === "student") return "ÉTUDIANT";
                                return r.toUpperCase();
                            }
                            font.family: "Inter"
                            color: root.orangeAccent
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            font.letterSpacing: 1.5
                        }
                        
                        Text {
                            text: "Portail USFAH"
                            font.family: "Inter"
                            color: "white"
                            font.pixelSize: 22
                            font.weight: Font.Bold
                        }
                    }
                }

                // Menu Items
                ListView {
                    id: menuList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: menuModel
                    clip: true
                    
                    delegate: Rectangle {
                        width: menuList.width
                        height: 50
                        
                        property bool isActive: root.activeComponent === model.component
                        color: isActive ? root.activeMenuBg : "transparent"
                        
                        Rectangle {
                            width: 4
                            height: parent.height
                            color: root.orangeAccent
                            visible: isActive
                            anchors.left: parent.left
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 30
                            spacing: 16
                            
                            Text {
                                text: model.icon
                                color: isActive ? "white" : root.inactiveMenuText
                                font.pixelSize: 18
                            }
                            
                            Text {
                                text: model.title
                                color: isActive ? "white" : root.inactiveMenuText
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: isActive ? Font.DemiBold : Font.Normal
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                root.activeComponent = model.component;
                            }
                            onEntered: if(!isActive) parent.color = Qt.rgba(255,255,255,0.05)
                            onExited: if(!isActive) parent.color = "transparent"
                        }
                        
                        // Pending badge for Inscriptions
                        Rectangle {
                            visible: model.component === "registrations" && authManager.getRegistrationStats().pending > 0
                            width: 20; height: 20; radius: 10; color: "#EF4444"
                            anchors.right: parent.right; anchors.rightMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                anchors.centerIn: parent
                                text: authManager.getRegistrationStats().pending || ""
                                color: "white"; font.pixelSize: 10; font.weight: Font.Bold
                            }
                        }
                    }
                }
                
                // Logout Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    color: "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 30
                        spacing: 16
                        
                        Text { text: "🚪"; color: "#EF4444"; font.pixelSize: 18 }
                        Text { text: "Déconnexion"; color: "#EF4444"; font.family: "Inter"; font.pixelSize: 14 }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.color = Qt.rgba(239,68,68,0.1)
                        onExited: parent.color = "transparent"
                        onClicked: {
                            authManager.logout();
                            root.logout();
                        }
                    }
                }
            }
        }

        // ==========================================
        // MAIN CONTENT (Dynamic Loader)
        // ==========================================
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#F3F4F6"
            
            // We use a Loader to dynamically load the component based on activeComponent
            Loader {
                id: mainLoader
                anchors.fill: parent
                sourceComponent: getComponentFor(root.activeComponent)
            }
        }
    }
    
    // Router logic
    function getComponentFor(componentName) {
        if (componentName === "dashboard") {
            if (authManager.currentUserRole === "student") {
                return studentOverviewComp;
            } else {
                return adminOverviewComp;
            }
        }
        else if (componentName === "registrations") return registrationsComp;
        else if (componentName === "users") return usersComp;
        else if (componentName === "courses") {
            if (authManager.currentUserRole === "student") return studentCoursesComp;
            else return adminCoursesComp;
        }
        else if (componentName === "grades") {
            if (authManager.currentUserRole === "student") return studentGradesComp;
            else return adminGradesComp;
        }
        else if (componentName === "schedule") return studentScheduleComp;
        else if (componentName === "admin_schedule") return adminScheduleComp;
        else if (componentName === "admin_finance") return adminFinanceComp;
        else if (componentName === "profile") return studentProfileComp;
        else if (componentName === "finance") return studentFinanceComp;
        else if (componentName === "documents") return studentDocsComp;
        else if (componentName === "settings") return adminSettingsComp;
        // fallback
        return null;
    }
    
    // --- Components Definitions ---
    
    Component { id: adminOverviewComp; AdminPages.Overview {} }
    Component { id: registrationsComp; AdminPages.RegistrationRequestsView {} }
    Component { id: usersComp; AdminPages.UsersView {} }
    Component { id: adminCoursesComp; AdminPages.CoursesView {} }
    Component { id: adminGradesComp; AdminPages.GradesView {} }
    Component { id: adminScheduleComp; AdminPages.ScheduleView {} }
    Component { id: adminFinanceComp; AdminPages.FinancesView {} }
    Component { id: adminSettingsComp; AdminPages.SettingsView {} }

    Component { id: studentOverviewComp; StudentPages.Overview {} }
    Component { id: studentProfileComp; StudentPages.ProfileView {} }
    Component { id: studentCoursesComp; StudentPages.CoursesView {} }
    Component { id: studentGradesComp; StudentPages.GradesView {} }
    Component { id: studentScheduleComp; StudentPages.ScheduleView {} }
    Component { id: studentFinanceComp; StudentPages.FinanceView {} }
    Component { id: studentDocsComp; StudentPages.DocumentsView {} }
}
