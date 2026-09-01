import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent

    function formatMoney(amount) {
        return "$ " + Number(amount).toLocaleString(Qt.locale(), 'f', 2)
    }

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

                // --- HEADER SECTION ---
                RowLayout {
                    Layout.fillWidth: true
                    
                    Column {
                        spacing: 4
                        Text { text: "Finances"; font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#111827" }
                        Text { text: "Accueil > Finances"; font.family: "Inter"; font.pixelSize: 14; color: "#6B7280" }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    RowLayout {
                        spacing: 12
                        // Notifications
                        Rectangle {
                            width: 44; height: 44; radius: 22; color: "white"; border.color: "#E5E7EB"; border.width: 1
                            Text { anchors.centerIn: parent; text: "🔔"; font.pixelSize: 20 }
                            Rectangle { width: 18; height: 18; radius: 9; color: "#EF4444"; anchors.top: parent.top; anchors.right: parent.right; Text { anchors.centerIn: parent; text: "5"; color: "white"; font.pixelSize: 10; font.weight: Font.Bold } }
                        }
                        // Date picker dummy
                        Rectangle {
                            width: 160; height: 44; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 12; spacing: 8
                                Text { text: "📅"; font.pixelSize: 16 }
                                Text { text: "21 Juillet 2025"; font.family: "Inter"; font.pixelSize: 14; color: "#374151" }
                            }
                        }
                    }
                }
                
                // --- FILTERS ROW ---
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    
                    Rectangle {
                        width: 240; height: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 8
                            Text { text: "📅"; font.pixelSize: 14 }
                            Text { text: "01 Juin 2025 - 21 Juil. 2025"; font.family: "Inter"; font.pixelSize: 13; color: "#374151"; Layout.fillWidth: true }
                            Text { text: "⌄"; color: "#6B7280" }
                        }
                    }
                    
                    Rectangle {
                        width: 180; height: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 8
                            Text { text: "Tous les types"; font.family: "Inter"; font.pixelSize: 13; color: "#374151"; Layout.fillWidth: true }
                            Text { text: "⌄"; color: "#6B7280" }
                        }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Rectangle {
                        width: 140; height: 40; radius: 8; color: "white"; border.color: "#E5E7EB"; border.width: 1
                        RowLayout {
                            anchors.centerIn: parent; spacing: 8
                            Text { text: "📥"; font.pixelSize: 14 }
                            Text { text: "Exporter"; font.family: "Inter"; font.pixelSize: 13; font.weight: Font.Medium; color: "#374151" }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: adminFinanceService.exportTransactions() }
                    }
                    
                    Rectangle {
                        width: 200; height: 40; radius: 8; color: "#0F172A"
                        RowLayout {
                            anchors.centerIn: parent; spacing: 8
                            Text { text: "+"; color: "white"; font.pixelSize: 16; font.weight: Font.Bold }
                            Text { text: "Nouvelle transaction"; font.family: "Inter"; font.pixelSize: 13; font.weight: Font.Medium; color: "white" }
                        }
                        MouseArea { 
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: adminFinanceService.addTransaction("Nouvelle transaction manuelle", "Autres revenus", "Revenu", 500.0, "Réussi") 
                        }
                    }
                }
                
                // --- STATS CARDS ---
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20
                    
                    Component {
                        id: statCardComponent
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 110
                            color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                            layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                            
                            property string title: ""
                            property string value: ""
                            property string iconText: ""
                            property color iconColor: "blue"
                            property color iconBg: "lightblue"
                            property string growth: ""
                            property color growthColor: "#22C55E"
                            property string growthIcon: "↗"
                            
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 20; spacing: 16
                                Rectangle {
                                    width: 48; height: 48; radius: 12; color: parent.parent.iconBg
                                    Layout.alignment: Qt.AlignTop
                                    Text { anchors.centerIn: parent; text: parent.parent.parent.iconText; font.pixelSize: 22; color: parent.parent.parent.iconColor }
                                }
                                Column {
                                    spacing: 4
                                    Text { text: parent.parent.title; font.pixelSize: 13; color: "#6B7280" }
                                    Text { text: parent.parent.value; font.pixelSize: 24; font.weight: Font.Bold; color: parent.parent.iconColor }
                                    RowLayout {
                                        spacing: 4
                                        Text { text: parent.parent.parent.growthIcon + " " + parent.parent.parent.growth + "%"; font.pixelSize: 12; font.weight: Font.Bold; color: parent.parent.parent.growthColor }
                                        Text { text: "par rapport au mois dernier"; font.pixelSize: 11; color: "#9CA3AF" }
                                    }
                                }
                            }
                        }
                    }
                    
                    Loader { sourceComponent: statCardComponent; Layout.fillWidth: true; onLoaded: { item.title = "Revenus totaux"; item.value = root.formatMoney(adminFinanceService.totalRevenue); item.iconText = "📈"; item.iconColor = "#22C55E"; item.iconBg = "#F0FDF4"; item.growth = adminFinanceService.revenueGrowth; } }
                    Loader { sourceComponent: statCardComponent; Layout.fillWidth: true; onLoaded: { item.title = "Dépense totales"; item.value = root.formatMoney(adminFinanceService.totalExpense); item.iconText = "📉"; item.iconColor = "#EF4444"; item.iconBg = "#FEF2F2"; item.growth = adminFinanceService.expenseGrowth; item.growthColor = "#EF4444"; item.growthIcon = "↘" } }
                    Loader { sourceComponent: statCardComponent; Layout.fillWidth: true; onLoaded: { item.title = "Solde net"; item.value = root.formatMoney(adminFinanceService.netBalance); item.iconText = "💼"; item.iconColor = "#3B82F6"; item.iconBg = "#EFF6FF"; item.growth = adminFinanceService.netBalanceGrowth; } }
                    Loader { sourceComponent: statCardComponent; Layout.fillWidth: true; onLoaded: { item.title = "Transactions"; item.value = adminFinanceService.totalTransactions.toString(); item.iconText = "📊"; item.iconColor = "#8B5CF6"; item.iconBg = "#F5F3FF"; item.growth = adminFinanceService.transactionsGrowth; } }
                }

                // --- CHARTS PLACEHOLDERS ---
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 350
                    spacing: 24
                    
                    // Line Chart Placeholder
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 350
                        Layout.columnSpan: 2
                        color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                        layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                        
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 24; spacing: 16
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: "Évolution des revenus et dépenses"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827"; Layout.fillWidth: true }
                                Rectangle {
                                    width: 130
                                    height: 32
                                    radius: 6
                                    border.color: "#E5E7EB"
                                    border.width: 1
                                    color: "white"
                                    RowLayout {
                                        anchors.centerIn: parent
                                        spacing: 6
                                        Text { text: "6 derniers mois"; font.pixelSize: 12; color: "#374151" }
                                        Text { text: "⌄"; color: "#6B7280" }
                                    }
                                }
                            }
                            Item { Layout.fillWidth: true; Layout.fillHeight: true; Text { anchors.centerIn: parent; text: "Graphique linéaire en cours de chargement..."; color: "#9CA3AF" } }
                        }
                    }
                    
                    // Pie Chart Placeholder
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 400
                        Layout.preferredHeight: 350
                        color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                        layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                        
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 24; spacing: 16
                            Text { text: "Répartition par catégorie"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827" }
                            Item { Layout.fillWidth: true; Layout.fillHeight: true; Text { anchors.centerIn: parent; text: "Graphique circulaire en cours de chargement..."; color: "#9CA3AF" } }
                        }
                    }
                }

                // --- DATA TABLES ---
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 450
                    spacing: 24
                    
                    // Transactions Table
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                        layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                        clip: true
                        
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 24; spacing: 16
                            
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: "Transactions récentes"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827"; Layout.fillWidth: true }
                                Text { text: "Voir toutes les transactions"; font.pixelSize: 13; font.weight: Font.Medium; color: "#3B82F6"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor } }
                            }
                            
                            // Table Header
                            RowLayout {
                                Layout.fillWidth: true; spacing: 16
                                Text { text: "Date"; font.pixelSize: 12; color: "#6B7280"; Layout.preferredWidth: 100 }
                                Text { text: "Description"; font.pixelSize: 12; color: "#6B7280"; Layout.fillWidth: true }
                                Text { text: "Catégorie"; font.pixelSize: 12; color: "#6B7280"; Layout.preferredWidth: 100 }
                                Text { text: "Type"; font.pixelSize: 12; color: "#6B7280"; Layout.preferredWidth: 80 }
                                Text { text: "Montant"; font.pixelSize: 12; color: "#6B7280"; Layout.preferredWidth: 100 }
                                Text { text: "Statut"; font.pixelSize: 12; color: "#6B7280"; Layout.preferredWidth: 80 }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: "#E5E7EB" }
                            
                            // Table Content
                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                model: adminFinanceService.recentTransactions
                                clip: true
                                spacing: 16
                                delegate: RowLayout {
                                    width: ListView.view.width
                                    spacing: 16
                                    Text { text: modelData.date; font.pixelSize: 13; color: "#374151"; Layout.preferredWidth: 100 }
                                    Text { text: modelData.description; font.pixelSize: 13; font.weight: Font.Medium; color: "#111827"; Layout.fillWidth: true; elide: Text.ElideRight }
                                    
                                    // Category Badge
                                    Rectangle {
                                        Layout.preferredWidth: 100; Layout.preferredHeight: 24; radius: 12; color: modelData.category === "Inscriptions" ? "#DCFCE7" : (modelData.category === "Dépenses" ? "#FEE2E2" : "#DBEAFE")
                                        Text { anchors.centerIn: parent; text: modelData.category; font.pixelSize: 11; font.weight: Font.Medium; color: modelData.category === "Inscriptions" ? "#166534" : (modelData.category === "Dépenses" ? "#991B1B" : "#1E40AF") }
                                    }
                                    
                                    Text { text: modelData.type; font.pixelSize: 13; font.weight: Font.Medium; color: modelData.type === "Revenu" ? "#16A34A" : "#DC2626"; Layout.preferredWidth: 80 }
                                    Text { text: root.formatMoney(modelData.amount); font.pixelSize: 13; font.weight: Font.Bold; color: modelData.type === "Revenu" ? "#16A34A" : "#DC2626"; Layout.preferredWidth: 100 }
                                    
                                    // Status Badge
                                    Rectangle {
                                        Layout.preferredWidth: 80; Layout.preferredHeight: 24; radius: 12; color: modelData.status === "Réussi" ? "#DCFCE7" : (modelData.status === "En attente" ? "#FEF3C7" : "#F3F4F6")
                                        Text { anchors.centerIn: parent; text: modelData.status; font.pixelSize: 11; font.weight: Font.Medium; color: modelData.status === "Réussi" ? "#166534" : (modelData.status === "En attente" ? "#B45309" : "#374151") }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Latest Payments
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 350
                        color: "white"; radius: 12; border.color: "#E5E7EB"; border.width: 1
                        layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowOpacity: 0.03; shadowBlur: 8; shadowVerticalOffset: 2 }
                        
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 24; spacing: 20
                            
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: "Derniers paiements reçus"; font.pixelSize: 16; font.weight: Font.Bold; color: "#111827"; Layout.fillWidth: true }
                                Text { text: "Voir tout"; font.pixelSize: 13; font.weight: Font.Medium; color: "#3B82F6"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor } }
                            }
                            
                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                model: adminFinanceService.latestPayments
                                clip: true
                                spacing: 20
                                delegate: RowLayout {
                                    width: ListView.view.width
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 40; height: 40; radius: 20; color: "#F3F4F6"
                                        Text { anchors.centerIn: parent; text: modelData.userInitial; font.pixelSize: 16; font.weight: Font.Bold; color: "#4B5563" }
                                    }
                                    
                                    Column {
                                        Layout.fillWidth: true; spacing: 4
                                        Text { text: modelData.userName; font.pixelSize: 14; font.weight: Font.Medium; color: "#111827" }
                                        Text { text: modelData.userProgram; font.pixelSize: 12; color: "#6B7280" }
                                    }
                                    
                                    Column {
                                        Layout.alignment: Qt.AlignRight; spacing: 4
                                        Text { text: root.formatMoney(modelData.amount); font.pixelSize: 14; font.weight: Font.Bold; color: "#16A34A"; anchors.right: parent.right }
                                        Text { text: modelData.date; font.pixelSize: 11; color: "#9CA3AF"; anchors.right: parent.right }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
