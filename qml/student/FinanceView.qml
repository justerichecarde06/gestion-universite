import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent

    // Design tokens
    property string primaryDark: "#0F2B46"
    property string tealAccent: "#00B4B1"
    property string greenPositive: "#16A34A"
    property string orangeWarning: "#F59E0B"
    property string redNegative: "#EF4444"
    property string cardBg: "white"
    property string pageBg: "#F8FAFC"
    property string textDark: "#111827"
    property string textMed: "#4B5563"
    property string textLight: "#9CA3AF"

    // Data from backend
    property var summary: studentService.financeSummary || {}
    property var payments: studentService.finances || []

    function formatMoney(val) {
        var num = Number(val) || 0
        return "$" + num.toLocaleString(Qt.locale("fr-FR"), 'f', 2)
    }

    function formatDate(dateStr) {
        if (!dateStr) return "--"
        var d = new Date(dateStr)
        var months = ["janv.", "févr.", "mars", "avr.", "mai", "juin", "juil.", "août", "sept.", "oct.", "nov.", "déc."]
        return (d.getDate() < 10 ? "0" : "") + d.getDate() + " " + months[d.getMonth()] + " " + d.getFullYear()
    }

    Rectangle {
        anchors.fill: parent
        color: root.pageBg
    }

    Flickable {
        anchors.fill: parent
        contentHeight: mainCol.implicitHeight + 60
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: mainCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 32
            spacing: 24

            // ── HEADER ──
            Column {
                spacing: 4
                Text {
                    text: "Mes Finances"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: root.primaryDark
                }
                Text {
                    text: "Gérez vos paiements, frais et relevés."
                    font.pixelSize: 14
                    color: root.textMed
                }
            }

            // ── STATS CARDS ROW ──
            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                // Card 1: Solde actuel
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    radius: 12
                    color: root.cardBg
                    border.color: "#E5E7EB"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 10
                            color: "#EFF6FF"
                            Text { anchors.centerIn: parent; text: "💰"; font.pixelSize: 20 }
                        }

                        Column {
                            spacing: 2
                            Text { text: "Solde actuel"; font.pixelSize: 12; color: root.textLight }
                            Text { text: formatMoney(root.summary.soldeActuel); font.pixelSize: 22; font.weight: Font.Bold; color: root.textDark }
                            Text { text: "Disponible"; font.pixelSize: 11; color: root.greenPositive }
                        }
                    }
                }

                // Card 2: Frais payés
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    radius: 12
                    color: root.cardBg
                    border.color: "#E5E7EB"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 10
                            color: "#F0FDF4"
                            Text { anchors.centerIn: parent; text: "✅"; font.pixelSize: 20 }
                        }

                        Column {
                            spacing: 2
                            Text { text: "Frais payés"; font.pixelSize: 12; color: root.textLight }
                            Text { text: formatMoney(root.summary.totalPaye); font.pixelSize: 22; font.weight: Font.Bold; color: root.greenPositive }
                            Text { text: "Année académique " + (root.summary.anneeAcademique || "2024-2025"); font.pixelSize: 11; color: root.textLight }
                        }
                    }
                }

                // Card 3: Frais restants
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    radius: 12
                    color: root.cardBg
                    border.color: "#E5E7EB"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 10
                            color: "#FFF7ED"
                            Text { anchors.centerIn: parent; text: "⚠️"; font.pixelSize: 20 }
                        }

                        Column {
                            spacing: 2
                            Text { text: "Frais restants"; font.pixelSize: 12; color: root.textLight }
                            Text { text: formatMoney(root.summary.totalRestant); font.pixelSize: 22; font.weight: Font.Bold; color: root.orangeWarning }
                            Text { text: "À payer"; font.pixelSize: 11; color: root.orangeWarning }
                        }
                    }
                }

                // Card 4: Prochain paiement
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    radius: 12
                    color: root.cardBg
                    border.color: "#E5E7EB"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 10
                            color: "#F5F3FF"
                            Text { anchors.centerIn: parent; text: "📅"; font.pixelSize: 20 }
                        }

                        Column {
                            spacing: 2
                            Text { text: "Prochain paiement"; font.pixelSize: 12; color: root.textLight }
                            Text { text: root.summary.prochainPaiement || "—"; font.pixelSize: 22; font.weight: Font.Bold; color: root.textDark }
                            Text { text: "Échéance"; font.pixelSize: 11; color: root.textLight }
                        }
                    }
                }
            }

            // ── MIDDLE SECTION: Donut + Fee Detail ──
            RowLayout {
                Layout.fillWidth: true
                spacing: 20

                // LEFT: Aperçu des paiements (Donut Chart)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 480
                    Layout.preferredHeight: 320
                    radius: 12
                    color: root.cardBg
                    border.color: "#E5E7EB"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 16

                        // Header
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Aperçu des paiements"
                                font.pixelSize: 16
                                font.weight: Font.Bold
                                color: root.textDark
                                Layout.fillWidth: true
                            }
                            Rectangle {
                                width: 180
                                height: 30
                                radius: 6
                                border.color: "#E5E7EB"
                                border.width: 1
                                color: root.cardBg
                                Text {
                                    anchors.centerIn: parent
                                    text: "Année académique 2024-2025  ⌄"
                                    font.pixelSize: 12
                                    color: root.textMed
                                }
                            }
                        }

                        // Donut + Legend
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 30

                            // Donut Chart (Canvas)
                            Item {
                                Layout.preferredWidth: 170
                                Layout.preferredHeight: 170
                                Layout.alignment: Qt.AlignVCenter

                                Canvas {
                                    id: donutCanvas
                                    anchors.fill: parent

                                    property real paidPct: (root.summary.pourcentagePaye || 0) / 100.0

                                    onPaidPctChanged: requestPaint()
                                    Component.onCompleted: requestPaint()

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.reset()

                                        var cx = width / 2
                                        var cy = height / 2
                                        var radius = Math.min(cx, cy) - 8
                                        var innerRadius = radius * 0.65
                                        var startAngle = -Math.PI / 2

                                        // Paid arc (Teal)
                                        var paidEnd = startAngle + (2 * Math.PI * paidPct)
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, radius, startAngle, paidEnd)
                                        ctx.arc(cx, cy, innerRadius, paidEnd, startAngle, true)
                                        ctx.closePath()
                                        ctx.fillStyle = "#00B4B1"
                                        ctx.fill()

                                        // Remaining arc (Orange)
                                        ctx.beginPath()
                                        ctx.arc(cx, cy, radius, paidEnd, startAngle + 2 * Math.PI)
                                        ctx.arc(cx, cy, innerRadius, startAngle + 2 * Math.PI, paidEnd, true)
                                        ctx.closePath()
                                        ctx.fillStyle = "#F59E0B"
                                        ctx.fill()
                                    }
                                }

                                // Center label
                                Column {
                                    anchors.centerIn: parent
                                    spacing: 2
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: (root.summary.pourcentagePaye || 0) + "%"
                                        font.pixelSize: 28
                                        font.weight: Font.Bold
                                        color: root.primaryDark
                                    }
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Payé"
                                        font.pixelSize: 13
                                        color: root.textMed
                                    }
                                }
                            }

                            // Legend
                            Column {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 14

                                // Total frais
                                RowLayout {
                                    spacing: 10
                                    Rectangle { width: 12; height: 12; radius: 6; color: "#3B82F6" }
                                    Text { text: "Total frais"; font.pixelSize: 13; color: root.textMed; Layout.fillWidth: true }
                                    Text { text: formatMoney(root.summary.totalFrais); font.pixelSize: 14; font.weight: Font.Bold; color: root.textDark }
                                }
                                // Frais payés
                                RowLayout {
                                    spacing: 10
                                    Rectangle { width: 12; height: 12; radius: 6; color: root.greenPositive }
                                    Text { text: "Frais payés"; font.pixelSize: 13; color: root.textMed; Layout.fillWidth: true }
                                    Text { text: formatMoney(root.summary.totalPaye); font.pixelSize: 14; font.weight: Font.Bold; color: root.textDark }
                                }
                                // Frais restants
                                RowLayout {
                                    spacing: 10
                                    Rectangle { width: 12; height: 12; radius: 6; color: root.orangeWarning }
                                    Text { text: "Frais restants"; font.pixelSize: 13; color: root.textMed; Layout.fillWidth: true }
                                    Text { text: formatMoney(root.summary.totalRestant); font.pixelSize: 14; font.weight: Font.Bold; color: root.textDark }
                                }
                            }
                        }

                        // Status bar
                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            radius: 8
                            color: (root.summary.pourcentagePaye || 0) >= 100 ? "#F0FDF4" : "#FFFBEB"

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                Text {
                                    text: (root.summary.pourcentagePaye || 0) >= 100 ? "✅" : "⏳"
                                    font.pixelSize: 16
                                }
                                Text {
                                    text: (root.summary.pourcentagePaye || 0) >= 100
                                          ? "Vous êtes à jour dans vos paiements."
                                          : "Il reste des frais à régler."
                                    font.pixelSize: 13
                                    color: (root.summary.pourcentagePaye || 0) >= 100 ? root.greenPositive : "#92400E"
                                    font.weight: Font.Medium
                                }
                            }
                        }
                    }
                }

                // RIGHT: Détail des frais
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 420
                    Layout.preferredHeight: 320
                    radius: 12
                    color: root.cardBg
                    border.color: "#E5E7EB"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 12

                        // Header
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Détail des frais"
                                font.pixelSize: 16
                                font.weight: Font.Bold
                                color: root.textDark
                                Layout.fillWidth: true
                            }
                            Text {
                                text: "Voir tout"
                                font.pixelSize: 12
                                color: root.tealAccent
                                font.weight: Font.Medium
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }

                        // Table Header
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: "Description"; font.pixelSize: 12; color: root.textLight; font.weight: Font.Medium; Layout.fillWidth: true }
                            Text { text: "Montant"; font.pixelSize: 12; color: root.textLight; font.weight: Font.Medium; Layout.preferredWidth: 90; horizontalAlignment: Text.AlignRight }
                            Text { text: "Statut"; font.pixelSize: 12; color: root.textLight; font.weight: Font.Medium; Layout.preferredWidth: 100; horizontalAlignment: Text.AlignRight }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#F3F4F6" }

                        // Fee rows
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            model: root.payments
                            spacing: 0

                            delegate: Item {
                                width: ListView.view.width
                                height: 36

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0

                                    Text {
                                        text: modelData.description || modelData.reference || "Paiement"
                                        font.pixelSize: 13
                                        color: root.textDark
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: formatMoney(modelData.montant)
                                        font.pixelSize: 13
                                        color: root.textDark
                                        Layout.preferredWidth: 90
                                        horizontalAlignment: Text.AlignRight
                                    }

                                    Item {
                                        Layout.preferredWidth: 100

                                        Rectangle {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: statusRow.implicitWidth + 16
                                            height: 22
                                            radius: 4
                                            color: modelData.statut === "Payé" ? "#F0FDF4" : "#FFFBEB"

                                            Row {
                                                id: statusRow
                                                anchors.centerIn: parent
                                                spacing: 4
                                                Text {
                                                    text: modelData.statut === "Payé" ? "✓" : "⏳"
                                                    font.pixelSize: 10
                                                    color: modelData.statut === "Payé" ? root.greenPositive : root.orangeWarning
                                                }
                                                Text {
                                                    text: modelData.statut
                                                    font.pixelSize: 11
                                                    font.weight: Font.Medium
                                                    color: modelData.statut === "Payé" ? root.greenPositive : root.orangeWarning
                                                }
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    width: parent.width
                                    height: 1
                                    color: "#F9FAFB"
                                }
                            }
                        }

                        // Total row
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#E5E7EB"
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Total"; font.pixelSize: 14; font.weight: Font.Bold; color: root.textDark; Layout.fillWidth: true }
                            Text { text: formatMoney(root.summary.totalFrais); font.pixelSize: 14; font.weight: Font.Bold; color: root.textDark }
                        }
                    }
                }
            }

            // ── BOTTOM: Historique des transactions ──
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.max(380, transHistoryCol.implicitHeight + 48)
                radius: 12
                color: root.cardBg
                border.color: "#E5E7EB"
                border.width: 1

                ColumnLayout {
                    id: transHistoryCol
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 12

                    // Header
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Historique des transactions"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: root.textDark
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "Voir tout"
                            font.pixelSize: 12
                            color: root.tealAccent
                            font.weight: Font.Medium
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }

                    // Table Header
                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        color: "#F9FAFB"
                        radius: 6

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 0

                            Text { text: "Date"; font.pixelSize: 12; color: root.textLight; font.weight: Font.DemiBold; Layout.preferredWidth: 130 }
                            Text { text: "Description"; font.pixelSize: 12; color: root.textLight; font.weight: Font.DemiBold; Layout.fillWidth: true }
                            Text { text: "Montant"; font.pixelSize: 12; color: root.textLight; font.weight: Font.DemiBold; Layout.preferredWidth: 100 }
                            Text { text: "Méthode"; font.pixelSize: 12; color: root.textLight; font.weight: Font.DemiBold; Layout.preferredWidth: 130 }
                            Text { text: "Statut"; font.pixelSize: 12; color: root.textLight; font.weight: Font.DemiBold; Layout.preferredWidth: 100 }
                            Text { text: "Reçu"; font.pixelSize: 12; color: root.textLight; font.weight: Font.DemiBold; Layout.preferredWidth: 50; horizontalAlignment: Text.AlignHCenter }
                        }
                    }

                    // Table Rows
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        model: root.payments

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 52
                            color: index % 2 === 0 ? "white" : "#FAFAFA"

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: "#F3F4F6"
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 0

                                Text {
                                    text: formatDate(modelData.date)
                                    font.pixelSize: 13
                                    color: root.textDark
                                    Layout.preferredWidth: 130
                                }

                                Text {
                                    text: modelData.description || modelData.reference || "Paiement"
                                    font.pixelSize: 13
                                    color: root.textDark
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: formatMoney(modelData.montant)
                                    font.pixelSize: 13
                                    font.weight: Font.DemiBold
                                    color: root.textDark
                                    Layout.preferredWidth: 100
                                }

                                Text {
                                    text: modelData.mode || "—"
                                    font.pixelSize: 13
                                    color: root.textMed
                                    Layout.preferredWidth: 130
                                }

                                // Status badge
                                Item {
                                    Layout.preferredWidth: 100

                                    Rectangle {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: statusTxt.implicitWidth + 18
                                        height: 24
                                        radius: 4
                                        color: modelData.statut === "Payé" ? "#F0FDF4" : "#FFFBEB"

                                        Row {
                                            id: statusTxt
                                            anchors.centerIn: parent
                                            spacing: 4
                                            Text {
                                                text: modelData.statut === "Payé" ? "✓" : "⏳"
                                                font.pixelSize: 11
                                                color: modelData.statut === "Payé" ? root.greenPositive : root.orangeWarning
                                            }
                                            Text {
                                                text: modelData.statut
                                                font.pixelSize: 12
                                                font.weight: Font.Medium
                                                color: modelData.statut === "Payé" ? root.greenPositive : root.orangeWarning
                                            }
                                        }
                                    }
                                }

                                // Download receipt button
                                Item {
                                    Layout.preferredWidth: 50
                                    Layout.alignment: Qt.AlignHCenter

                                    Rectangle {
                                        visible: modelData.statut === "Payé"
                                        anchors.centerIn: parent
                                        width: 30
                                        height: 30
                                        radius: 6
                                        color: dlMouse.containsMouse ? "#F0F9FF" : "transparent"
                                        border.color: dlMouse.containsMouse ? "#BAE6FD" : "transparent"
                                        border.width: 1

                                        Text {
                                            anchors.centerIn: parent
                                            text: "⬇"
                                            font.pixelSize: 16
                                            color: "#3B82F6"
                                        }

                                        MouseArea {
                                            id: dlMouse
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            hoverEnabled: true
                                            onClicked: {
                                                console.log("Télécharger reçu:", modelData.reference)
                                            }
                                        }
                                    }

                                    Text {
                                        visible: modelData.statut !== "Payé"
                                        anchors.centerIn: parent
                                        text: "—"
                                        color: root.textLight
                                        font.pixelSize: 13
                                    }
                                }
                            }
                        }
                    }

                    // Footer: load more
                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "Afficher plus d'historique ⌄"
                            font.pixelSize: 13
                            color: root.textMed
                            font.weight: Font.Medium

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    console.log("Charger plus de transactions")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
