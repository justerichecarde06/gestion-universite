#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QDir>
#include <QCoreApplication>
#include <QCryptographicHash>

class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    static DatabaseManager& instance()
    {
        static DatabaseManager instance;
        return instance;
    }

    QSqlDatabase getDatabase() const { return m_db; }
    
    void notifyUpdate(const QString &tableName) {
        emit databaseUpdated(tableName);
    }
    
    // Hash helper shared across services
    static QString hashPassword(const QString &password) {
        QByteArray hash = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256);
        return QString(hash.toHex());
    }
    
    static void logActivity(int userId, const QString &action, const QString &details = "");
    
signals:
    void databaseUpdated(const QString &tableName);

private:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();
    DatabaseManager(const DatabaseManager&) = delete;
    DatabaseManager& operator=(const DatabaseManager&) = delete;

    QSqlDatabase m_db;
    void initDatabase();
    void createTables();
    void populateDummyData();
};

#endif // DATABASEMANAGER_H
