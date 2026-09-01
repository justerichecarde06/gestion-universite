#include "AdminCourseService.h"
#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>

AdminCourseService::AdminCourseService(AuthService *authService, QObject *parent)
    : QObject(parent), m_authService(authService)
{
}

QVariantList AdminCourseService::getCourses(const QString &departmentFilter, const QString &statusFilter, const QString &searchQuery)
{
    QVariantList list;
    if (!m_authService || (m_authService->currentUserRole() != "admin" && m_authService->currentUserRole() != "superadmin" && m_authService->currentUserRole() != "secretary")) {
        return list;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    QString sql = "SELECT c.id, c.code, c.intitule, c.description, c.credits, c.capacite_max, c.statut, c.theme_color, c.filiere, "
                  "u.nom, u.prenom, u.email, "
                  "(SELECT COUNT(*) FROM enrollments e WHERE e.cours_id = c.id AND e.statut = 'Inscrit') as enrolled_count "
                  "FROM courses c "
                  "LEFT JOIN users u ON c.enseignant_id = u.id "
                  "WHERE 1=1";

    if (departmentFilter != "Tous" && !departmentFilter.isEmpty()) {
        sql += " AND c.filiere = '" + departmentFilter + "'";
    }
    if (statusFilter != "Tous" && !statusFilter.isEmpty()) {
        sql += " AND c.statut = '" + statusFilter + "'";
    }
    if (!searchQuery.isEmpty()) {
        sql += " AND (c.code LIKE '%" + searchQuery + "%' OR c.intitule LIKE '%" + searchQuery + "%' OR u.nom LIKE '%" + searchQuery + "%' OR u.prenom LIKE '%" + searchQuery + "%')";
    }
    
    sql += " ORDER BY c.id ASC";

    query.prepare(sql);
    if (query.exec()) {
        while (query.next()) {
            QVariantMap map;
            map["id"] = query.value(0).toInt();
            map["code"] = query.value(1).toString();
            map["title"] = query.value(2).toString();
            map["description"] = query.value(3).toString();
            map["credits"] = query.value(4).toInt();
            map["capacity"] = query.value(5).toInt();
            map["status"] = query.value(6).toString();
            map["themeColor"] = query.value(7).toString();
            map["filiere"] = query.value(8).toString();
            
            QString profName = query.value(10).toString() + " " + query.value(9).toString(); // prenom nom
            map["profName"] = profName.trimmed().isEmpty() ? "Non assigné" : "Dr. " + profName.trimmed();
            map["profEmail"] = query.value(11).toString();
            map["enrolled"] = query.value(12).toInt();
            list.append(map);
        }
    }
    return list;
}

QVariantMap AdminCourseService::getCourseStats()
{
    QVariantMap stats;
    stats["total"] = 0;
    stats["active"] = 0;
    stats["planned"] = 0;
    stats["inactive"] = 0;

    if (!m_authService || (m_authService->currentUserRole() != "admin" && m_authService->currentUserRole() != "superadmin" && m_authService->currentUserRole() != "secretary")) {
        return stats;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT statut, COUNT(*) FROM courses GROUP BY statut");
    
    if (query.exec()) {
        int total = 0;
        int active = 0;
        int planned = 0;
        int inactive = 0;
        
        while (query.next()) {
            QString statut = query.value(0).toString();
            int count = query.value(1).toInt();
            total += count;
            if (statut == "Actif") active += count;
            else if (statut == "Planifié") planned += count;
            else if (statut == "Inactif") inactive += count;
        }
        stats["total"] = total;
        stats["active"] = active;
        stats["planned"] = planned;
        stats["inactive"] = inactive;
    }
    return stats;
}

bool AdminCourseService::addCourse(const QVariantMap &courseData)
{
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("INSERT INTO courses (code, intitule, description, credits, capacite_max, statut, theme_color, filiere, enseignant_id) "
                  "VALUES (:code, :title, :description, :credits, :capacity, :status, :themeColor, :filiere, :profId)");
                  
    query.bindValue(":code", courseData["code"].toString());
    query.bindValue(":title", courseData["title"].toString());
    query.bindValue(":description", courseData["description"].toString());
    query.bindValue(":credits", courseData["credits"].toInt());
    query.bindValue(":capacity", courseData["capacity"].toInt());
    query.bindValue(":status", courseData["status"].toString());
    query.bindValue(":themeColor", courseData["themeColor"].toString());
    query.bindValue(":filiere", courseData["filiere"].toString());
    
    int profId = courseData["profId"].toInt();
    if (profId > 0) query.bindValue(":profId", profId);
    else query.bindValue(":profId", QVariant(QMetaType::fromType<int>())); // NULL

    if (query.exec()) {
        emit actionSuccess("Cours ajouté avec succès");
        emit coursesChanged();
        return true;
    }
    
    emit actionFailed("Erreur lors de l'ajout du cours: " + query.lastError().text());
    return false;
}

bool AdminCourseService::updateCourse(int courseId, const QVariantMap &courseData)
{
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("UPDATE courses SET code = :code, intitule = :title, description = :description, "
                  "credits = :credits, capacite_max = :capacity, statut = :status, "
                  "theme_color = :themeColor, filiere = :filiere, enseignant_id = :profId "
                  "WHERE id = :id");
                  
    query.bindValue(":code", courseData["code"].toString());
    query.bindValue(":title", courseData["title"].toString());
    query.bindValue(":description", courseData["description"].toString());
    query.bindValue(":credits", courseData["credits"].toInt());
    query.bindValue(":capacity", courseData["capacity"].toInt());
    query.bindValue(":status", courseData["status"].toString());
    query.bindValue(":themeColor", courseData["themeColor"].toString());
    query.bindValue(":filiere", courseData["filiere"].toString());
    query.bindValue(":id", courseId);
    
    int profId = courseData["profId"].toInt();
    if (profId > 0) query.bindValue(":profId", profId);
    else query.bindValue(":profId", QVariant(QMetaType::fromType<int>()));

    if (query.exec()) {
        emit actionSuccess("Cours mis à jour avec succès");
        emit coursesChanged();
        return true;
    }
    
    emit actionFailed("Erreur lors de la modification du cours");
    return false;
}

bool AdminCourseService::deleteCourse(int courseId)
{
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("DELETE FROM courses WHERE id = :id");
    query.bindValue(":id", courseId);
    if(query.exec()) {
        emit actionSuccess("Cours supprimé");
        emit coursesChanged();
        return true;
    }
    return false;
}
