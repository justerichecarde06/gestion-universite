#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QRandomGenerator>
#include <QDateTime>
#include <QVariantMap>

AuthService::AuthService(QObject *parent) 
    : QObject(parent), m_currentUserId(-1), m_currentUserRole("")
{
    // Ensure database is initialized
    DatabaseManager::instance();
}

int AuthService::currentUserId() const
{
    return m_currentUserId;
}

QString AuthService::currentUserRole() const
{
    return m_currentUserRole;
}

QStringList AuthService::currentUserPermissions() const
{
    return m_currentUserPermissions;
}

bool AuthService::hasPermission(const QString &permission) const
{
    if (m_currentUserRole == "superadmin") return true;
    return m_currentUserPermissions.contains(permission);
}

void AuthService::logout()
{
    if (m_currentUserId != -1) {
        DatabaseManager::logActivity(m_currentUserId, "Déconnexion");
    }
    m_currentUserId = -1;
    m_currentUserRole = "";
    m_currentUserPermissions.clear();
    emit currentUserIdChanged();
    emit currentUserRoleChanged();
    emit currentUserPermissionsChanged();
}

bool AuthService::login(const QString &identifier, const QString &password)
{
    if (identifier.isEmpty() || password.isEmpty()) {
        emit loginFailed("Les identifiants ne peuvent pas être vides.");
        return false;
    }

    QString hashedPassword = DatabaseManager::hashPassword(password);
    
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT id, role, nom, prenom, statut, rejection_reason FROM users WHERE (email = :id OR matricule = :id) AND password_hash = :hash");
    query.bindValue(":id", identifier);
    query.bindValue(":hash", hashedPassword);

    if (query.exec() && query.next()) {
        QString statut = query.value(4).toString();
        
        if (statut == "PENDING") {
            emit loginFailed("Votre compte est actuellement en attente de validation par l'administration.");
            return false;
        } else if (statut == "REJECTED") {
            QString reason = query.value(5).toString();
            QString msg = "Votre demande d'inscription n'a pas été approuvée.";
            if (!reason.isEmpty()) msg += "\nMotif : " + reason;
            emit loginFailed(msg);
            return false;
        } else if (statut == "SUSPENDED") {
            emit loginFailed("Votre compte est temporairement suspendu. Veuillez contacter l'administration.");
            return false;
        } else if (statut != "APPROVED" && statut != "Actif") {
            // "Actif" est l'ancien statut, "APPROVED" est le nouveau. On accepte les deux pour la rétrocompatibilité.
            emit loginFailed("Statut du compte invalide.");
            return false;
        }

        m_currentUserId = query.value(0).toInt();
        m_currentUserRole = query.value(1).toString();
        
        QString nom = query.value(2).toString();
        QString prenom = query.value(3).toString();
        QString fullName = prenom + " " + nom;
        if (prenom.isEmpty()) fullName = nom;
        
        // Fetch permissions for the role
        m_currentUserPermissions.clear();
        QSqlQuery permQuery(DatabaseManager::instance().getDatabase());
        permQuery.prepare("SELECT permission_name FROM role_permissions WHERE role_name = :role");
        permQuery.bindValue(":role", m_currentUserRole);
        if (permQuery.exec()) {
            while (permQuery.next()) {
                m_currentUserPermissions.append(permQuery.value(0).toString());
            }
        }
        
        emit currentUserIdChanged();
        emit currentUserRoleChanged();
        emit currentUserPermissionsChanged();
        
        DatabaseManager::logActivity(m_currentUserId, "Connexion");
        
        emit loginSuccess(m_currentUserRole, fullName);
        return true;
    } else {
        emit loginFailed("Identifiant ou mot de passe incorrect.");
        return false;
    }
}

bool AuthService::registerStudent(const QString &email, const QString &password, const QString &nom, const QString &prenom, const QString &phone, const QString &faculte, const QString &filiere, const QString &niveau)
{
    if (email.isEmpty() || password.isEmpty() || nom.isEmpty() || prenom.isEmpty()) {
        emit registerFailed("Les champs obligatoires doivent être remplis.");
        return false;
    }

    QSqlQuery checkQuery(DatabaseManager::instance().getDatabase());
    checkQuery.prepare("SELECT COUNT(*) FROM users WHERE email = :email");
    checkQuery.bindValue(":email", email);
    if (checkQuery.exec() && checkQuery.next()) {
        if (checkQuery.value(0).toInt() > 0) {
            emit registerFailed("Un compte existe déjà avec cet email.");
            return false;
        }
    }

    QString hashedPassword = DatabaseManager::hashPassword(password);
    
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("INSERT INTO users (email, password_hash, nom, prenom, telephone, filiere, niveau, role, statut) "
                  "VALUES (:email, :password_hash, :nom, :prenom, :telephone, :filiere, :niveau, :role, :statut)");
    
    query.bindValue(":email", email);
    query.bindValue(":password_hash", hashedPassword);
    query.bindValue(":nom", nom);
    query.bindValue(":prenom", prenom);
    query.bindValue(":telephone", phone);
    query.bindValue(":filiere", filiere);
    query.bindValue(":niveau", niveau);
    query.bindValue(":role", "student");
    query.bindValue(":statut", "PENDING"); // New status logic

    if (query.exec()) {
        emit registerSuccess();
        return true;
    } else {
        emit registerFailed("Erreur lors de la création du compte.");
        return false;
    }
}

bool AuthService::invitePersonnel(const QString &email, const QString &nom, const QString &prenom, const QString &role)
{
    if (!hasPermission("users.create")) {
        emit invitationFailed("Vous n'avez pas la permission de créer des utilisateurs.");
        return false;
    }

    if (email.isEmpty() || nom.isEmpty() || prenom.isEmpty() || role.isEmpty()) {
        emit invitationFailed("Tous les champs sont obligatoires.");
        return false;
    }

    QSqlQuery checkQuery(DatabaseManager::instance().getDatabase());
    checkQuery.prepare("SELECT COUNT(*) FROM users WHERE email = :email");
    checkQuery.bindValue(":email", email);
    if (checkQuery.exec() && checkQuery.next()) {
        if (checkQuery.value(0).toInt() > 0) {
            emit invitationFailed("Un compte existe déjà avec cet email.");
            return false;
        }
    }

    int randomToken = QRandomGenerator::global()->bounded(100000, 999999);
    QString tokenStr = QString::number(randomToken);

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("INSERT INTO users (email, nom, prenom, role, statut, reset_token_hash) "
                  "VALUES (:email, :nom, :prenom, :role, :statut, :token)");
    
    query.bindValue(":email", email);
    query.bindValue(":nom", nom);
    query.bindValue(":prenom", prenom);
    query.bindValue(":role", role);
    query.bindValue(":statut", "PENDING_INVITE");
    query.bindValue(":token", tokenStr);

    if (query.exec()) {
        DatabaseManager::logActivity(m_currentUserId, "Invitation", "Utilisateur invité : " + email + " (" + role + ")");
        emit invitationSuccess("Invitation envoyée avec succès à " + email + ".\n(Code d'activation démo : " + tokenStr + ")");
        return true;
    } else {
        emit invitationFailed("Erreur lors de la création de l'invitation.");
        return false;
    }
}

bool AuthService::requestPasswordReset(const QString &email)
{
    if (email.isEmpty()) {
        emit passwordResetFailed("Veuillez saisir votre adresse e-mail.");
        return false;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT id FROM users WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        int userId = query.value(0).toInt();
        // Generate a 6-digit token for demonstration purposes
        int randomToken = QRandomGenerator::global()->bounded(100000, 999999);
        QString tokenStr = QString::number(randomToken);
        
        QSqlQuery updateQuery(DatabaseManager::instance().getDatabase());
        updateQuery.prepare("UPDATE users SET reset_token_hash = :token WHERE id = :id");
        updateQuery.bindValue(":token", tokenStr); // In a real app, hash this token
        updateQuery.bindValue(":id", userId);
        updateQuery.exec();
        
        // Simulating email sending by emitting the token in the message for demo purposes
        emit passwordResetRequested("Un e-mail de réinitialisation a été envoyé.\n(Pour la démo, votre code est : " + tokenStr + ")");
        return true;
    } else {
        // Do not reveal that email doesn't exist to prevent enumeration
        emit passwordResetRequested("Si un compte correspond à cette adresse, un e-mail de réinitialisation sera envoyé.");
        return true;
    }
}

bool AuthService::resetPassword(const QString &token, const QString &newPassword)
{
    if (token.isEmpty() || newPassword.isEmpty()) {
        emit passwordResetError("Le token ou le nouveau mot de passe est manquant.");
        return false;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT id FROM users WHERE reset_token_hash = :token");
    query.bindValue(":token", token);

    if (query.exec() && query.next()) {
        int userId = query.value(0).toInt();
        QString hashedPassword = DatabaseManager::hashPassword(newPassword);

        QSqlQuery updateQuery(DatabaseManager::instance().getDatabase());
        updateQuery.prepare("UPDATE users SET password_hash = :hash, reset_token_hash = NULL WHERE id = :id");
        updateQuery.bindValue(":hash", hashedPassword);
        updateQuery.bindValue(":id", userId);

        if (updateQuery.exec()) {
            emit passwordResetSuccess();
            return true;
        } else {
            emit passwordResetError("Erreur lors de la mise à jour du mot de passe.");
            return false;
        }
    } else {
        emit passwordResetError("Ce lien ou code de réinitialisation est invalide ou a expiré.");
        return false;
    }
}

QVariantList AuthService::getAllUsers(const QString &searchQuery)
{
    QVariantList list;
    if (!hasPermission("users.view")) {
        return list;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    QString sql = "SELECT id, nom, prenom, email, role, statut, matricule FROM users WHERE statut IN ('Actif', 'APPROVED', 'Inactif', 'SUSPENDED')";
    
    if (!searchQuery.isEmpty()) {
        sql += " AND (nom LIKE :search OR prenom LIKE :search OR email LIKE :search OR matricule LIKE :search)";
    }
    sql += " ORDER BY nom ASC, prenom ASC";

    query.prepare(sql);
    if (!searchQuery.isEmpty()) {
        query.bindValue(":search", "%" + searchQuery + "%");
    }

    if (query.exec()) {
        while (query.next()) {
            QVariantMap map;
            map["id"] = query.value(0).toInt();
            
            QString nom = query.value(1).toString();
            QString prenom = query.value(2).toString();
            map["name"] = prenom + " " + nom;
            
            QString first = prenom.isEmpty() ? "" : prenom.left(1).toUpper();
            QString last = nom.isEmpty() ? "" : nom.left(1).toUpper();
            map["initials"] = first + last;
            
            map["email"] = query.value(3).toString();
            
            QString dbRole = query.value(4).toString();
            QString displayRole = "Utilisateur";
            if (dbRole == "student") displayRole = "Étudiant";
            else if (dbRole == "professor") displayRole = "Professeur";
            else if (dbRole == "admin" || dbRole == "superadmin") displayRole = "Administrateur";
            else if (dbRole == "secretary") displayRole = "Secrétaire";
            else if (dbRole == "accountant") displayRole = "Comptable";
            map["role"] = displayRole;
            
            QString statut = query.value(5).toString();
            if (statut == "APPROVED") statut = "Actif";
            map["status"] = statut;
            
            map["matricule"] = query.value(6).toString();
            
            list.append(map);
        }
    }
    return list;
}

QVariantList AuthService::getRegistrationRequests(const QString &statusFilter)
{
    QVariantList list;
    if (m_currentUserRole != "admin" && m_currentUserRole != "superadmin" && m_currentUserRole != "secretary") {
        return list; // Unauthorized (secretary is allowed to view and approve)
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    QString sql = "SELECT id, nom, prenom, email, telephone, '' AS faculte, filiere, niveau, statut, date_creation "
                  "FROM users WHERE role = 'student'";
    
    if (statusFilter != "Toutes" && !statusFilter.isEmpty()) {
        QString dbStatus;
        if (statusFilter == "En attente") dbStatus = "PENDING";
        else if (statusFilter == "Approuvées") dbStatus = "APPROVED";
        else if (statusFilter == "Refusées") dbStatus = "REJECTED";
        else if (statusFilter == "Suspendues") dbStatus = "SUSPENDED";
        else dbStatus = statusFilter;
        
        sql += " AND statut = '" + dbStatus + "'";
    }
    sql += " ORDER BY id DESC";

    query.prepare(sql);
    if (query.exec()) {
        while (query.next()) {
            QVariantMap map;
            map["id"] = query.value(0).toInt();
            map["nom"] = query.value(1).toString();
            map["prenom"] = query.value(2).toString();
            map["email"] = query.value(3).toString();
            map["telephone"] = query.value(4).toString();
            map["filiere"] = query.value(6).toString();
            map["niveau"] = query.value(7).toString();
            map["statut"] = query.value(8).toString();
            map["date_creation"] = query.value(9).toString();
            list.append(map);
        }
    }
    return list;
}

QVariantMap AuthService::getRegistrationStats()
{
    QVariantMap stats;
    stats["total"] = 0;
    stats["pending"] = 0;
    stats["approved"] = 0;
    stats["rejected"] = 0;

    if (m_currentUserRole != "admin" && m_currentUserRole != "superadmin" && m_currentUserRole != "secretary") {
        return stats;
    }

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT statut, COUNT(*) FROM users WHERE role = 'student' GROUP BY statut");
    
    if (query.exec()) {
        int total = 0;
        int pending = 0;
        int approved = 0;
        int rejected = 0;
        
        while (query.next()) {
            QString statut = query.value(0).toString();
            int count = query.value(1).toInt();
            
            total += count;
            if (statut == "PENDING") pending += count;
            else if (statut == "APPROVED" || statut == "Actif") approved += count;
            else if (statut == "REJECTED") rejected += count;
        }
        
        stats["total"] = total;
        stats["pending"] = pending;
        stats["approved"] = approved;
        stats["rejected"] = rejected;
    }
    return stats;
}

bool AuthService::approveRegistration(int userId)
{
    if (m_currentUserRole != "admin" && m_currentUserRole != "superadmin" && m_currentUserRole != "secretary") return false;

    // Generate matricule
    QDateTime now = QDateTime::currentDateTime();
    QString year = now.toString("yyyy");
    QString matricule = QString("ETU-%1-%2").arg(year).arg(userId, 4, 10, QChar('0'));

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("UPDATE users SET statut = 'APPROVED', matricule = :matricule WHERE id = :id");
    query.bindValue(":matricule", matricule);
    query.bindValue(":id", userId);

    if (query.exec()) {
        emit adminActionSuccess("Le compte a été approuvé avec succès. Matricule attribué : " + matricule);
        emit registrationRequestsChanged();
        return true;
    } else {
        emit adminActionFailed("Erreur lors de l'approbation du compte.");
        return false;
    }
}

bool AuthService::rejectRegistration(int userId, const QString &reason)
{
    if (m_currentUserRole != "admin" && m_currentUserRole != "superadmin" && m_currentUserRole != "secretary") return false;

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("UPDATE users SET statut = 'REJECTED', rejection_reason = :reason WHERE id = :id");
    query.bindValue(":reason", reason);
    query.bindValue(":id", userId);

    if (query.exec()) {
        emit adminActionSuccess("Le compte a été refusé.");
        emit registrationRequestsChanged();
        return true;
    } else {
        emit adminActionFailed("Erreur lors du refus du compte.");
        return false;
    }
}

bool AuthService::suspendAccount(int userId)
{
    if (m_currentUserRole != "admin" && m_currentUserRole != "superadmin" && m_currentUserRole != "secretary") return false;

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("UPDATE users SET statut = 'SUSPENDED' WHERE id = :id");
    query.bindValue(":id", userId);

    if (query.exec()) {
        emit adminActionSuccess("Le compte a été suspendu.");
        emit registrationRequestsChanged();
        return true;
    } else {
        emit adminActionFailed("Erreur lors de la suspension du compte.");
        return false;
    }
}
