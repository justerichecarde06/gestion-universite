import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

GridLayout {
    id: root
    Layout.fillWidth: true
    // Dynamically adjust columns up to 5 so it spans the entire width on large screens
    columns: parent.width > 1200 ? 5 : (parent.width > 900 ? 3 : (parent.width > 600 ? 2 : 1))
    rowSpacing: 20
    columnSpacing: 20
    
    // Helper Component for a Stat Card
    component StatCard : Rectangle {
        property string titleText: ""
        property string mainValue: ""
        property string subValue1: ""
        property color subValue1Color: "#10B981" // Default green
        property string subValue2: ""
        property string iconText: ""
        property color iconBgColor: "#F1F5F9"
        property color iconFgColor: "#64748B"
        
        Layout.fillWidth: true
        Layout.preferredHeight: 140
        color: "white"
        radius: 16
        border.color: "#E2E8F0"
        border.width: 1
        layer.enabled: true
        layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.05 }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12
            
            // Header: Title and Icon
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: titleText
                    font.family: "Inter"
                    color: "#64748B"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    Layout.fillWidth: true
                }
                
                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: iconBgColor
                    Text { text: iconText; anchors.centerIn: parent; color: iconFgColor; font.pixelSize: 16 }
                }
            }
            
            // Main Value
            Text {
                text: mainValue
                font.family: "Inter"
                color: "#0F172A"
                font.pixelSize: 28
                font.weight: Font.Bold
            }
            
            // Sub values
            RowLayout {
                spacing: 10
                Text { text: subValue1; font.family: "Inter"; color: subValue1Color; font.pixelSize: 13; font.weight: Font.Medium }
                Text { text: subValue2; font.family: "Inter"; color: "#94A3B8"; font.pixelSize: 13 }
            }
        }
    }

    // 1. Moyenne Générale
    StatCard {
        titleText: "Moyenne Générale"
        mainValue: dashboardService ? dashboardService.averageGrade.toFixed(1) + " / 100" : "0 / 100"
        subValue1: "À jour"
        subValue2: "sur ce semestre"
        iconText: "📈"
        iconBgColor: "#ECFDF5"
        iconFgColor: "#10B981"
    }

    // 2. Crédits
    StatCard {
        titleText: "Crédits Validés"
        mainValue: dashboardService ? dashboardService.creditsValidated + " / 120" : "0 / 120"
        subValue1: dashboardService ? Math.round((dashboardService.creditsValidated / 120) * 100) + "%" : "0%"
        subValue2: "du programme"
        iconText: "🎯"
        iconBgColor: "#EFF6FF"
        iconFgColor: "#3B82F6"
    }

    // 3. Cours
    StatCard {
        titleText: "Cours Actuels"
        mainValue: dashboardService ? dashboardService.totalCourses.toString() : "0"
        subValue1: "Inscrits"
        subValue2: "ce semestre"
        iconText: "📚"
        iconBgColor: "#F5F3FF"
        iconFgColor: "#8B5CF6"
    }

    // 4. Assiduité
    StatCard {
        titleText: "Assiduité"
        mainValue: dashboardService ? dashboardService.attendanceRate.toFixed(1) + "%" : "0%"
        subValue1: "Présence"
        subValue1Color: dashboardService && dashboardService.attendanceRate < 80 ? "#EF4444" : "#10B981"
        subValue2: "ce semestre"
        iconText: "✓"
        iconBgColor: dashboardService && dashboardService.attendanceRate < 80 ? "#FEF2F2" : "#ECFDF5"
        iconFgColor: dashboardService && dashboardService.attendanceRate < 80 ? "#EF4444" : "#10B981"
    }

    // 5. Scolarité (Finances)
    StatCard {
        titleText: "Scolarité Payée"
        mainValue: dashboardService ? dashboardService.financialPaid.toLocaleString() + " HTG" : "0 HTG"
        subValue1: dashboardService ? Math.round((dashboardService.financialPaid / Math.max(1, dashboardService.financialTotal)) * 100) + "%" : "0%"
        subValue2: dashboardService ? "Reste: " + dashboardService.financialBalance.toLocaleString() + " HTG" : ""
        iconText: "＄"
        iconBgColor: "#FFFBEB"
        iconFgColor: "#F59E0B"
    }
}
