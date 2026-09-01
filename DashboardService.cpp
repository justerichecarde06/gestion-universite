#include "DashboardService.h"
#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>

DashboardService::DashboardService(AuthService *auth, QObject *parent)
    : QObject(parent), m_auth(auth)
{
    connect(m_auth, &AuthService::currentUserIdChanged, this, &DashboardService::refreshData);
    connect(&DatabaseManager::instance(), &DatabaseManager::databaseUpdated, this, &DashboardService::onDatabaseUpdated);
}

void DashboardService::onDatabaseUpdated(const QString &tableName)
{
    // Refresh if relevant tables are updated
    if (tableName == "evaluations" || tableName == "enrollments" || tableName == "presences" || 
        tableName == "payments" || tableName == "sessions") {
        refreshData();
    }
}

void DashboardService::refreshData()
{
    if (m_auth->currentUserId() == -1) {
        m_averageGrade = 0.0;
        m_creditsValidated = 0;
        m_totalCourses = 0;
        m_attendanceRate = 0.0;
        m_attendanceTotal = 0;
        m_attendanceAbsences = 0;
        m_financialBalance = 0.0;
        m_financialPaid = 0.0;
        m_financialTotal = 0.0;
        m_nextClass.clear();
        m_recentGrades.clear();
        m_currentCourses.clear();
        m_recentPayments.clear();
        m_performanceHistory.clear();
        emit dataChanged();
        return;
    }

    loadKPIs();
    loadNextClass();
    loadRecentGrades();
    loadCurrentCourses();
    loadRecentPayments();
    loadPerformanceHistory();
    
    emit dataChanged();
}

void DashboardService::loadKPIs()
{
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    int studentId = m_auth->currentUserId();

    // 1. Average Grade & Total Validated Credits
    m_averageGrade = 0.0;
    m_creditsValidated = 0;
    
    QSqlQuery gradeQuery(db);
    gradeQuery.prepare("SELECT AVG(ev.valeur) as avg_grade "
                       "FROM evaluations ev "
                       "JOIN enrollments e ON ev.inscription_id = e.id "
                       "WHERE e.etudiant_id = :id");
    gradeQuery.bindValue(":id", studentId);
    if (gradeQuery.exec() && gradeQuery.next()) {
        m_averageGrade = gradeQuery.value("avg_grade").toDouble();
    }

    QSqlQuery creditQuery(db);
    creditQuery.prepare("SELECT SUM(c.credits) as total_credits "
                        "FROM enrollments e "
                        "JOIN courses c ON e.cours_id = c.id "
                        "WHERE e.etudiant_id = :id AND e.statut = 'Validé'");
    creditQuery.bindValue(":id", studentId);
    if (creditQuery.exec() && creditQuery.next()) {
        m_creditsValidated = creditQuery.value("total_credits").toInt();
    }

    // 2. Total Current Courses
    m_totalCourses = 0;
    QSqlQuery coursesQuery(db);
    coursesQuery.prepare("SELECT COUNT(id) as count FROM enrollments WHERE etudiant_id = :id AND statut = 'Inscrit'");
    coursesQuery.bindValue(":id", studentId);
    if (coursesQuery.exec() && coursesQuery.next()) {
        m_totalCourses = coursesQuery.value("count").toInt();
    }

    // 3. Attendance Rate
    m_attendanceRate = 0.0;
    m_attendanceTotal = 0;
    m_attendanceAbsences = 0;
    
    QSqlQuery attQuery(db);
    attQuery.prepare("SELECT SUM(p.present) as presents, COUNT(p.id) as total "
                     "FROM presences p "
                     "JOIN enrollments e ON p.inscription_id = e.id "
                     "WHERE e.etudiant_id = :id");
    attQuery.bindValue(":id", studentId);
    if (attQuery.exec() && attQuery.next()) {
        int presents = attQuery.value("presents").toInt();
        m_attendanceTotal = attQuery.value("total").toInt();
        m_attendanceAbsences = m_attendanceTotal - presents;
        
        if (m_attendanceTotal > 0) {
            m_attendanceRate = (double)presents / m_attendanceTotal * 100.0;
        } else {
            m_attendanceRate = 100.0; // Assume 100% if no sessions yet
        }
    }

    // 4. Finances
    m_financialPaid = 0.0;
    m_financialTotal = 150000.0; // Fixed total for now, or could come from a 'fees' table
    m_financialBalance = m_financialTotal;
    
    QSqlQuery finQuery(db);
    finQuery.prepare("SELECT SUM(montant) as paid FROM payments WHERE etudiant_id = :id AND statut = 'Payé'");
    finQuery.bindValue(":id", studentId);
    if (finQuery.exec() && finQuery.next()) {
        m_financialPaid = finQuery.value("paid").toDouble();
        m_financialBalance = m_financialTotal - m_financialPaid;
    }
}

void DashboardService::loadNextClass()
{
    m_nextClass.clear();
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    
    // For simplicity, we just fetch the next session based on time, or simply the first one in the DB for now.
    QSqlQuery query(db);
    query.prepare("SELECT c.intitule, s.jour, s.heure_debut, s.heure_fin, r.nom AS salle, u.nom AS enseignant "
                  "FROM sessions s "
                  "JOIN courses c ON s.cours_id = c.id "
                  "JOIN rooms r ON s.salle_id = r.id "
                  "JOIN users u ON s.enseignant_id = u.id "
                  "JOIN enrollments e ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id "
                  "ORDER BY s.id ASC LIMIT 1");
    query.bindValue(":id", m_auth->currentUserId());
    
    if (query.exec() && query.next()) {
        m_nextClass["cours"] = query.value("intitule").toString();
        m_nextClass["jour"] = query.value("jour").toString();
        m_nextClass["heure_debut"] = query.value("heure_debut").toString();
        m_nextClass["heure_fin"] = query.value("heure_fin").toString();
        m_nextClass["salle"] = query.value("salle").toString();
        m_nextClass["enseignant"] = query.value("enseignant").toString();
    }
}

void DashboardService::loadRecentGrades()
{
    m_recentGrades.clear();
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    QSqlQuery query(db);
    query.prepare("SELECT c.intitule, ev.type, ev.valeur, ev.coefficient, ev.date "
                  "FROM evaluations ev "
                  "JOIN enrollments e ON ev.inscription_id = e.id "
                  "JOIN courses c ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id "
                  "ORDER BY ev.date DESC LIMIT 5");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap grade;
            grade["cours"] = query.value("intitule").toString();
            grade["type"] = query.value("type").toString();
            grade["valeur"] = query.value("valeur").toDouble();
            grade["coefficient"] = query.value("coefficient").toDouble();
            grade["date"] = query.value("date").toString();
            m_recentGrades.append(grade);
        }
    }
}

void DashboardService::loadCurrentCourses()
{
    m_currentCourses.clear();
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    QSqlQuery query(db);
    query.prepare("SELECT c.code, c.intitule, c.credits, e.statut "
                  "FROM enrollments e "
                  "JOIN courses c ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id AND e.statut = 'Inscrit' LIMIT 5");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap course;
            course["code"] = query.value("code").toString();
            course["cours"] = query.value("intitule").toString();
            course["credits"] = query.value("credits").toInt();
            course["statut"] = query.value("statut").toString();
            // Mock progression for now, could be calculated based on evaluated modules
            course["progression"] = 40 + (rand() % 40); 
            m_currentCourses.append(course);
        }
    }
}

void DashboardService::loadRecentPayments()
{
    m_recentPayments.clear();
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    QSqlQuery query(db);
    query.prepare("SELECT montant, date, mode, statut, reference "
                  "FROM payments "
                  "WHERE etudiant_id = :id "
                  "ORDER BY date DESC LIMIT 3");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap payment;
            payment["montant"] = query.value("montant").toDouble();
            payment["date"] = query.value("date").toString();
            payment["mode"] = query.value("mode").toString();
            payment["statut"] = query.value("statut").toString();
            payment["reference"] = query.value("reference").toString();
            m_recentPayments.append(payment);
        }
    }
}

void DashboardService::loadPerformanceHistory()
{
    m_performanceHistory.clear();
    // Simulate some history points to fill the chart based on current average
    if (m_averageGrade > 0) {
        for (int i = 1; i <= 5; ++i) {
            QVariantMap pt;
            pt["label"] = QString("Sem %1").arg(i);
            pt["value"] = m_averageGrade - 15 + (i * 3); // Just a progressive curve
            m_performanceHistory.append(pt);
        }
    }
}
