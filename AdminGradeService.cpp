#include "AdminGradeService.h"
#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QDateTime>

AdminGradeService::AdminGradeService(AuthService *authService, QObject *parent) 
    : QObject(parent), m_authService(authService)
{
    loadFaculties();
}

QString AdminGradeService::getInitials(const QString &nom, const QString &prenom)
{
    QString init = "";
    if (!prenom.isEmpty()) init += prenom.at(0).toUpper();
    if (!nom.isEmpty()) init += nom.at(0).toUpper();
    return init;
}

void AdminGradeService::loadFaculties()
{
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.exec("SELECT DISTINCT filiere FROM courses WHERE filiere != ''");
    
    QVariantList newList;
    // Add an "All" or prompt option if needed, but for now just the actual faculties
    while (query.next()) {
        newList.append(query.value(0).toString());
    }
    
    m_faculties = newList;
    emit facultiesChanged();
}

void AdminGradeService::loadCourses(const QString &facultyName)
{
    if (!m_authService || !m_authService->hasPermission("courses.view")) {
        emit operationError("Accès refusé : Vous n'avez pas la permission de voir les cours.");
        return;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    QString sql = "SELECT id, code, intitule FROM courses";
    bool hasWhere = false;

    if (facultyName != "Toutes" && !facultyName.isEmpty()) {
        sql += " WHERE filiere = :filiere";
        hasWhere = true;
    }
    
    if (m_authService->currentUserRole() == "professor") {
        sql += hasWhere ? " AND enseignant_id = :prof_id" : " WHERE enseignant_id = :prof_id";
    }

    query.prepare(sql);
    if (facultyName != "Toutes" && !facultyName.isEmpty()) {
        query.bindValue(":filiere", facultyName);
    }
    if (m_authService->currentUserRole() == "professor") {
        query.bindValue(":prof_id", m_authService->currentUserId());
    }
    
    query.exec();
    
    QVariantList newList;
    while (query.next()) {
        QVariantMap course;
        course["id"] = query.value(0).toInt();
        course["code"] = query.value(1).toString();
        course["title"] = query.value(2).toString();
        course["displayName"] = QString("%1 - %2").arg(course["code"].toString(), course["title"].toString());
        newList.append(course);
    }
    
    m_courses = newList;
    emit coursesChanged();
}

void AdminGradeService::loadStudents(int courseId)
{
    if (!m_authService || !m_authService->hasPermission("grades.view")) {
        emit operationError("Accès refusé : Vous n'avez pas la permission de voir les notes.");
        return;
    }

    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    
    // Security check for professor
    if (m_authService->currentUserRole() == "professor") {
        QSqlQuery profCheck(db);
        profCheck.prepare("SELECT COUNT(*) FROM courses WHERE id = :cid AND enseignant_id = :pid");
        profCheck.bindValue(":cid", courseId);
        profCheck.bindValue(":pid", m_authService->currentUserId());
        if (profCheck.exec() && profCheck.next() && profCheck.value(0).toInt() == 0) {
            emit operationError("Accès refusé : Vous ne pouvez pas voir les notes d'un cours qui ne vous est pas assigné.");
            return;
        }
    }

    QSqlQuery query(db);
    
    query.prepare("SELECT e.id as enroll_id, u.id as user_id, u.nom, u.prenom, u.matricule "
                  "FROM enrollments e "
                  "JOIN users u ON e.etudiant_id = u.id "
                  "WHERE e.cours_id = ?");
    query.addBindValue(courseId);
    query.exec();
    
    QVariantList newList;
    
    while (query.next()) {
        int enrollId = query.value("enroll_id").toInt();
        int userId = query.value("user_id").toInt();
        QString nom = query.value("nom").toString();
        QString prenom = query.value("prenom").toString();
        QString matricule = query.value("matricule").toString();
        
        // Default grades
        double intra = -1;
        double finalGrade = -1;
        QString status = "Brouillon";
        QString datePub = "--";
        
        QSqlQuery gradeQuery(db);
        gradeQuery.prepare("SELECT type, valeur, statut, date FROM evaluations WHERE inscription_id = ?");
        gradeQuery.addBindValue(enrollId);
        gradeQuery.exec();
        
        bool hasGrades = false;
        while (gradeQuery.next()) {
            hasGrades = true;
            QString type = gradeQuery.value("type").toString();
            double val = gradeQuery.value("valeur").toDouble();
            QString s = gradeQuery.value("statut").toString();
            QString d = gradeQuery.value("date").toString();
            
            if (type == "Intra") intra = val;
            if (type == "Final") finalGrade = val;
            if (s == "Publié") {
                status = "Publié";
                if (d != "") datePub = d;
            }
        }
        
        if (!hasGrades) status = "Non Saisi";
        
        double avg = -1;
        if (intra >= 0 && finalGrade >= 0) avg = (intra + finalGrade) / 2.0;
        else if (intra >= 0) avg = intra;
        else if (finalGrade >= 0) avg = finalGrade;
        
        QVariantMap student;
        student["enrollmentId"] = enrollId;
        student["userId"] = userId;
        student["name"] = QString("%1 %2").arg(prenom, nom);
        student["initials"] = getInitials(nom, prenom);
        student["matricule"] = matricule;
        student["gradeIntra"] = intra >= 0 ? QString::number(intra, 'f', 1) : "--";
        student["gradeFinal"] = finalGrade >= 0 ? QString::number(finalGrade, 'f', 1) : "--";
        student["average"] = avg >= 0 ? QString::number(avg, 'f', 1) : "--";
        student["status"] = status;
        student["datePublication"] = datePub;
        
        newList.append(student);
    }
    
    m_studentsList = newList;
    emit studentsListChanged();
}

void AdminGradeService::saveGrade(int enrollmentId, double intraGrade, double finalGrade)
{
    if (!m_authService || (!m_authService->hasPermission("grades.create") && !m_authService->hasPermission("grades.update"))) {
        emit operationError("Accès refusé : Vous n'avez pas la permission de modifier les notes.");
        return;
    }

    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    
    auto insertOrUpdate = [&](const QString &type, double val) {
        if (val < 0) return; // Don't save negative values (empty)
        
        QSqlQuery check(db);
        check.prepare("SELECT id FROM evaluations WHERE inscription_id = ? AND type = ?");
        check.addBindValue(enrollmentId);
        check.addBindValue(type);
        check.exec();
        
        if (check.next()) {
            // Update
            QSqlQuery upd(db);
            upd.prepare("UPDATE evaluations SET valeur = ?, statut = 'Brouillon' WHERE id = ?");
            upd.addBindValue(val);
            upd.addBindValue(check.value(0).toInt());
            upd.exec();
        } else {
            // Insert
            QSqlQuery ins(db);
            ins.prepare("INSERT INTO evaluations (inscription_id, type, valeur, coefficient, date, statut) VALUES (?, ?, ?, ?, ?, 'Brouillon')");
            ins.addBindValue(enrollmentId);
            ins.addBindValue(type);
            ins.addBindValue(val);
            ins.addBindValue(0.5); // generic coefficient
            ins.addBindValue(QDateTime::currentDateTime().toString("yyyy-MM-dd"));
            ins.exec();
        }
    };
    
    insertOrUpdate("Intra", intraGrade);
    insertOrUpdate("Final", finalGrade);
    
    DatabaseManager::instance().notifyUpdate("evaluations");
    emit operationSuccess("Notes enregistrées en mode Brouillon.");
    
    // In real app, we might just reload the students to reflect changes
    // But since courseId isn't passed here, UI will need to re-call loadStudents
}

void AdminGradeService::publishGrades(int courseId)
{
    if (!m_authService || !m_authService->hasPermission("grades.validate")) {
        emit operationError("Accès refusé : Vous n'avez pas la permission de valider/publier les notes.");
        return;
    }

    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    db.transaction();
    
    // 1. Get all enrollments for this course
    QSqlQuery eq(db);
    eq.prepare("SELECT id, etudiant_id FROM enrollments WHERE cours_id = ?");
    eq.addBindValue(courseId);
    eq.exec();
    
    bool updated = false;
    
    while (eq.next()) {
        int enrollId = eq.value(0).toInt();
        int etudiantId = eq.value(1).toInt();
        
        // 2. Update their evaluations
        QSqlQuery uq(db);
        uq.prepare("UPDATE evaluations SET statut = 'Publié' WHERE inscription_id = ?");
        uq.addBindValue(enrollId);
        
        if (uq.exec() && uq.numRowsAffected() > 0) {
            updated = true;
            // 3. Create notification
            QSqlQuery nq(db);
            nq.prepare("INSERT INTO notifications (etudiant_id, titre, message, type, date, lu) VALUES (?, ?, ?, ?, ?, 0)");
            nq.addBindValue(etudiantId);
            nq.addBindValue("Notes publiées");
            nq.addBindValue("Vos notes pour un cours ont été publiées et sont maintenant disponibles sur votre portail.");
            nq.addBindValue("note");
            nq.addBindValue(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
            nq.exec();
        }
    }
    
    if (updated) {
        db.commit();
        DatabaseManager::instance().notifyUpdate("evaluations");
        DatabaseManager::instance().notifyUpdate("notifications");
        emit operationSuccess("Les notes ont été publiées avec succès et les étudiants ont été notifiés !");
        loadStudents(courseId); // refresh
    } else {
        db.rollback();
        emit operationError("Aucune note à publier pour ce cours.");
    }
}

QVariantMap AdminGradeService::getGradeStats(int courseId)
{
    QVariantMap stats;
    stats["totalStudents"] = 0;
    stats["publishedCount"] = 0;
    stats["publishedPercentage"] = 0.0;
    stats["average"] = "--";
    stats["maxGrade"] = "--";
    stats["maxStudent"] = "--";
    stats["minGrade"] = "--";
    stats["minStudent"] = "--";

    if (m_studentsList.isEmpty()) {
        return stats;
    }

    int total = m_studentsList.size();
    int published = 0;
    double sum = 0.0;
    int gradedCount = 0;
    
    double maxG = -1.0;
    QString maxName = "";
    double minG = 200.0;
    QString minName = "";

    for (const QVariant &v : m_studentsList) {
        QVariantMap map = v.toMap();
        if (map["status"].toString() == "Publié") {
            published++;
        }
        
        QString avgStr = map["average"].toString();
        if (avgStr != "--") {
            double avg = avgStr.toDouble();
            sum += avg;
            gradedCount++;
            
            if (avg > maxG) { maxG = avg; maxName = map["name"].toString(); }
            if (avg < minG) { minG = avg; minName = map["name"].toString(); }
        }
    }

    stats["totalStudents"] = total;
    stats["publishedCount"] = published;
    if (total > 0) {
        stats["publishedPercentage"] = (static_cast<double>(published) / total) * 100.0;
    }
    
    if (gradedCount > 0) {
        stats["average"] = QString::number(sum / gradedCount, 'f', 1);
        stats["maxGrade"] = QString::number(maxG, 'f', 1);
        stats["maxStudent"] = maxName;
        stats["minGrade"] = QString::number(minG, 'f', 1);
        stats["minStudent"] = minName;
    }

    return stats;
}
