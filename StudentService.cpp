#include "StudentService.h"
#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>

StudentService::StudentService(AuthService *auth, QObject *parent)
    : QObject(parent), m_auth(auth)
{
    connect(m_auth, &AuthService::currentUserIdChanged, this, &StudentService::refreshData);
    
    // Temps réel pour les notes et données
    connect(&DatabaseManager::instance(), &DatabaseManager::databaseUpdated, this, [this](const QString &tableName) {
        if (m_auth->currentUserId() != -1) {
            if (tableName == "evaluations") {
                loadGrades();
                loadAcademicProgress();
            } else if (tableName == "presences") {
                loadAttendance();
                loadAcademicProgress();
            }
        }
    });
}

QVariantMap StudentService::profile() const
{
    return m_profile;
}

QVariantList StudentService::enrolledCourses() const
{
    return m_enrolledCourses;
}

QVariantList StudentService::availableCourses() const
{
    return m_availableCourses;
}

QVariantList StudentService::grades() const { return m_grades; }
QVariantList StudentService::schedule() const { return m_schedule; }
QVariantList StudentService::finances() const { return m_finances; }
QVariantList StudentService::attendance() const { return m_attendance; }
QVariantList StudentService::recentActivity() const { return m_recentActivity; }
QVariantList StudentService::profileDocuments() const { return m_profileDocuments; }
QVariantMap StudentService::academicProgress() const { return m_academicProgress; }
QVariantList StudentService::academicHistory() const { return m_academicHistory; }

void StudentService::refreshData()
{
    if (m_auth->currentUserId() == -1) {
        m_profile.clear();
        m_enrolledCourses.clear();
        m_availableCourses.clear();
        m_grades.clear();
        m_schedule.clear();
        m_finances.clear();
        m_attendance.clear();
        m_recentActivity.clear();
        m_profileDocuments.clear();
        m_academicProgress.clear();
        m_academicHistory.clear();
        emit profileChanged();
        emit enrolledCoursesChanged();
        emit availableCoursesChanged();
        emit gradesChanged();
        emit scheduleChanged();
        emit financesChanged();
        emit attendanceChanged();
        emit recentActivityChanged();
        emit profileDocumentsChanged();
        emit academicProgressChanged();
        emit academicHistoryChanged();
        return;
    }

    loadProfile();
    loadEnrolledCourses();
    loadAvailableCourses();
    loadGrades();
    loadSchedule();
    loadFinances();
    loadAttendance();
    loadRecentActivity();
    loadProfileDocuments();
    loadAcademicProgress();
    loadAcademicHistory();
}

void StudentService::loadProfile()
{
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT matricule, email, nom, prenom, filiere, niveau, statut, date_naissance, telephone, adresse, ville, photo_url "
                  "FROM users WHERE id = :id");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec() && query.next()) {
        m_profile["matricule"] = query.value("matricule").toString();
        m_profile["email"] = query.value("email").toString();
        m_profile["nom"] = query.value("nom").toString();
        m_profile["prenom"] = query.value("prenom").toString();
        m_profile["filiere"] = query.value("filiere").toString();
        m_profile["niveau"] = query.value("niveau").toString();
        m_profile["statut"] = query.value("statut").toString();
        m_profile["date_naissance"] = query.value("date_naissance").toString();
        m_profile["telephone"] = query.value("telephone").toString();
        m_profile["adresse"] = query.value("adresse").toString();
        m_profile["ville"] = query.value("ville").toString();
        m_profile["photo_url"] = query.value("photo_url").toString();
        
        // Mock data for missing fields
        m_profile["faculte"] = "Faculté des Sciences";
        m_profile["departement"] = "Informatique";
        m_profile["date_inscription"] = "15 septembre 2024";
        m_profile["date_admission"] = "10 septembre 2024";
        
        emit profileChanged();
    }
}

void StudentService::loadEnrolledCourses()
{
    m_enrolledCourses.clear();
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT c.id, c.code, c.intitule, c.credits, c.volume_horaire, e.annee_academique, e.statut "
                  "FROM enrollments e "
                  "JOIN courses c ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap course;
            course["id"] = query.value("id").toInt();
            course["code"] = query.value("code").toString();
            course["intitule"] = query.value("intitule").toString();
            course["credits"] = query.value("credits").toInt();
            course["volume_horaire"] = query.value("volume_horaire").toInt();
            course["annee_academique"] = query.value("annee_academique").toString();
            course["statut"] = query.value("statut").toString();
            m_enrolledCourses.append(course);
        }
        emit enrolledCoursesChanged();
    }
}

void StudentService::loadAvailableCourses()
{
    m_availableCourses.clear();
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    
    // Select courses where student is NOT enrolled
    query.prepare("SELECT c.id, c.code, c.intitule, c.credits, c.volume_horaire "
                  "FROM courses c "
                  "WHERE c.id NOT IN (SELECT cours_id FROM enrollments WHERE etudiant_id = :id)");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap course;
            course["id"] = query.value("id").toInt();
            course["code"] = query.value("code").toString();
            course["intitule"] = query.value("intitule").toString();
            course["credits"] = query.value("credits").toInt();
            course["volume_horaire"] = query.value("volume_horaire").toInt();
            m_availableCourses.append(course);
        }
        emit availableCoursesChanged();
    }
}

bool StudentService::enrollInCourse(int courseId)
{
    if (m_auth->currentUserId() == -1) return false;

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    
    // Vérifier si l'étudiant est déjà inscrit
    query.prepare("SELECT id FROM enrollments WHERE etudiant_id = :etudiant_id AND cours_id = :cours_id");
    query.bindValue(":etudiant_id", m_auth->currentUserId());
    query.bindValue(":cours_id", courseId);
    if (query.exec() && query.next()) {
        return false; // Déjà inscrit
    }

    query.prepare("INSERT INTO enrollments (etudiant_id, cours_id, annee_academique, statut) "
                  "VALUES (:etudiant_id, :cours_id, :annee, :statut)");
    query.bindValue(":etudiant_id", m_auth->currentUserId());
    query.bindValue(":cours_id", courseId);
    query.bindValue(":annee", "2024-2025");
    query.bindValue(":statut", "Inscrit");

    if (query.exec()) {
        refreshData(); // Reload both available and enrolled courses
        return true;
    }
    return false;
}

void StudentService::loadGrades()
{
    m_grades.clear();
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT c.intitule, c.credits, ev.type, ev.valeur, ev.coefficient, ev.date "
                  "FROM evaluations ev "
                  "JOIN enrollments e ON ev.inscription_id = e.id "
                  "JOIN courses c ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id AND ev.statut = 'Publié'");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap grade;
            grade["cours"] = query.value("intitule").toString();
            grade["credits"] = query.value("credits").toInt();
            grade["type"] = query.value("type").toString();
            grade["valeur"] = query.value("valeur").toDouble();
            grade["coefficient"] = query.value("coefficient").toDouble();
            grade["date"] = query.value("date").toString();
            m_grades.append(grade);
        }
        emit gradesChanged();
    }
}

void StudentService::loadSchedule()
{
    m_schedule.clear();
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT c.intitule, s.jour, s.heure_debut, s.heure_fin, r.nom AS salle, u.nom AS enseignant "
                  "FROM sessions s "
                  "JOIN courses c ON s.cours_id = c.id "
                  "JOIN rooms r ON s.salle_id = r.id "
                  "JOIN users u ON s.enseignant_id = u.id "
                  "JOIN enrollments e ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap session;
            session["cours"] = query.value("intitule").toString();
            session["jour"] = query.value("jour").toString();
            session["heure_debut"] = query.value("heure_debut").toString();
            session["heure_fin"] = query.value("heure_fin").toString();
            session["salle"] = query.value("salle").toString();
            session["enseignant"] = query.value("enseignant").toString();
            m_schedule.append(session);
        }
        emit scheduleChanged();
    }
}

void StudentService::loadFinances()
{
    m_finances.clear();
    m_financeSummary.clear();
    
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT montant, date, mode, statut, reference, description "
                  "FROM payments "
                  "WHERE etudiant_id = :id "
                  "ORDER BY date DESC");
    query.bindValue(":id", m_auth->currentUserId());

    double totalFrais = 0.0;
    double totalPaye = 0.0;
    double totalRestant = 0.0;

    if (query.exec()) {
        while (query.next()) {
            QVariantMap payment;
            double montant = query.value("montant").toDouble();
            QString statut = query.value("statut").toString();
            
            payment["montant"] = montant;
            payment["date"] = query.value("date").toString();
            payment["mode"] = query.value("mode").toString();
            payment["statut"] = statut;
            payment["reference"] = query.value("reference").toString();
            payment["description"] = query.value("description").toString();
            m_finances.append(payment);
            
            totalFrais += montant;
            if (statut == "Payé") {
                totalPaye += montant;
            } else {
                totalRestant += montant;
            }
        }
    }
    
    m_financeSummary["totalFrais"] = totalFrais;
    m_financeSummary["totalPaye"] = totalPaye;
    m_financeSummary["totalRestant"] = totalRestant;
    m_financeSummary["soldeActuel"] = totalRestant; // Balance = what's left to pay
    m_financeSummary["pourcentagePaye"] = (totalFrais > 0) ? qRound((totalPaye / totalFrais) * 100.0) : 0;
    m_financeSummary["prochainPaiement"] = "15 juin 2025";
    m_financeSummary["anneeAcademique"] = "2024-2025";
    
    emit financesChanged();
}

QVariantMap StudentService::financeSummary() const
{
    return m_financeSummary;
}

void StudentService::loadAttendance()
{
    m_attendance.clear();
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT c.intitule, p.date_seance, p.present "
                  "FROM presences p "
                  "JOIN enrollments e ON p.inscription_id = e.id "
                  "JOIN courses c ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap attendanceRec;
            attendanceRec["cours"] = query.value("intitule").toString();
            attendanceRec["date"] = query.value("date_seance").toString();
            attendanceRec["present"] = query.value("present").toInt();
            m_attendance.append(attendanceRec);
        }
        emit attendanceChanged();
    }
}

QVariantMap StudentService::updateProfile(const QVariantMap &data)
{
    QVariantMap result;
    if (m_auth->currentUserId() == -1) {
        result["success"] = false;
        result["message"] = "Non autorisé";
        return result;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("UPDATE users SET telephone = :tel, adresse = :addr, ville = :ville, email = :email WHERE id = :id");
    query.bindValue(":tel", data["telephone"].toString());
    query.bindValue(":addr", data["adresse"].toString());
    query.bindValue(":ville", data["ville"].toString());
    query.bindValue(":email", data["email"].toString());
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        result["success"] = true;
        result["message"] = "Profil mis à jour avec succès";
        loadProfile(); // Refresh locally
        
        QSqlQuery actQuery(DatabaseManager::instance().getDatabase());
        actQuery.prepare("INSERT INTO user_activities (user_id, action, date, details) VALUES (?, ?, datetime('now', 'localtime'), ?)");
        actQuery.addBindValue(m_auth->currentUserId());
        actQuery.addBindValue("Profil mis à jour");
        actQuery.addBindValue("Mise à jour des coordonnées personnelles");
        actQuery.exec();
        loadRecentActivity();
    } else {
        result["success"] = false;
        result["message"] = "Erreur de base de données";
    }
    return result;
}

QVariantMap StudentService::changePassword(const QString &oldPassword, const QString &newPassword)
{
    QVariantMap result;
    if (m_auth->currentUserId() == -1) {
        result["success"] = false;
        result["message"] = "Non autorisé";
        return result;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT password_hash FROM users WHERE id = :id");
    query.bindValue(":id", m_auth->currentUserId());
    
    if (query.exec() && query.next()) {
        QString currentHash = query.value(0).toString();
        if (currentHash != DatabaseManager::hashPassword(oldPassword)) {
            result["success"] = false;
            result["message"] = "L'ancien mot de passe est incorrect";
            return result;
        }
        
        QSqlQuery updateQuery(DatabaseManager::instance().getDatabase());
        updateQuery.prepare("UPDATE users SET password_hash = :hash WHERE id = :id");
        updateQuery.bindValue(":hash", DatabaseManager::hashPassword(newPassword));
        updateQuery.bindValue(":id", m_auth->currentUserId());
        
        if (updateQuery.exec()) {
            result["success"] = true;
            result["message"] = "Mot de passe modifié avec succès";
            
            QSqlQuery actQuery(DatabaseManager::instance().getDatabase());
            actQuery.prepare("INSERT INTO user_activities (user_id, action, date, details) VALUES (?, ?, datetime('now', 'localtime'), ?)");
            actQuery.addBindValue(m_auth->currentUserId());
            actQuery.addBindValue("Mot de passe modifié");
            actQuery.addBindValue("");
            actQuery.exec();
            loadRecentActivity();
        } else {
            result["success"] = false;
            result["message"] = "Erreur de base de données";
        }
    } else {
        result["success"] = false;
        result["message"] = "Utilisateur introuvable";
    }
    return result;
}

bool StudentService::updateProfilePhoto(const QString &filePath)
{
    if (m_auth->currentUserId() == -1) return false;
    
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("UPDATE users SET photo_url = :photo WHERE id = :id");
    query.bindValue(":photo", filePath);
    query.bindValue(":id", m_auth->currentUserId());
    
    if (query.exec()) {
        loadProfile();
        
        QSqlQuery actQuery(DatabaseManager::instance().getDatabase());
        actQuery.prepare("INSERT INTO user_activities (user_id, action, date, details) VALUES (?, ?, datetime('now', 'localtime'), ?)");
        actQuery.addBindValue(m_auth->currentUserId());
        actQuery.addBindValue("Photo de profil modifiée");
        actQuery.addBindValue("");
        actQuery.exec();
        loadRecentActivity();
        
        return true;
    }
    return false;
}

void StudentService::loadRecentActivity()
{
    m_recentActivity.clear();
    if (m_auth->currentUserId() == -1) return;
    
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT action, date, details FROM user_activities WHERE user_id = :id ORDER BY date DESC LIMIT 10");
    query.bindValue(":id", m_auth->currentUserId());
    
    if (query.exec()) {
        while (query.next()) {
            QVariantMap act;
            act["action"] = query.value("action").toString();
            act["date"] = query.value("date").toString();
            act["details"] = query.value("details").toString();
            m_recentActivity.append(act);
        }
        emit recentActivityChanged();
    }
}

void StudentService::loadProfileDocuments()
{
    m_profileDocuments.clear();
    if (m_auth->currentUserId() == -1) return;
    
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT nom, type, date_emission, chemin_fichier FROM documents WHERE etudiant_id = :id ORDER BY date_emission DESC");
    query.bindValue(":id", m_auth->currentUserId());
    
    if (query.exec()) {
        while (query.next()) {
            QVariantMap doc;
            doc["nom"] = query.value("nom").toString();
            doc["type"] = query.value("type").toString();
            doc["date"] = query.value("date_emission").toString();
            doc["chemin"] = query.value("chemin_fichier").toString();
            m_profileDocuments.append(doc);
        }
        emit profileDocumentsChanged();
    }
}

void StudentService::loadAcademicProgress()
{
    m_academicProgress.clear();
    if (m_auth->currentUserId() == -1) return;
    
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT SUM(c.credits) as total_credits, COUNT(c.id) as cours_valides "
                  "FROM enrollments e "
                  "JOIN courses c ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id AND e.statut = 'Validé'");
    query.bindValue(":id", m_auth->currentUserId());
    
    int creditsObtenus = 0;
    int coursValides = 0;
    if (query.exec() && query.next()) {
        creditsObtenus = query.value("total_credits").toInt();
        coursValides = query.value("cours_valides").toInt();
    }
    
    int creditsNecessaires = 120; // Exemple
    
    m_academicProgress["credits_obtenus"] = creditsObtenus;
    m_academicProgress["credits_necessaires"] = creditsNecessaires;
    m_academicProgress["cours_valides"] = coursValides;
    m_academicProgress["pourcentage"] = (creditsNecessaires > 0) ? (creditsObtenus * 100 / creditsNecessaires) : 0;
    
    // Moyenne
    QSqlQuery avgQuery(DatabaseManager::instance().getDatabase());
    avgQuery.prepare("SELECT AVG(valeur) FROM evaluations ev "
                     "JOIN enrollments e ON ev.inscription_id = e.id "
                     "WHERE e.etudiant_id = :id");
    avgQuery.bindValue(":id", m_auth->currentUserId());
    
    double average = 0.0;
    if (avgQuery.exec() && avgQuery.next()) {
        average = avgQuery.value(0).toDouble();
    }
    // Convert 0-100 score to 0-4.0 GPA scale mock
    double gpa = (average / 100.0) * 4.0;
    m_academicProgress["moyenne"] = average;
    m_academicProgress["gpa"] = gpa;
    
    // Assiduité (Attendance)
    QSqlQuery attQuery(DatabaseManager::instance().getDatabase());
    attQuery.prepare("SELECT SUM(p.present) as presences, COUNT(p.id) as total "
                     "FROM presences p "
                     "JOIN enrollments e ON p.inscription_id = e.id "
                     "WHERE e.etudiant_id = :id");
    attQuery.bindValue(":id", m_auth->currentUserId());
    
    int tauxAssiduite = 0;
    if (attQuery.exec() && attQuery.next()) {
        int total = attQuery.value("total").toInt();
        int presents = attQuery.value("presences").toInt();
        if (total > 0) {
            tauxAssiduite = (presents * 100) / total;
        }
    }
    m_academicProgress["taux_assiduite"] = tauxAssiduite;
    
    emit academicProgressChanged();
}

void StudentService::loadAcademicHistory()
{
    m_academicHistory.clear();
    if (m_auth->currentUserId() == -1) return;
    
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT e.annee_academique, COUNT(e.cours_id) as total_cours, "
                  "SUM(CASE WHEN e.statut = 'Validé' THEN 1 ELSE 0 END) as cours_valides, "
                  "c.filiere "
                  "FROM enrollments e "
                  "JOIN courses c ON e.cours_id = c.id "
                  "WHERE e.etudiant_id = :id "
                  "GROUP BY e.annee_academique, c.filiere "
                  "ORDER BY e.annee_academique DESC");
    query.bindValue(":id", m_auth->currentUserId());
    
    if (query.exec()) {
        while (query.next()) {
            QVariantMap yearData;
            yearData["annee"] = query.value("annee_academique").toString();
            yearData["filiere"] = query.value("filiere").toString();
            yearData["total_cours"] = query.value("total_cours").toInt();
            yearData["cours_valides"] = query.value("cours_valides").toInt();
            yearData["statut"] = (yearData["total_cours"].toInt() == yearData["cours_valides"].toInt() && yearData["total_cours"].toInt() > 0) ? "Terminée" : "En cours";
            m_academicHistory.append(yearData);
        }
        emit academicHistoryChanged();
    }
}
