#include "AuthManager.h"
#include <QCoreApplication>

AuthManager::AuthManager(QObject *parent) : QObject(parent)
{
    initDatabase();
}

AuthManager::~AuthManager()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

void AuthManager::initDatabase()
{
    QString dbPath = QCoreApplication::applicationDirPath() + "/database";
    QDir dir(dbPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    
    QString dbFile = dbPath + "/usfah.db";
    
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(dbFile);

    if (!m_db.open()) {
        qWarning() << "Error opening database:" << m_db.lastError().text();
        return;
    }

    // Create table if it doesn't exist
    QSqlQuery query;
    bool createTable = query.exec("CREATE TABLE IF NOT EXISTS users ("
                                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                  "matricule TEXT UNIQUE,"
                                  "email TEXT UNIQUE,"
                                  "password_hash TEXT,"
                                  "nom TEXT,"
                                  "role TEXT)");
    
    if (!createTable) {
        qWarning() << "Error creating table:" << query.lastError().text();
        return;
    }

    // Check if table is empty, if so populate with dummy data
    query.exec("SELECT COUNT(*) FROM users");
    if (query.next() && query.value(0).toInt() == 0) {
        qDebug() << "Populating database with dummy users...";
        
        query.prepare("INSERT INTO users (matricule, email, password_hash, nom, role) "
                      "VALUES (:matricule, :email, :password_hash, :nom, :role)");
        
        // Admin user
        query.bindValue(":matricule", "admin");
        query.bindValue(":email", "admin@usfah.edu.ht");
        query.bindValue(":password_hash", hashPassword("password123"));
        query.bindValue(":nom", "Administrateur USFAH");
        query.bindValue(":role", "admin");
        query.exec();

        // Student user
        query.bindValue(":matricule", "2023-usfah-0451");
        query.bindValue(":email", "etudiant@usfah.edu.ht");
        query.bindValue(":password_hash", hashPassword("student123"));
        query.bindValue(":nom", "Jean Dupont");
        query.bindValue(":role", "student");
        query.exec();
    }
}

QString AuthManager::hashPassword(const QString &password)
{
    QByteArray hash = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256);
    return QString(hash.toHex());
}

bool AuthManager::login(const QString &identifier, const QString &password)
{
    if (!m_db.isOpen()) {
        emit loginFailed("Erreur de connexion à la base de données.");
        return false;
    }

    if (identifier.isEmpty() || password.isEmpty()) {
        emit loginFailed("Les identifiants ne peuvent pas être vides.");
        return false;
    }

    QString hashedPassword = hashPassword(password);
    
    QSqlQuery query;
    // identifier can be either email or matricule
    query.prepare("SELECT role, nom FROM users WHERE (email = :id OR matricule = :id) AND password_hash = :hash");
    query.bindValue(":id", identifier);
    query.bindValue(":hash", hashedPassword);

    if (query.exec() && query.next()) {
        QString role = query.value(0).toString();
        QString nom = query.value(1).toString();
        emit loginSuccess(role, nom);
        return true;
    } else {
        emit loginFailed("Identifiant ou mot de passe incorrect.");
        return false;
    }
}

bool AuthManager::registerStudent(const QString &matricule, const QString &email, const QString &password, const QString &nom)
{
    if (!m_db.isOpen()) {
        emit registerFailed("Erreur de connexion à la base de données.");
        return false;
    }

    if (matricule.isEmpty() || email.isEmpty() || password.isEmpty() || nom.isEmpty()) {
        emit registerFailed("Tous les champs sont obligatoires.");
        return false;
    }

    // Check if user already exists
    QSqlQuery checkQuery;
    checkQuery.prepare("SELECT COUNT(*) FROM users WHERE matricule = :matricule OR email = :email");
    checkQuery.bindValue(":matricule", matricule);
    checkQuery.bindValue(":email", email);
    if (checkQuery.exec() && checkQuery.next()) {
        if (checkQuery.value(0).toInt() > 0) {
            emit registerFailed("Un compte existe déjà avec ce matricule ou cet email.");
            return false;
        }
    }

    QString hashedPassword = hashPassword(password);
    
    QSqlQuery query;
    query.prepare("INSERT INTO users (matricule, email, password_hash, nom, role) "
                  "VALUES (:matricule, :email, :password_hash, :nom, :role)");
    
    query.bindValue(":matricule", matricule);
    query.bindValue(":email", email);
    query.bindValue(":password_hash", hashedPassword);
    query.bindValue(":nom", nom);
    query.bindValue(":role", "student"); // Force role as student

    if (query.exec()) {
        emit registerSuccess();
        return true;
    } else {
        emit registerFailed("Erreur lors de la création du compte.");
        return false;
    }
}
