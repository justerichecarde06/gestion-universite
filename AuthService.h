#ifndef AUTHSERVICE_H
#define AUTHSERVICE_H

#include <QObject>
#include <QString>

class AuthService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentUserId READ currentUserId NOTIFY currentUserIdChanged)
    Q_PROPERTY(QString currentUserRole READ currentUserRole NOTIFY currentUserRoleChanged)
    Q_PROPERTY(QStringList currentUserPermissions READ currentUserPermissions NOTIFY currentUserPermissionsChanged)

public:
    explicit AuthService(QObject *parent = nullptr);

    Q_INVOKABLE bool login(const QString &identifier, const QString &password);
    Q_INVOKABLE bool registerStudent(const QString &email, const QString &password, const QString &nom, const QString &prenom, const QString &phone, const QString &faculte, const QString &filiere, const QString &niveau);
    Q_INVOKABLE bool requestPasswordReset(const QString &email);
    Q_INVOKABLE bool resetPassword(const QString &token, const QString &newPassword);
    Q_INVOKABLE void logout();
    
    Q_INVOKABLE bool hasPermission(const QString &permission) const;
    Q_INVOKABLE bool invitePersonnel(const QString &email, const QString &nom, const QString &prenom, const QString &role);
    
    // Admin methods
    Q_INVOKABLE QVariantList getAllUsers(const QString &searchQuery = "");
    Q_INVOKABLE QVariantList getRegistrationRequests(const QString &statusFilter);
    Q_INVOKABLE QVariantMap getRegistrationStats();
    Q_INVOKABLE bool approveRegistration(int userId);
    Q_INVOKABLE bool rejectRegistration(int userId, const QString &reason);
    Q_INVOKABLE bool suspendAccount(int userId);

    int currentUserId() const;
    QString currentUserRole() const;
    QStringList currentUserPermissions() const;

signals:
    void loginSuccess(const QString &role, const QString &name);
    void loginFailed(const QString &errorMessage);
    void registerSuccess();
    void registerFailed(const QString &errorMessage);
    void passwordResetRequested(const QString &message);
    void passwordResetFailed(const QString &errorMessage);
    void passwordResetSuccess();
    void passwordResetError(const QString &errorMessage);
    
    void adminActionSuccess(const QString &message);
    void adminActionFailed(const QString &errorMessage);
    void registrationRequestsChanged();

    void currentUserIdChanged();
    void currentUserRoleChanged();
    void currentUserPermissionsChanged();

    void invitationSuccess(const QString &message);
    void invitationFailed(const QString &errorMessage);

private:
    int m_currentUserId;
    QString m_currentUserRole;
    QStringList m_currentUserPermissions;
};

#endif // AUTHSERVICE_H
