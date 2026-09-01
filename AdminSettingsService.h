#ifndef ADMINSETTINGSSERVICE_H
#define ADMINSETTINGSSERVICE_H

#include <QObject>
#include <QVariantMap>

class AuthService;

class AdminSettingsService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap generalSettings READ generalSettings NOTIFY settingsChanged)
    Q_PROPERTY(QVariantMap securitySettings READ securitySettings NOTIFY settingsChanged)
    Q_PROPERTY(QVariantMap notificationSettings READ notificationSettings NOTIFY settingsChanged)
    Q_PROPERTY(QVariantMap academicSettings READ academicSettings NOTIFY settingsChanged)
    Q_PROPERTY(QVariantMap backupSettings READ backupSettings NOTIFY settingsChanged)

public:
    explicit AdminSettingsService(AuthService *authService, QObject *parent = nullptr);

    QVariantMap generalSettings() const;
    QVariantMap securitySettings() const;
    QVariantMap notificationSettings() const;
    QVariantMap academicSettings() const;
    QVariantMap backupSettings() const;

public slots:
    Q_INVOKABLE void saveGeneralSettings(const QVariantMap &settings);
    Q_INVOKABLE void saveSecuritySettings(const QVariantMap &settings);
    Q_INVOKABLE void saveNotificationSettings(const QVariantMap &settings);
    Q_INVOKABLE void saveAcademicSettings(const QVariantMap &settings);
    Q_INVOKABLE void saveBackupSettings(const QVariantMap &settings);
    Q_INVOKABLE void triggerBackup();
    
    Q_INVOKABLE void refreshData();

signals:
    void settingsChanged();
    void showMessage(const QString &message, bool isError = false);

private:
    AuthService *m_authService;
    
    QVariantMap m_generalSettings;
    QVariantMap m_securitySettings;
    QVariantMap m_notificationSettings;
    QVariantMap m_academicSettings;
    QVariantMap m_backupSettings;
    
    void loadAllSettings();
    void saveSettingsToDb(const QVariantMap &settings, const QString &prefix);
};

#endif // ADMINSETTINGSSERVICE_H
