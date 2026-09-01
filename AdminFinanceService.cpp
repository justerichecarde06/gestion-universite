#include "AdminFinanceService.h"
#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>
#include <QDebug>

AdminFinanceService::AdminFinanceService(AuthService *authService, QObject *parent)
    : QObject(parent), m_authService(authService)
{
    // Update data when db changes
    connect(&DatabaseManager::instance(), &DatabaseManager::databaseUpdated, this, [this](const QString &tableName) {
        if (tableName == "transactions" || tableName == "users") {
            refreshData();
        }
    });

    refreshData();
}

double AdminFinanceService::totalRevenue() const { return m_totalRevenue; }
double AdminFinanceService::totalExpense() const { return m_totalExpense; }
double AdminFinanceService::netBalance() const { return m_totalRevenue - m_totalExpense; }
int AdminFinanceService::totalTransactions() const { return m_totalTransactions; }

double AdminFinanceService::revenueGrowth() const { return m_revenueGrowth; }
double AdminFinanceService::expenseGrowth() const { return m_expenseGrowth; }
double AdminFinanceService::netBalanceGrowth() const { return m_netBalanceGrowth; }
double AdminFinanceService::transactionsGrowth() const { return m_transactionsGrowth; }

QVariantList AdminFinanceService::recentTransactions() const { return m_recentTransactions; }
QVariantList AdminFinanceService::latestPayments() const { return m_latestPayments; }

void AdminFinanceService::refreshData()
{
    loadStats();
    loadTransactions();
    emit statsChanged();
    emit transactionsChanged();
}

void AdminFinanceService::loadStats()
{
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    
    // Revenue
    QSqlQuery qRev("SELECT SUM(montant) FROM transactions WHERE type='Revenu' AND statut='Réussi'", db);
    m_totalRevenue = (qRev.next() && !qRev.value(0).isNull()) ? qRev.value(0).toDouble() : 0;
    
    // Expense
    QSqlQuery qExp("SELECT SUM(montant) FROM transactions WHERE type='Dépense' AND (statut='Réussi' OR statut='En attente')", db);
    m_totalExpense = (qExp.next() && !qExp.value(0).isNull()) ? qExp.value(0).toDouble() : 0;
    
    // Total transactions count
    QSqlQuery qCount("SELECT COUNT(*) FROM transactions", db);
    m_totalTransactions = (qCount.next()) ? qCount.value(0).toInt() : 0;
}

void AdminFinanceService::loadTransactions()
{
    m_recentTransactions.clear();
    m_latestPayments.clear();
    
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    
    // Recent Transactions
    QSqlQuery query("SELECT date, description, categorie, type, montant, statut FROM transactions ORDER BY id DESC LIMIT 10", db);
    while (query.next()) {
        QVariantMap t;
        t["date"] = query.value(0).toString();
        t["description"] = query.value(1).toString();
        t["category"] = query.value(2).toString();
        t["type"] = query.value(3).toString();
        t["amount"] = query.value(4).toDouble();
        t["status"] = query.value(5).toString();
        m_recentTransactions.append(t);
    }
    
    // Latest Payments (users)
    QSqlQuery queryPay("SELECT t.date, t.montant, u.nom, u.prenom, u.filiere FROM transactions t JOIN users u ON t.user_id = u.id WHERE t.type='Revenu' AND t.statut='Réussi' ORDER BY t.id DESC LIMIT 5", db);
    while (queryPay.next()) {
        QVariantMap p;
        p["date"] = queryPay.value(0).toString();
        p["amount"] = queryPay.value(1).toDouble();
        QString nom = queryPay.value(2).toString();
        QString prenom = queryPay.value(3).toString();
        p["userName"] = nom + " " + prenom;
        p["userProgram"] = queryPay.value(4).toString();
        p["userInitial"] = nom.left(1).toUpper();
        m_latestPayments.append(p);
    }
}

void AdminFinanceService::addTransaction(const QString &description, const QString &category, const QString &type, double amount, const QString &status)
{
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    QSqlQuery query(db);
    query.prepare("INSERT INTO transactions (date, description, categorie, type, montant, statut, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)");
    
    // Format date properly (e.g. "21 Juil. 2025")
    QString dateStr = QDateTime::currentDateTime().toString("dd MMM. yyyy");
    dateStr.replace("Aug", "Août").replace("May", "Mai").replace("Jul", "Juil").replace("Jun", "Juin").replace("Apr", "Avr");
    
    query.addBindValue(dateStr);
    query.addBindValue(description);
    query.addBindValue(category);
    query.addBindValue(type);
    query.addBindValue(amount);
    query.addBindValue(status);
    query.addBindValue(QVariant(QMetaType::fromType<int>())); // null user_id for generic
    
    if (query.exec()) {
        DatabaseManager::instance().notifyUpdate("transactions");
    } else {
        qWarning() << "Error adding transaction:" << query.lastError().text();
    }
}

void AdminFinanceService::exportTransactions()
{
    qDebug() << "Exporting transactions...";
    if (m_authService) {
        DatabaseManager::logActivity(m_authService->currentUserId(), "Exportation Finances", "Export de toutes les transactions au format CSV");
    }
}
