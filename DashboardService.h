#ifndef DASHBOARDSERVICE_H
#define DASHBOARDSERVICE_H

#include <QObject>
#include <QVariantMap>
#include <QVariantList>

class AuthService;

class DashboardService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double averageGrade READ averageGrade NOTIFY dataChanged)
    Q_PROPERTY(int creditsValidated READ creditsValidated NOTIFY dataChanged)
    Q_PROPERTY(int totalCourses READ totalCourses NOTIFY dataChanged)
    Q_PROPERTY(double attendanceRate READ attendanceRate NOTIFY dataChanged)
    Q_PROPERTY(int attendanceTotal READ attendanceTotal NOTIFY dataChanged)
    Q_PROPERTY(int attendanceAbsences READ attendanceAbsences NOTIFY dataChanged)
    Q_PROPERTY(double financialBalance READ financialBalance NOTIFY dataChanged)
    Q_PROPERTY(double financialPaid READ financialPaid NOTIFY dataChanged)
    Q_PROPERTY(double financialTotal READ financialTotal NOTIFY dataChanged)
    Q_PROPERTY(QVariantMap nextClass READ nextClass NOTIFY dataChanged)
    Q_PROPERTY(QVariantList recentGrades READ recentGrades NOTIFY dataChanged)
    Q_PROPERTY(QVariantList currentCourses READ currentCourses NOTIFY dataChanged)
    Q_PROPERTY(QVariantList recentPayments READ recentPayments NOTIFY dataChanged)
    Q_PROPERTY(QVariantList performanceHistory READ performanceHistory NOTIFY dataChanged)

public:
    explicit DashboardService(AuthService *auth, QObject *parent = nullptr);

    double averageGrade() const { return m_averageGrade; }
    int creditsValidated() const { return m_creditsValidated; }
    int totalCourses() const { return m_totalCourses; }
    double attendanceRate() const { return m_attendanceRate; }
    int attendanceTotal() const { return m_attendanceTotal; }
    int attendanceAbsences() const { return m_attendanceAbsences; }
    double financialBalance() const { return m_financialBalance; }
    double financialPaid() const { return m_financialPaid; }
    double financialTotal() const { return m_financialTotal; }
    QVariantMap nextClass() const { return m_nextClass; }
    QVariantList recentGrades() const { return m_recentGrades; }
    QVariantList currentCourses() const { return m_currentCourses; }
    QVariantList recentPayments() const { return m_recentPayments; }
    QVariantList performanceHistory() const { return m_performanceHistory; }

public slots:
    void refreshData();
    void onDatabaseUpdated(const QString &tableName);

signals:
    void dataChanged();

private:
    AuthService *m_auth;

    double m_averageGrade = 0.0;
    int m_creditsValidated = 0;
    int m_totalCourses = 0;
    double m_attendanceRate = 0.0;
    int m_attendanceTotal = 0;
    int m_attendanceAbsences = 0;
    double m_financialBalance = 0.0;
    double m_financialPaid = 0.0;
    double m_financialTotal = 0.0;
    QVariantMap m_nextClass;
    QVariantList m_recentGrades;
    QVariantList m_currentCourses;
    QVariantList m_recentPayments;
    QVariantList m_performanceHistory;
    
    void loadKPIs();
    void loadNextClass();
    void loadRecentGrades();
    void loadCurrentCourses();
    void loadRecentPayments();
    void loadPerformanceHistory();
};

#endif // DASHBOARDSERVICE_H
