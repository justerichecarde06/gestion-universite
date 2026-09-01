#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QString>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QCryptographicHash>
#include <QDir>
#include <QStandardPaths>

class AuthManager : public QObject
{
    Q_OBJECT

public:
    explicit AuthManager(QObject *parent = nullptr);
    ~AuthManager();

    Q_INVOKABLE bool login(const QString &identifier, const QString &password);
    Q_INVOKABLE bool registerStudent(const QString &matricule, const QString &email, const QString &password, const QString &nom);
    Q_INVOKABLE QString hashPassword(const QString &password);

signals:
    void loginSuccess(const QString &role, const QString &name);
    void loginFailed(const QString &errorMessage);
    void registerSuccess();
    void registerFailed(const QString &errorMessage);

private:
    QSqlDatabase m_db;
    void initDatabase();
};

#endif // AUTHMANAGER_H
