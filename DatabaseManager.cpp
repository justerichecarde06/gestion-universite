#include "DatabaseManager.h"

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent)
{
    initDatabase();
}

DatabaseManager::~DatabaseManager()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

void DatabaseManager::initDatabase()
{
    QString dbPath = QCoreApplication::applicationDirPath() + "/database";
    QDir dir(dbPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    
    QString dbFile = dbPath + "/usfah_v4.db"; // Changed to v4 for evaluations schema update
    
    m_db = QSqlDatabase::addDatabase("QSQLITE", "MainConnection");
    m_db.setDatabaseName(dbFile);

    if (!m_db.open()) {
        qWarning() << "Error opening database:" << m_db.lastError().text();
        return;
    }

    createTables();
    populateDummyData();
}

void DatabaseManager::createTables()
{
    QSqlQuery query(m_db);
    
    // 1. Users / Students
    query.exec("CREATE TABLE IF NOT EXISTS users ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "matricule TEXT UNIQUE, "
               "email TEXT UNIQUE, "
               "password_hash TEXT, "
               "nom TEXT, "
               "prenom TEXT, "
               "role TEXT, "
               "filiere TEXT, "
               "niveau TEXT, "
               "statut TEXT, "
               "date_naissance TEXT, "
               "telephone TEXT, "
               "adresse TEXT, "
               "ville TEXT, "
               "photo_url TEXT, "
               "rejection_reason TEXT, "
               "reset_token_hash TEXT, "
               "reset_token_expires_at TEXT, "
               "date_creation TEXT DEFAULT CURRENT_TIMESTAMP)");

    // Try to add date_creation to existing databases (will silently fail if it already exists)
    query.exec("ALTER TABLE users ADD COLUMN date_creation TEXT");

    // 2. Courses
    query.exec("CREATE TABLE IF NOT EXISTS courses ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "code TEXT UNIQUE, "
               "intitule TEXT, "
               "description TEXT, "
               "credits INTEGER, "
               "volume_horaire INTEGER, "
               "capacite_max INTEGER DEFAULT 50, "
               "statut TEXT DEFAULT 'Actif', "
               "theme_color TEXT, "
               "enseignant_id INTEGER, "
               "filiere TEXT)");

    // Add new columns to existing courses table (will silently fail if they already exist)
    query.exec("ALTER TABLE courses ADD COLUMN description TEXT");
    query.exec("ALTER TABLE courses ADD COLUMN capacite_max INTEGER DEFAULT 50");
    query.exec("ALTER TABLE courses ADD COLUMN statut TEXT DEFAULT 'Actif'");
    query.exec("ALTER TABLE courses ADD COLUMN theme_color TEXT");

    // 3. Enrollments (Inscriptions)
    query.exec("CREATE TABLE IF NOT EXISTS enrollments ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "etudiant_id INTEGER, "
               "cours_id INTEGER, "
               "annee_academique TEXT, "
               "statut TEXT)"); // Inscrit, Validé, Échoué

    // 4. Evaluations (Notes)
    query.exec("CREATE TABLE IF NOT EXISTS evaluations ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "inscription_id INTEGER, "
               "type TEXT, " // Intra, Final
               "valeur REAL, "
               "coefficient REAL, "
               "date TEXT, "
               "statut TEXT DEFAULT 'Brouillon')");

    // 5. Payments (Paiements)
    query.exec("CREATE TABLE IF NOT EXISTS payments ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "etudiant_id INTEGER, "
               "montant REAL, "
               "date TEXT, "
               "mode TEXT, "
               "statut TEXT, "
               "reference TEXT, "
               "description TEXT DEFAULT '')");
    
    // Add description column to existing databases
    query.exec("ALTER TABLE payments ADD COLUMN description TEXT DEFAULT ''");

    // 6. Rooms (Salles)
    query.exec("CREATE TABLE IF NOT EXISTS rooms ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "nom TEXT, "
               "capacite INTEGER, "
               "batiment TEXT)");

    // 7. Sessions (Séances)
    query.exec("CREATE TABLE IF NOT EXISTS sessions ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "cours_id INTEGER, "
               "salle_id INTEGER, "
               "enseignant_id INTEGER, "
               "jour TEXT, "
               "heure_debut TEXT, "
               "heure_fin TEXT)");
               
    // 8. Presences
    query.exec("CREATE TABLE IF NOT EXISTS presences ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "inscription_id INTEGER, "
               "date_seance TEXT, "
               "present INTEGER)"); // 1=Oui, 0=Non
               
    // 9. Notifications
    query.exec("CREATE TABLE IF NOT EXISTS notifications ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "etudiant_id INTEGER, "
               "titre TEXT, "
               "message TEXT, "
               "type TEXT, "
               "date TEXT, "
               "lu INTEGER DEFAULT 0)"); // 0=Non lu, 1=Lu
               
    // 10. Documents
    query.exec("CREATE TABLE IF NOT EXISTS documents ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "etudiant_id INTEGER, "
               "nom TEXT, "
               "type TEXT, "
               "date_emission TEXT, "
               "chemin_fichier TEXT)");

    // 11. User Activities
    query.exec("CREATE TABLE IF NOT EXISTS user_activities ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "user_id INTEGER, "
               "action TEXT, "
               "date TEXT, "
               "details TEXT)");

    // 12. Roles & Permissions (RBAC)
    query.exec("CREATE TABLE IF NOT EXISTS roles ("
               "name TEXT PRIMARY KEY, "
               "description TEXT)");
               
    query.exec("CREATE TABLE IF NOT EXISTS permissions ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "name TEXT UNIQUE, "
               "module TEXT, "
               "description TEXT)");
               
    query.exec("CREATE TABLE IF NOT EXISTS role_permissions ("
               "role_name TEXT, "
               "permission_name TEXT, "
               "PRIMARY KEY (role_name, permission_name))");
               
    // 13. Transactions
    query.exec("CREATE TABLE IF NOT EXISTS transactions ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "date TEXT, "
               "description TEXT, "
               "categorie TEXT, "
               "type TEXT, "
               "montant REAL, "
               "statut TEXT, "
               "user_id INTEGER)");

    // 14. Settings
    query.exec("CREATE TABLE IF NOT EXISTS settings ("
               "key TEXT PRIMARY KEY, "
               "value TEXT)");
}

void DatabaseManager::populateDummyData()
{
    QSqlQuery query(m_db);
    query.exec("SELECT COUNT(*) FROM users");
    if (query.next() && query.value(0).toInt() > 0) {
        return; // Already populated
    }

    qDebug() << "Populating database with realistic dummy data...";

    // --- RBAC: Roles ---
    query.exec("INSERT INTO roles (name, description) VALUES "
               "('superadmin', 'Administrateur système complet'),"
               "('secretary', 'Administration académique et inscriptions'),"
               "('accountant', 'Gestion financière'),"
               "('professor', 'Enseignant - gestion des notes'),"
               "('student', 'Étudiant')");

    // --- RBAC: Permissions ---
    QStringList perms = {
        "dashboard.view", "users.view", "users.create", "users.update", "users.delete",
        "students.view", "students.create", "students.update", 
        "registrations.view", "registrations.approve", "registrations.reject",
        "courses.view", "courses.create", "courses.update", "courses.delete",
        "grades.view", "grades.create", "grades.update", "grades.validate",
        "finance.view", "finance.create", "finance.update",
        "payments.view", "payments.create", "payments.update",
        "documents.view", "documents.create", "documents.download",
        "schedule.view", "schedule.create", "schedule.update",
        "attendance.view", "attendance.create", "attendance.update",
        "reports.view", "settings.view", "settings.update",
        "roles.view", "roles.create", "roles.update", "roles.delete",
        "audit_logs.view"
    };

    query.prepare("INSERT INTO permissions (name, module) VALUES (?, ?)");
    for (const QString& p : perms) {
        query.addBindValue(p);
        query.addBindValue(p.split(".").first());
        query.exec();
    }

    // --- RBAC: Role Permissions ---
    auto assignPerms = [&](const QString& role, const QStringList& pList) {
        QSqlQuery q(m_db);
        q.prepare("INSERT INTO role_permissions (role_name, permission_name) VALUES (?, ?)");
        for (const QString& p : pList) {
            q.addBindValue(role); q.addBindValue(p); q.exec();
        }
    };
    
    // Super Admin gets all
    assignPerms("superadmin", perms);
    // Secretary
    assignPerms("secretary", {"dashboard.view", "students.view", "students.create", "students.update", "registrations.view", "registrations.approve", "registrations.reject", "courses.view", "documents.view", "documents.create", "documents.download", "schedule.view"});
    // Accountant
    assignPerms("accountant", {"dashboard.view", "finance.view", "finance.create", "finance.update", "payments.view", "payments.create", "payments.update", "reports.view"});
    // Professor
    assignPerms("professor", {"dashboard.view", "courses.view", "students.view", "grades.view", "grades.create", "grades.update", "schedule.view", "attendance.view", "attendance.create", "attendance.update"});
    // Student
    assignPerms("student", {"dashboard.view", "courses.view", "grades.view", "schedule.view", "finance.view", "documents.view", "documents.download"});

    // --- USERS ---
    query.prepare("INSERT INTO users (matricule, email, password_hash, nom, prenom, role, filiere, niveau, statut, date_naissance, telephone, adresse, ville, photo_url, date_creation) "
                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                  
    auto insertUser = [&](const QString& mat, const QString& email, const QString& pwd, const QString& nom, const QString& prenom, const QString& role, const QString& filiere = "", const QString& niveau = "", const QString& statut = "Actif") {
        query.addBindValue(mat); query.addBindValue(email); query.addBindValue(hashPassword(pwd));
        query.addBindValue(nom); query.addBindValue(prenom); query.addBindValue(role);
        query.addBindValue(filiere); query.addBindValue(niveau); query.addBindValue(statut); query.addBindValue("1990-01-01");
        query.addBindValue("+509 0000 0000"); query.addBindValue("Port-au-Prince"); query.addBindValue("Port-au-Prince"); query.addBindValue("");
        
        // Randomize date_creation for realistic dummy data
        QDateTime baseDate = QDateTime::currentDateTime().addDays(- (rand() % 30));
        query.addBindValue(baseDate.toString("yyyy-MM-dd HH:mm:ss"));
        
        query.exec();
        return query.lastInsertId().toInt();
    };

    // 1. Super Admin
    insertUser("admin-001", "admin@universite.com", "AdminPass!2026", "Directeur", "Super", "superadmin");
    
    // 2. Secrétaire
    insertUser("sec-001", "secretaire@universite.com", "Secretariat#2026", "Durand", "Marie", "secretary");
    
    // 3. Comptable
    insertUser("comp-001", "comptable@universite.com", "Finance$2026", "Pierre", "Paul", "accountant");
    
    // 4. Professeur
    int profId = insertUser("prof-001", "professeur@universite.com", "Professeur@2026", "Chery", "Jean", "professor");
    
    // 5. Étudiant
    int studentId = insertUser("2026-etu-001", "student@universite.com", "Student*2026", "Louis", "Marc", "student", "Génie Logiciel", "Licence 3");


    // --- COURSES ---
    query.prepare("INSERT INTO courses (code, intitule, description, credits, volume_horaire, capacite_max, statut, theme_color, enseignant_id, filiere) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    
    query.addBindValue("CS-101"); query.addBindValue("Programmation Web"); query.addBindValue("Introduction au développement web"); query.addBindValue(4); query.addBindValue(45); query.addBindValue(50); query.addBindValue("Actif"); query.addBindValue("#00B4B1"); query.addBindValue(profId); query.addBindValue("Génie Logiciel"); query.exec();
    int cours1 = query.lastInsertId().toInt();
    
    query.addBindValue("DB-205"); query.addBindValue("Base de Données Avancées"); query.addBindValue("Conception et gestion avancée"); query.addBindValue(3); query.addBindValue(60); query.addBindValue(45); query.addBindValue("Actif"); query.addBindValue("#805AD5"); query.addBindValue(profId); query.addBindValue("Génie Logiciel"); query.exec();
    int cours2 = query.lastInsertId().toInt();
    
    query.addBindValue("NT-301"); query.addBindValue("Réseaux Informatiques"); query.addBindValue("Architecture et protocoles réseaux"); query.addBindValue(4); query.addBindValue(30); query.addBindValue(40); query.addBindValue("Actif"); query.addBindValue("#EF6C00"); query.addBindValue(profId); query.addBindValue("Génie Logiciel"); query.exec();
    int cours3 = query.lastInsertId().toInt();
    
    query.addBindValue("AI-402"); query.addBindValue("Intelligence Artificielle"); query.addBindValue("ML et Deep Learning"); query.addBindValue(5); query.addBindValue(45); query.addBindValue(35); query.addBindValue("Planifié"); query.addBindValue("#38A169"); query.addBindValue(profId); query.addBindValue("Génie Logiciel"); query.exec();
    int cours4 = query.lastInsertId().toInt();
    
    query.addBindValue("MA-105"); query.addBindValue("Mathématiques Avancées"); query.addBindValue("Algèbre linéaire et équations"); query.addBindValue(3); query.addBindValue(60); query.addBindValue(50); query.addBindValue("Actif"); query.addBindValue("#003A69"); query.addBindValue(profId); query.addBindValue("Mathématiques"); query.exec();
    
    query.addBindValue("SE-305"); query.addBindValue("Génie Logiciel"); query.addBindValue("Cycle de vie et méthodologies"); query.addBindValue(4); query.addBindValue(45); query.addBindValue(40); query.addBindValue("Actif"); query.addBindValue("#D69E2E"); query.addBindValue(profId); query.addBindValue("Génie Logiciel"); query.exec();

    // --- ENROLLMENTS ---
    query.prepare("INSERT INTO enrollments (etudiant_id, cours_id, annee_academique, statut) VALUES (?, ?, ?, ?)");
    query.addBindValue(studentId); query.addBindValue(cours1); query.addBindValue("2023-2024"); query.addBindValue("Inscrit"); query.exec();
    int enroll1 = query.lastInsertId().toInt();
    
    query.addBindValue(studentId); query.addBindValue(cours2); query.addBindValue("2023-2024"); query.addBindValue("Inscrit"); query.exec();
    int enroll2 = query.lastInsertId().toInt();
    
    query.addBindValue(studentId); query.addBindValue(cours3); query.addBindValue("2023-2024"); query.addBindValue("Validé"); query.exec();
    int enroll3 = query.lastInsertId().toInt();

    // --- EVALUATIONS ---
    query.prepare("INSERT INTO evaluations (inscription_id, type, valeur, coefficient, date, statut) VALUES (?, ?, ?, ?, ?, ?)");
    query.addBindValue(enroll1); query.addBindValue("Intra"); query.addBindValue(85.0); query.addBindValue(0.4); query.addBindValue("2023-11-15"); query.addBindValue("Publié"); query.exec();
    query.addBindValue(enroll1); query.addBindValue("Final"); query.addBindValue(92.0); query.addBindValue(0.6); query.addBindValue("2023-12-20"); query.addBindValue("Brouillon"); query.exec();
    
    query.addBindValue(enroll2); query.addBindValue("Intra"); query.addBindValue(78.0); query.addBindValue(0.4); query.addBindValue("2023-12-10"); query.addBindValue("Brouillon"); query.exec();

    // --- PAYMENTS ---
    query.prepare("INSERT INTO payments (etudiant_id, montant, date, mode, statut, reference, description) VALUES (?, ?, ?, ?, ?, ?, ?)");
    query.addBindValue(studentId); query.addBindValue(800.0); query.addBindValue("2025-01-20"); query.addBindValue("Carte bancaire"); query.addBindValue("Payé"); query.addBindValue("PAY-2025-001"); query.addBindValue("Frais d'inscription"); query.exec();
    query.addBindValue(studentId); query.addBindValue(1600.0); query.addBindValue("2025-05-01"); query.addBindValue("Carte bancaire"); query.addBindValue("Payé"); query.addBindValue("PAY-2025-002"); query.addBindValue("Frais de scolarité - Semestre 2"); query.exec();
    query.addBindValue(studentId); query.addBindValue(300.0); query.addBindValue("2025-03-15"); query.addBindValue("Mobile Money"); query.addBindValue("Payé"); query.addBindValue("PAY-2025-003"); query.addBindValue("Frais de laboratoire"); query.exec();
    query.addBindValue(studentId); query.addBindValue(150.0); query.addBindValue("2025-02-10"); query.addBindValue("Virement bancaire"); query.addBindValue("Payé"); query.addBindValue("PAY-2025-004"); query.addBindValue("Frais de bibliothèque"); query.exec();
    query.addBindValue(studentId); query.addBindValue(100.0); query.addBindValue("2025-05-05"); query.addBindValue(""); query.addBindValue("En attente"); query.addBindValue("PAY-2025-005"); query.addBindValue("Assurance étudiante"); query.exec();
    query.addBindValue(studentId); query.addBindValue(250.0); query.addBindValue("2025-05-10"); query.addBindValue(""); query.addBindValue("En attente"); query.addBindValue("PAY-2025-006"); query.addBindValue("Frais divers"); query.exec();

    // --- ROOMS & SESSIONS ---
    query.prepare("INSERT INTO rooms (nom, capacite, batiment) VALUES (?, ?, ?)");
    query.addBindValue("Salle 101"); query.addBindValue(50); query.addBindValue("Bâtiment A"); query.exec();
    int room1 = query.lastInsertId().toInt();
    
    query.prepare("INSERT INTO sessions (cours_id, salle_id, enseignant_id, jour, heure_debut, heure_fin) VALUES (?, ?, ?, ?, ?, ?)");
    query.addBindValue(cours1); query.addBindValue(room1); query.addBindValue(profId); query.addBindValue("Lundi"); query.addBindValue("08:00"); query.addBindValue("10:00"); query.exec();
    query.addBindValue(cours2); query.addBindValue(room1); query.addBindValue(profId); query.addBindValue("Mercredi"); query.addBindValue("14:00"); query.addBindValue("17:00"); query.exec();

    // --- PRESENCES ---
    query.prepare("INSERT INTO presences (inscription_id, date_seance, present) VALUES (?, ?, ?)");
    query.addBindValue(enroll1); query.addBindValue("2024-08-20"); query.addBindValue(1); query.exec();
    query.addBindValue(enroll1); query.addBindValue("2024-08-22"); query.addBindValue(0); query.exec();
    query.addBindValue(enroll1); query.addBindValue("2024-08-24"); query.addBindValue(1); query.exec();
    query.addBindValue(enroll2); query.addBindValue("2024-08-21"); query.addBindValue(1); query.exec();

    // --- NOTIFICATIONS ---
    query.prepare("INSERT INTO notifications (etudiant_id, titre, message, type, date, lu) VALUES (?, ?, ?, ?, ?, ?)");
    query.addBindValue(studentId); query.addBindValue("Nouvelle note"); query.addBindValue("Votre note pour Examen Base de données est disponible."); query.addBindValue("note"); query.addBindValue("2024-08-23 10:30:00"); query.addBindValue(0); query.exec();
    query.addBindValue(studentId); query.addBindValue("Paiement enregistré"); query.addBindValue("Votre paiement de 25000 HTG a été validé."); query.addBindValue("finance"); query.addBindValue("2024-08-22 14:15:00"); query.addBindValue(1); query.exec();
    query.addBindValue(studentId); query.addBindValue("Inscription confirmée"); query.addBindValue("Vous êtes inscrit pour l'année 2024-2025."); query.addBindValue("admin"); query.addBindValue("2024-08-20 09:00:00"); query.addBindValue(1); query.exec();

    // --- DOCUMENTS ---
    query.prepare("INSERT INTO documents (etudiant_id, nom, type, date_emission, chemin_fichier) VALUES (?, ?, ?, ?, ?)");
    query.addBindValue(studentId); query.addBindValue("Attestation d'inscription 2024"); query.addBindValue("Attestation"); query.addBindValue("2024-08-20"); query.addBindValue("/docs/attestation_2024.pdf"); query.exec();
    query.addBindValue(studentId); query.addBindValue("Relevé de notes Semestre 1"); query.addBindValue("Bulletin"); query.addBindValue("2024-01-25"); query.addBindValue("/docs/releve_s1.pdf"); query.exec();
    query.addBindValue(studentId); query.addBindValue("Reçu de paiement REF-67890"); query.addBindValue("Reçu"); query.addBindValue("2024-01-15"); query.addBindValue("/docs/recu_67890.pdf"); query.exec();

    // --- TRANSACTIONS ---
    query.prepare("INSERT INTO transactions (date, description, categorie, type, montant, statut, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)");
    query.addBindValue("21 Juil. 2025"); query.addBindValue("Paiement inscription - Marie Louise"); query.addBindValue("Inscriptions"); query.addBindValue("Revenu"); query.addBindValue(120.00); query.addBindValue("Réussi"); query.addBindValue(studentId); query.exec();
    query.addBindValue("21 Juil. 2025"); query.addBindValue("Achat matériel pédagogique"); query.addBindValue("Dépenses"); query.addBindValue("Dépense"); query.addBindValue(250.00); query.addBindValue("Réussi"); query.addBindValue(QVariant(QMetaType::fromType<int>())); query.exec();
    query.addBindValue("20 Juil. 2025"); query.addBindValue("Paiement cours - Structures de données"); query.addBindValue("Cours"); query.addBindValue("Revenu"); query.addBindValue(180.00); query.addBindValue("Réussi"); query.addBindValue(studentId); query.exec();
    query.addBindValue("19 Juil. 2025"); query.addBindValue("Frais de maintenance"); query.addBindValue("Dépenses"); query.addBindValue("Dépense"); query.addBindValue(75.00); query.addBindValue("En attente"); query.addBindValue(QVariant(QMetaType::fromType<int>())); query.exec();
    query.addBindValue("19 Juil. 2025"); query.addBindValue("Paiement inscription - Jean Marc"); query.addBindValue("Inscriptions"); query.addBindValue("Revenu"); query.addBindValue(100.00); query.addBindValue("Réussi"); query.addBindValue(studentId); query.exec();

    // --- USER ACTIVITIES ---
    query.prepare("INSERT INTO user_activities (user_id, action, date, details) VALUES (?, ?, ?, ?)");
    query.addBindValue(studentId); query.addBindValue("Connexion"); query.addBindValue("2024-08-25 08:15:00"); query.addBindValue("Depuis Chrome (Windows)"); query.exec();
    query.addBindValue(studentId); query.addBindValue("Profil mis à jour"); query.addBindValue("2024-08-22 14:30:00"); query.addBindValue("Mise à jour de l'adresse email"); query.exec();
    query.addBindValue(studentId); query.addBindValue("Mot de passe modifié"); query.addBindValue("2024-08-10 09:00:00"); query.addBindValue(""); query.exec();

    // --- SETTINGS ---
    query.prepare("INSERT OR IGNORE INTO settings (key, value) VALUES (?, ?)");
    query.addBindValue("general.nom_etablissement"); query.addBindValue("USFAH - Université"); query.exec();
    query.addBindValue("general.email"); query.addBindValue("contact@usfah.edu.ht"); query.exec();
    query.addBindValue("general.telephone"); query.addBindValue("+509 22 33 4455"); query.exec();
    query.addBindValue("general.adresse"); query.addBindValue("Route de l'Aéroport, Port-au-Prince, Haïti"); query.exec();
    
    query.addBindValue("etablissement.annee_academique"); query.addBindValue("2024 - 2025"); query.exec();
    query.addBindValue("etablissement.date_debut"); query.addBindValue("2024-09-01"); query.exec();
    query.addBindValue("etablissement.date_fin"); query.addBindValue("2025-06-30"); query.exec();
    query.addBindValue("etablissement.devise"); query.addBindValue("USD"); query.exec();
    query.addBindValue("etablissement.fuseau_horaire"); query.addBindValue("UTC-04:00"); query.exec();
    
    query.addBindValue("apparence.theme"); query.addBindValue("blue"); query.exec();
    query.addBindValue("apparence.mode"); query.addBindValue("clair"); query.exec();
    
    query.addBindValue("inscriptions.ouvertes"); query.addBindValue("true"); query.exec();
    query.addBindValue("inscriptions.methode"); query.addBindValue("Approbation manuelle"); query.exec();
    query.addBindValue("inscriptions.limite"); query.addBindValue("5"); query.exec();
    
    query.addBindValue("autres.langue"); query.addBindValue("Français"); query.exec();
    query.addBindValue("autres.format_date"); query.addBindValue("DD/MM/YYYY"); query.exec();
    query.addBindValue("autres.separateur"); query.addBindValue("."); query.exec();
    query.addBindValue("autres.elements_page"); query.addBindValue("20"); query.exec();
    
    // Notifications defaults
    query.addBindValue("notif.email_nouvelle_inscription"); query.addBindValue("true"); query.exec();
    query.addBindValue("notif.email_paiement"); query.addBindValue("true"); query.exec();
    query.addBindValue("notif.system_notes"); query.addBindValue("true"); query.exec();
    query.addBindValue("notif.system_absences"); query.addBindValue("false"); query.exec();
    
    // Security defaults
    query.addBindValue("sec.mfa_enabled"); query.addBindValue("false"); query.exec();
    query.addBindValue("sec.password_expiration_days"); query.addBindValue("90"); query.exec();
    query.addBindValue("sec.session_timeout_minutes"); query.addBindValue("30"); query.exec();
    
    // Academic defaults
    query.addBindValue("acad.note_passage"); query.addBindValue("60"); query.exec();
    query.addBindValue("acad.systeme_notation"); query.addBindValue("Sur 100"); query.exec();
    query.addBindValue("acad.max_credits_semestre"); query.addBindValue("18"); query.exec();
    
    // Backup defaults
    query.addBindValue("backup.auto_backup"); query.addBindValue("true"); query.exec();
    query.addBindValue("backup.frequency"); query.addBindValue("Quotidien"); query.exec();
    query.addBindValue("backup.last_backup_date"); query.addBindValue(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss")); query.exec();
}

void DatabaseManager::logActivity(int userId, const QString &action, const QString &details)
{
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("INSERT INTO user_activities (user_id, action, date, details) VALUES (?, ?, ?, ?)");
    query.addBindValue(userId);
    query.addBindValue(action);
    query.addBindValue(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
    query.addBindValue(details);
    query.exec();
}
