import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    
    signal requestNavigation(int viewIndex)
    
    // Pass in from parent if needed, or define locally
    property color mainBg: "#F0F6F9"
    property color cardBg: "#FFFFFF"
    property color textColor: "#1A202C"
    property color textLight: "#718096"
    property color tealAccent: "#00B4B1"
    property color blueAccent: "#003A69"
    property color orangeAccent: "#EF6C00"
    property color greenPositive: "#38A169"
    property string fontBold: "Inter"
    property string fontRegular: "Inter"

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: parent.width - 60
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30
            anchors.bottomMargin: 30
            spacing: 24

            // --- TOP HEADER ---
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10
                
                Text {
                    text: "Vue d'ensemble (Administrateur)"
                    font.family: root.fontBold
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: root.textColor
                }
                
                Item { Layout.fillWidth: true } // Spacer
                
                // Notification Bell
                Item {
                    width: 40
                    height: 40
                    
                    Text {
                        text: "🔔"
                        anchors.centerIn: parent
                        font.pixelSize: 20
                        color: root.textLight
                    }
                    
                    Rectangle {
                        width: 16
                        height: 16
                        radius: 8
                        color: "red"
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 4
                        
                        Text {
                            text: "5"
                            color: "white"
                            font.pixelSize: 10
                            anchors.centerIn: parent
                            font.weight: Font.Bold
                        }
                    }
                }
                
                // Date
                RowLayout {
                    spacing: 8
                    Text {
                        text: "📅"
                        font.pixelSize: 18
                        color: root.textLight
                    }
                    Text {
                        text: "21 Mai 2025"
                        font.family: root.fontRegular
                        font.pixelSize: 14
                        color: root.textLight
                        font.weight: Font.DemiBold
                    }
                }
            }

            // --- STATS GRID ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 24

                // Stat 1: Students
                DashboardStatCard {
                    Layout.fillWidth: true
                    icon: "👥"
                    iconBgColor: root.tealAccent
                    value: "1,245"
                    title: "Étudiants Inscrits"
                    trendValue: "+12.5%"
                    trendColor: root.greenPositive
                }

                // Stat 2: Professors
                DashboardStatCard {
                    Layout.fillWidth: true
                    icon: "🎓"
                    iconBgColor: root.blueAccent
                    value: "84"
                    title: "Professeurs"
                    trendValue: "+4.3%"
                    trendColor: root.greenPositive
                }

                // Stat 3: Courses
                DashboardStatCard {
                    Layout.fillWidth: true
                    icon: "📚"
                    iconBgColor: root.orangeAccent
                    value: "312"
                    title: "Cours Actifs"
                    trendValue: "+8.7%"
                    trendColor: root.greenPositive
                }
            }

            // --- CHARTS AREA ---
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 320
                spacing: 24

                // Line Chart Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: parent.width * 0.66
                    color: root.cardBg
                    radius: 12
                    
                    layer.enabled: true
                    layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.1; shadowColor: "#40000000" }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Statistiques des Inscriptions"
                                font.family: root.fontBold
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                color: root.textColor
                            }
                            Item { Layout.fillWidth: true }
                            Rectangle {
                                width: 140
                                height: 32
                                radius: 6
                                border.color: "#E2E8F0"
                                color: "white"
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    Text {
                                        text: "6 derniers mois"
                                        font.pixelSize: 12
                                        color: root.textLight
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: "⌄"
                                        font.pixelSize: 14
                                        color: root.textLight
                                    }
                                }
                            }
                        }

                        // Canvas for Line Chart
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            // Y-axis labels
                            Column {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 30
                                width: 40
                                
                                Repeater {
                                    model: ["1,500", "1,250", "1,000", "750", "500", "250", "0"]
                                    Text {
                                        text: modelData
                                        font.pixelSize: 10
                                        color: root.textLight
                                        y: index * (parent.height / 6) - 5
                                        x: parent.width - width - 5
                                    }
                                }
                            }
                            
                            // X-axis labels
                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 50
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: 20
                                
                                Repeater {
                                    model: ["Déc", "Jan", "Fév", "Mar", "Avr", "Mai"]
                                    Item {
                                        width: parent.width / 6
                                        height: parent.height
                                        Text {
                                            text: modelData
                                            font.pixelSize: 11
                                            color: root.textLight
                                            anchors.centerIn: parent
                                        }
                                    }
                                }
                            }
                            
                            // The actual chart
                            Canvas {
                                id: lineChartCanvas
                                anchors.left: parent.left
                                anchors.leftMargin: 50
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 30
                                
                                onPaint: {
                                    var ctx = getContext("2d");
                                    var w = width;
                                    var h = height;
                                    ctx.clearRect(0, 0, w, h);
                                    
                                    // Grid lines
                                    ctx.strokeStyle = "#F1F5F9";
                                    ctx.lineWidth = 1;
                                    for(var i=0; i<=6; i++) {
                                        var y = i * (h / 6);
                                        ctx.beginPath();
                                        ctx.moveTo(0, y);
                                        ctx.lineTo(w, y);
                                        ctx.stroke();
                                    }
                                    
                                    // Data points
                                    var data = [500, 700, 900, 1050, 1280, 1200];
                                    var maxVal = 1500;
                                    
                                    var points = [];
                                    for(var j=0; j<data.length; j++) {
                                        var px = (w / 6) * j + (w / 12);
                                        var py = h - (data[j] / maxVal) * h;
                                        points.push({x: px, y: py});
                                    }
                                    
                                    // Gradient fill
                                    var gradient = ctx.createLinearGradient(0, 0, 0, h);
                                    gradient.addColorStop(0, "rgba(0, 180, 177, 0.2)"); // tealAccent transparent
                                    gradient.addColorStop(1, "rgba(0, 180, 177, 0.0)");
                                    
                                    ctx.beginPath();
                                    ctx.moveTo(points[0].x, h);
                                    for(var k=0; k<points.length; k++) {
                                        if(k === 0) ctx.lineTo(points[k].x, points[k].y);
                                        else {
                                            var cp1x = points[k-1].x + (points[k].x - points[k-1].x) / 2;
                                            var cp1y = points[k-1].y;
                                            var cp2x = points[k-1].x + (points[k].x - points[k-1].x) / 2;
                                            var cp2y = points[k].y;
                                            ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, points[k].x, points[k].y);
                                        }
                                    }
                                    ctx.lineTo(points[points.length-1].x, h);
                                    ctx.closePath();
                                    ctx.fillStyle = gradient;
                                    ctx.fill();
                                    
                                    // Line
                                    ctx.beginPath();
                                    ctx.moveTo(points[0].x, points[0].y);
                                    for(var m=1; m<points.length; m++) {
                                        var cp1xL = points[m-1].x + (points[m].x - points[m-1].x) / 2;
                                        var cp1yL = points[m-1].y;
                                        var cp2xL = points[m-1].x + (points[m].x - points[m-1].x) / 2;
                                        var cp2yL = points[m].y;
                                        ctx.bezierCurveTo(cp1xL, cp1yL, cp2xL, cp2yL, points[m].x, points[m].y);
                                    }
                                    ctx.strokeStyle = root.tealAccent;
                                    ctx.lineWidth = 3;
                                    ctx.stroke();
                                    
                                    // Points circles
                                    ctx.fillStyle = root.tealAccent;
                                    for(var n=0; n<points.length; n++) {
                                        ctx.beginPath();
                                        ctx.arc(points[n].x, points[n].y, 4, 0, 2*Math.PI);
                                        ctx.fill();
                                        ctx.strokeStyle = "white";
                                        ctx.lineWidth = 2;
                                        ctx.stroke();
                                    }
                                }
                            }
                        }
                    }
                }

                // Donut Chart Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: parent.width * 0.33
                    color: root.cardBg
                    radius: 12
                    
                    layer.enabled: true
                    layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.1; shadowColor: "#40000000" }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10
                        
                        Text {
                            text: "Répartition des Cours"
                            font.family: root.fontBold
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: root.textColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            // Donut Canvas
                            Item {
                                Layout.preferredWidth: 160
                                Layout.fillHeight: true
                                
                                Canvas {
                                    id: donutCanvas
                                    anchors.centerIn: parent
                                    width: 150
                                    height: 150
                                    
                                    onPaint: {
                                        var ctx = getContext("2d");
                                        var cx = width / 2;
                                        var cy = height / 2;
                                        var r = 60;
                                        var innerR = 35;
                                        
                                        ctx.clearRect(0, 0, width, height);
                                        
                                        var data = [
                                            {val: 120, color: root.tealAccent}, // Sciences
                                            {val: 95, color: root.blueAccent},  // Technologie
                                            {val: 55, color: root.orangeAccent},// Lettres
                                            {val: 42, color: "#48BB78"}         // Gestion
                                        ];
                                        
                                        var total = 312;
                                        var startAngle = -Math.PI / 2;
                                        
                                        for(var i=0; i<data.length; i++) {
                                            var sliceAngle = (data[i].val / total) * 2 * Math.PI;
                                            
                                            ctx.beginPath();
                                            ctx.arc(cx, cy, r, startAngle, startAngle + sliceAngle, false);
                                            ctx.arc(cx, cy, innerR, startAngle + sliceAngle, startAngle, true);
                                            ctx.closePath();
                                            ctx.fillStyle = data[i].color;
                                            ctx.fill();
                                            
                                            startAngle += sliceAngle;
                                        }
                                    }
                                }
                                
                                // Center text
                                Column {
                                    anchors.centerIn: parent
                                    Text {
                                        text: "312"
                                        font.pixelSize: 22
                                        font.weight: Font.Bold
                                        color: root.textColor
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Text {
                                        text: "Total Cours"
                                        font.pixelSize: 10
                                        color: root.textLight
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                            
                            // Legend
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 12
                                Layout.alignment: Qt.AlignVCenter
                                
                                Repeater {
                                    model: [
                                        {label: "Sciences", val: "120 (38%)", color: root.tealAccent},
                                        {label: "Technologie", val: "95 (30%)", color: root.blueAccent},
                                        {label: "Lettres", val: "55 (18%)", color: root.orangeAccent},
                                        {label: "Gestion", val: "42 (14%)", color: "#48BB78"}
                                    ]
                                    RowLayout {
                                        spacing: 8
                                        Rectangle {
                                            width: 12; height: 12; radius: 2
                                            color: modelData.color
                                        }
                                        Column {
                                            Text { text: modelData.label; font.pixelSize: 12; font.weight: Font.DemiBold; color: root.textColor }
                                            Text { text: modelData.val; font.pixelSize: 11; color: root.textLight }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // --- BOTTOM PANELS ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 24
                Layout.preferredHeight: 380

                // Panel 1: Activité Récente
                BottomPanel {
                    title: "Activité Récente"
                    linkText: "Voir toutes les activités →"
                    modelData: [
                        {icon: "👤", color: root.tealAccent, title: "Nouvel étudiant inscrit", sub: "Jean Baptiste s'est inscrit en Informatique", time: "Il y a 5 min"},
                        {icon: "📚", color: root.blueAccent, title: "Nouveau cours ajouté", sub: "IA et Machine Learning par Dr. Pierre", time: "Il y a 25 min"},
                        {icon: "📝", color: root.orangeAccent, title: "Notes publiées", sub: "Notes du cours Mathématiques Avancées", time: "Il y a 1h"},
                        {icon: "👤", color: "#48BB78", title: "Nouvel utilisateur", sub: "Prof. Marie Claire a rejoint la plateforme", time: "Il y a 2h"}
                    ]
                }

                // Panel 2: Top Cours Populaires
                BottomPanel {
                    title: "Top Cours Populaires"
                    linkText: "Voir tous les cours →"
                    isCourseList: true
                    modelData: [
                        {icon: "💻", color: "#E0F2FE", iconColor: "#0284C7", title: "Programmation Web", sub: "156 étudiants", val: "156"},
                        {icon: "🗄️", color: "#F3E8FF", iconColor: "#9333EA", title: "Base de Données", sub: "142 étudiants", val: "142"},
                        {icon: "🌐", color: "#E0F2FE", iconColor: "#0284C7", title: "Réseaux Informatiques", sub: "128 étudiants", val: "128"},
                        {icon: "🤖", color: "#F1F5F9", iconColor: "#475569", title: "Intelligence Artificielle", sub: "98 étudiants", val: "98"},
                        {icon: "📐", color: "#D1FAE5", iconColor: "#059669", title: "Mathématiques Avancées", sub: "89 étudiants", val: "89"}
                    ]
                }

                // Panel 3: Tâches Administratives
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    color: root.cardBg
                    radius: 12
                    
                    layer.enabled: true
                    layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.1; shadowColor: "#40000000" }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16
                        
                        Text {
                            text: "Tâches Administratives"
                            font.family: root.fontBold
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: root.textColor
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            
                            Repeater {
                                model: [
                                    {icon: "👤+", title: "Ajouter un utilisateur", sub: "Créer un nouveau compte utilisateur", bg: "#E6FFFA", iconCol: root.tealAccent, dest: 1}, // index 1 -> UsersView
                                    {icon: "📚+", title: "Créer un cours", sub: "Ajouter un nouveau cours", bg: "#EBF8FF", iconCol: root.blueAccent, dest: 2}, // index 2 -> CoursesView
                                    {icon: "📝", title: "Gérer les inscriptions", sub: "Voir toutes les inscriptions", bg: "#FFF5EB", iconCol: root.orangeAccent, dest: 3}, // index 3 -> GradesView (or Enrollments)
                                    {icon: "📊", title: "Rapports et statistiques", sub: "Générer des rapports détaillés", bg: "#F0FFF4", iconCol: "#48BB78", dest: 0}
                                ]
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 60
                                    radius: 8
                                    color: modelData.bg
                                    
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 12
                                        
                                        Text {
                                            text: modelData.icon
                                            color: modelData.iconCol
                                            font.pixelSize: 20
                                        }
                                        
                                        Column {
                                            Layout.fillWidth: true
                                            Text { text: modelData.title; font.pixelSize: 13; font.weight: Font.DemiBold; color: root.textColor }
                                            Text { text: modelData.sub; font.pixelSize: 11; color: root.textLight }
                                        }
                                        
                                        Text {
                                            text: "›"
                                            color: modelData.iconCol
                                            font.pixelSize: 24
                                            font.weight: Font.Bold
                                        }
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                        onEntered: parent.opacity = 0.8
                                        onExited: parent.opacity = 1.0
                                        onClicked: {
                                            root.requestNavigation(modelData.dest);
                                        }
                                    }
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                }
                            }
                        }
                        
                        Item { Layout.fillHeight: true }
                    }
                }
            }

            // --- FOOTER ---
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 20
                
                Text {
                    text: "© 2025 USFAH - Tous droits réservés."
                    font.pixelSize: 12
                    color: root.textLight
                }
                
                Item { Layout.fillWidth: true }
                
                Text {
                    text: "Portail Administrateur v2.1.0"
                    font.pixelSize: 12
                    color: root.textLight
                }
            }
        }
    }

    // --- CUSTOM COMPONENTS ---

    component DashboardStatCard : Rectangle {
        property string icon: ""
        property color iconBgColor: "transparent"
        property string value: ""
        property string title: ""
        property string trendValue: ""
        property color trendColor: "transparent"

        Layout.preferredHeight: 110
        color: root.cardBg
        radius: 12
        
        layer.enabled: true
        layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.1; shadowColor: "#40000000" }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            Rectangle {
                width: 50
                height: 50
                radius: 12
                color: iconBgColor
                
                Text {
                    text: icon
                    color: "white"
                    font.pixelSize: 24
                    anchors.centerIn: parent
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: value
                    font.family: root.fontBold
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: root.textColor
                }
                
                Text {
                    text: title
                    font.family: root.fontRegular
                    font.pixelSize: 13
                    color: root.textLight
                }
            }
            
            // Trend Indicator
            ColumnLayout {
                Layout.alignment: Qt.AlignTop | Qt.AlignRight
                Text {
                    text: "↑ " + trendValue
                    color: trendColor
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    component BottomPanel : Rectangle {
        property string title: ""
        property string linkText: ""
        property var modelData: []
        property bool isCourseList: false

        Layout.fillWidth: true
        Layout.preferredHeight: parent.height
        color: root.cardBg
        radius: 12
        
        layer.enabled: true
        layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 0.8; shadowOpacity: 0.1; shadowColor: "#40000000" }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16
            
            Text {
                text: title
                font.family: root.fontBold
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: root.textColor
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16
                
                Repeater {
                    model: modelData
                    delegate: RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        Rectangle {
                            width: 36
                            height: 36
                            radius: isCourseList ? 8 : 18
                            color: isCourseList ? modelData.color : modelData.color
                            
                            Text {
                                text: modelData.icon
                                color: isCourseList ? modelData.iconColor : "white"
                                font.pixelSize: 18
                                anchors.centerIn: parent
                            }
                        }
                        
                        Column {
                            Layout.fillWidth: true
                            Text { text: modelData.title; font.pixelSize: 13; font.weight: Font.DemiBold; color: root.textColor; elide: Text.ElideRight; width: parent.width }
                            Text { text: modelData.sub; font.pixelSize: 11; color: root.textLight; elide: Text.ElideRight; width: parent.width }
                        }
                        
                        Text {
                            text: isCourseList ? modelData.val : modelData.time
                            font.pixelSize: 11
                            font.weight: isCourseList ? Font.Bold : Font.Normal
                            color: isCourseList ? root.textColor : root.textLight
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                        }
                    }
                }
            }
            
            Item { Layout.fillHeight: true }
            
            Text {
                text: linkText
                color: root.tealAccent
                font.pixelSize: 13
                font.weight: Font.DemiBold
                Layout.alignment: Qt.AlignHCenter
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.font.underline = true
                    onExited: parent.font.underline = false
                    onClicked: {
                        if (isCourseList) root.requestNavigation(2); // CoursesView
                        else console.log("Clicked Activities");
                    }
                }
            }
        }
    }
}
