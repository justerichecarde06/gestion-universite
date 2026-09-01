import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent

    // Map day names to column indices (0=Lundi...5=Samedi)
    property var dayMap: { "Lundi": 0, "Mardi": 1, "Mercredi": 2, "Jeudi": 3, "Vendredi": 4, "Samedi": 5 }
    property var timeSlots: ["08:00 - 10:00", "10:00 - 12:00", "14:00 - 16:00", "16:00 - 18:00"]
    property var days: ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
    property var colors: ["#EFF6FF", "#F0FDF4", "#FFF7ED", "#F5F3FF", "#FEF3C7", "#FEF2F2"]
    property var borderColors: ["#3B82F6", "#22C55E", "#F97316", "#8B5CF6", "#F59E0B", "#EF4444"]

    // Helper: find a session at day+timeslot index from studentService.schedule
    function getSession(dayIndex, timeIndex) {
        var timeStart = timeSlots[timeIndex].split(" - ")[0]
        for (var i = 0; i < studentService.schedule.length; i++) {
            var s = studentService.schedule[i]
            var d = dayMap[s.jour] !== undefined ? dayMap[s.jour] : -1
            if (d === dayIndex && s.heure_debut === timeStart) {
                return s
            }
        }
        return null
    }

    function colorForIndex(i) { return colors[i % colors.length] }
    function borderForIndex(i) { return borderColors[i % borderColors.length] }

    Rectangle {
        anchors.fill: parent
        color: "#F3F4F6"

        ScrollView {
            anchors.fill: parent
            contentWidth: Math.max(width, 1100)
            contentHeight: contentCol.implicitHeight + 60
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ColumnLayout {
                id: contentCol
                width: Math.max(parent.width - 60, 1100)
                x: 30; y: 30
                spacing: 24

                // ── HEADER ──────────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    Column {
                        spacing: 4
                        Text {
                            text: "Mon Emploi du Temps"
                            font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#111827"
                        }
                        Text {
                            text: "Consultez votre planning de cours de la semaine."
                            font.family: "Inter"; font.pixelSize: 14; color: "#6B7280"
                        }
                    }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        width: 180; height: 44; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                            Column {
                                Layout.fillWidth: true; spacing: 0
                                Text { text: "Année académique"; font.pixelSize: 11; color: "#9CA3AF" }
                                Text { text: "2024-2025"; font.pixelSize: 13; color: "#374151"; font.weight: Font.Medium }
                            }
                            Text { text: "⌄"; color: "#6B7280"; font.pixelSize: 16 }
                        }
                    }
                }

                // ── STAT CARDS ───────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    Repeater {
                        model: [
                            { icon: "📅", label: "Cours cette semaine", value: studentService.schedule.length.toString(), color: "#3B82F6", bg: "#EFF6FF" },
                            { icon: "🏛️", label: "Salles différentes", value: "3", color: "#22C55E", bg: "#F0FDF4" },
                            { icon: "👨‍🏫", label: "Enseignants", value: "4", color: "#8B5CF6", bg: "#F5F3FF" },
                            { icon: "⏱️", label: "Heures/semaine", value: "18h", color: "#F97316", bg: "#FFF7ED" }
                        ]
                        delegate: Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 90
                            color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                            layer.enabled: true
                            layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 16; spacing: 14
                                Rectangle {
                                    width: 44; height: 44; radius: 10; color: modelData.bg
                                    Text { anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 20 }
                                }
                                Column {
                                    spacing: 3
                                    Text { text: modelData.label; font.pixelSize: 12; color: "#6B7280" }
                                    Text { text: modelData.value; font.pixelSize: 22; font.weight: Font.Bold; color: "#111827" }
                                }
                            }
                        }
                    }
                }

                // ── WEEKLY CALENDAR GRID ─────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    Layout.minimumHeight: timeSlots.length * 100 + 60
                    color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                    clip: true
                    layer.enabled: true
                    layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.04; shadowBlur: 10; shadowVerticalOffset: 2 }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        // Calendar header bar
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 56
                            color: "transparent"
                            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#E5E7EB" }
                            RowLayout {
                                anchors.fill: parent; anchors.leftMargin: 20; anchors.rightMargin: 20
                                Text { text: "📅  Vue hebdomadaire"; font.family: "Inter"; font.pixelSize: 15; font.weight: Font.Bold; color: "#111827"; Layout.fillWidth: true }
                                Rectangle {
                                    width: 100; height: 32; radius: 6; border.color: "#E5E7EB"; border.width: 1; color: "white"
                                    Text { anchors.centerIn: parent; text: "Aujourd'hui"; color: "#374151"; font.pixelSize: 13; font.weight: Font.Medium }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                                }
                            }
                        }

                        // Grid (time col + 6 day cols)
                        Flickable {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            contentWidth: Math.max(width, 1100)
                            contentHeight: calGrid.implicitHeight
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds

                            GridLayout {
                                id: calGrid
                                width: Math.max(parent.width, 1100)
                                columns: 7
                                rowSpacing: 0
                                columnSpacing: 0

                                // Header row
                                Rectangle {
                                    Layout.preferredWidth: 90; Layout.preferredHeight: 52; color: "transparent"
                                    Rectangle { width: 1; height: parent.height; color: "#E5E7EB"; anchors.right: parent.right }
                                    Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom }
                                }
                                Repeater {
                                    model: root.days
                                    Rectangle {
                                        Layout.fillWidth: true; Layout.preferredHeight: 52; color: "transparent"
                                        Rectangle { width: 1; height: parent.height; color: "#E5E7EB"; anchors.right: parent.right; visible: index < 5 }
                                        Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom }
                                        Text {
                                            anchors.centerIn: parent; text: modelData
                                            font.family: "Inter"; font.pixelSize: 13; font.weight: Font.SemiBold; color: "#374151"
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                }

                                // Time rows
                                Repeater {
                                    model: root.timeSlots.length * 7
                                    delegate: Rectangle {
                                        property int rowIdx: Math.floor(index / 7)
                                        property int colIdx: index % 7
                                        property var session: colIdx > 0 ? root.getSession(colIdx - 1, rowIdx) : null

                                        Layout.preferredWidth: colIdx === 0 ? 90 : -1
                                        Layout.fillWidth: colIdx !== 0
                                        Layout.preferredHeight: 100
                                        color: "transparent"

                                        Rectangle { width: 1; height: parent.height; color: "#E5E7EB"; anchors.right: parent.right; visible: colIdx < 6 }
                                        Rectangle { width: parent.width; height: 1; color: "#E5E7EB"; anchors.bottom: parent.bottom; visible: rowIdx < root.timeSlots.length - 1 }

                                        // Time label column
                                        Text {
                                            visible: colIdx === 0
                                            anchors.centerIn: parent
                                            text: root.timeSlots[rowIdx]
                                            font.pixelSize: 11; font.weight: Font.Medium; color: "#6B7280"
                                            horizontalAlignment: Text.AlignHCenter
                                        }

                                        // Session card (if any)
                                        Item {
                                            anchors.fill: parent; anchors.margins: 5
                                            visible: colIdx > 0

                                            Rectangle {
                                                anchors.fill: parent; radius: 8
                                                visible: parent.parent.session !== null
                                                color: parent.parent.session ? root.colorForIndex((parent.parent.rowIdx + parent.parent.colIdx) % root.colors.length) : "transparent"

                                                Rectangle {
                                                    width: 4; height: parent.height; radius: 4
                                                    color: parent.parent.parent.session
                                                        ? root.borderForIndex((parent.parent.parent.rowIdx + parent.parent.parent.colIdx) % root.borderColors.length)
                                                        : "transparent"
                                                    anchors.left: parent.left
                                                }

                                                Column {
                                                    anchors.fill: parent
                                                    anchors.margins: 8
                                                    anchors.leftMargin: 14
                                                    spacing: 3
                                                    clip: true

                                                    Text {
                                                        text: parent.parent.parent.parent.session ? parent.parent.parent.parent.session.cours : ""
                                                        font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold
                                                        color: parent.parent.parent.parent.session
                                                            ? root.borderForIndex((parent.parent.parent.parent.rowIdx + parent.parent.parent.parent.colIdx) % root.borderColors.length)
                                                            : "black"
                                                        elide: Text.ElideRight; width: parent.width
                                                    }
                                                    Text {
                                                        text: parent.parent.parent.parent.session ? parent.parent.parent.parent.session.enseignant : ""
                                                        font.pixelSize: 10; color: "#4B5563"
                                                        elide: Text.ElideRight; width: parent.width
                                                    }
                                                    Text {
                                                        text: parent.parent.parent.parent.session ? parent.parent.parent.parent.session.salle : ""
                                                        font.pixelSize: 10; color: "#6B7280"; font.weight: Font.Medium
                                                        elide: Text.ElideRight; width: parent.width
                                                    }
                                                }

                                                MouseArea {
                                                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
                                                    onEntered: parent.opacity = 0.85
                                                    onExited: parent.opacity = 1.0
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ── UPCOMING CLASSES LIST ────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                    layer.enabled: true
                    layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }

                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 24; spacing: 16

                        Text {
                            text: "📋  Tous mes cours"
                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827"
                        }

                        // Table header
                        RowLayout {
                            Layout.fillWidth: true; spacing: 0
                            Repeater {
                                model: ["Cours", "Enseignant", "Salle", "Jour", "Horaire"]
                                Text {
                                    text: modelData; font.pixelSize: 12; font.weight: Font.Medium; color: "#6B7280"
                                    Layout.fillWidth: true
                                    topPadding: 4; bottomPadding: 4
                                }
                            }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: "#E5E7EB" }

                        ListView {
                            Layout.fillWidth: true
                            implicitHeight: contentHeight
                            model: studentService.schedule
                            clip: true
                            spacing: 0
                            delegate: Item {
                                width: ListView.view.width
                                height: 52

                                Rectangle {
                                    anchors.fill: parent; color: index % 2 === 0 ? "white" : "#FAFAFA"; radius: 4
                                }

                                RowLayout {
                                    anchors.fill: parent; anchors.leftMargin: 0; anchors.rightMargin: 8; spacing: 0

                                    RowLayout {
                                        Layout.fillWidth: true; spacing: 10
                                        Rectangle {
                                            width: 32; height: 32; radius: 8
                                            color: root.colorForIndex(index)
                                            Text { anchors.centerIn: parent; text: "📖"; font.pixelSize: 14 }
                                        }
                                        Text {
                                            text: modelData.cours; font.pixelSize: 13; font.weight: Font.Medium; color: "#111827"
                                            elide: Text.ElideRight
                                        }
                                    }
                                    Text { text: modelData.enseignant; font.pixelSize: 13; color: "#4B5563"; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.salle; font.pixelSize: 13; color: "#6B7280"; Layout.fillWidth: true }
                                    Text { text: modelData.jour; font.pixelSize: 13; color: "#374151"; Layout.fillWidth: true; font.weight: Font.Medium }
                                    Text {
                                        text: modelData.heure_debut + " – " + modelData.heure_fin
                                        font.pixelSize: 13; color: "#2563EB"; font.weight: Font.SemiBold
                                        Layout.fillWidth: true
                                    }
                                }

                                Rectangle {
                                    anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#F3F4F6"
                                }
                            }
                        }

                        Text {
                            visible: studentService.schedule.length === 0
                            text: "Aucun cours n'est programmé pour le moment."
                            font.pixelSize: 14; color: "#9CA3AF"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
