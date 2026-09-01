#ifndef ADMINFINANCESERVICE_H
#define ADMINFINANCESERVICE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class AuthService;

class AdminFinanceService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double totalRevenue READ totalRevenue NOTIFY statsChanged)
    Q_PROPERTY(double totalExpense READ totalExpense NOTIFY statsChanged)
    Q_PROPERTY(double netBalance READ netBalance NOTIFY statsChanged)
    Q_PROPERTY(int totalTransactions READ totalTransactions NOTIFY statsChanged)
    
    Q_PROPERTY(double revenueGrowth READ revenueGrowth NOTIFY statsChanged)
    Q_PROPERTY(double expenseGrowth READ expenseGrowth NOTIFY statsChanged)
    Q_PROPERTY(double netBalanceGrowth READ netBalanceGrowth NOTIFY statsChanged)
    Q_PROPERTY(double transactionsGrowth READ transactionsGrowth NOTIFY statsChanged)
    
    Q_PROPERTY(QVariantList recentTransactions READ recentTransactions NOTIFY transactionsChanged)
    Q_PROPERTY(QVariantList latestPayments READ latestPayments NOTIFY transactionsChanged)

public:
    explicit AdminFinanceService(AuthService *authService, QObject *parent = nullptr);

    double totalRevenue() const;
    double totalExpense() const;
    double netBalance() const;
    int totalTransactions() const;
    
    double revenueGrowth() const;
    double expenseGrowth() const;
    double netBalanceGrowth() const;
    double transactionsGrowth() const;

    QVariantList recentTransactions() const;
    QVariantList latestPayments() const;

public slots:
    Q_INVOKABLE void addTransaction(const QString &description, const QString &category, const QString &type, double amount, const QString &status);
    Q_INVOKABLE void exportTransactions();
    Q_INVOKABLE void refreshData();

signals:
    void statsChanged();
    void transactionsChanged();

private:
    AuthService *m_authService;
    
    double m_totalRevenue = 0;
    double m_totalExpense = 0;
    int m_totalTransactions = 0;
    
    double m_revenueGrowth = 15.0; 
    double m_expenseGrowth = 8.0;
    double m_netBalanceGrowth = 22.0;
    double m_transactionsGrowth = 12.0;
    
    QVariantList m_recentTransactions;
    QVariantList m_latestPayments;
    
    void loadStats();
    void loadTransactions();
};

#endif // ADMINFINANCESERVICE_H
