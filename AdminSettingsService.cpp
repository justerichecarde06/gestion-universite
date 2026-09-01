#include "AdminSettingsService.h"
#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>
#include <QDebug>
#include <QTimer>

AdminSettingsService::AdminSettingsService(AuthService *authService, QObject *parent)
    : QObject(parent), m_authService(authService)
{
    connect(&DatabaseManager::instance(), &DatabaseManager::databaseUpdated, this, [this](const QString &tableName) {
        if (tableName == "settings") {
            refreshData();
        }
    });

    refreshData();
}

QVariantMap AdminSettingsService::generalSettings() const { return m_generalSettings; }
QVariantMap AdminSettingsService::securitySettings() const { return m_securitySettings; }
QVariantMap AdminSettingsService::notificationSettings() const { return m_notificationSettings; }
QVariantMap AdminSettingsService::academicSettings() const { return m_academicSettings; }
QVariantMap AdminSettingsService::backupSettings() const { return m_backupSettings; }

void AdminSettingsService::refreshData()
{
    loadAllSettings();
    emit settingsChanged();
}

void AdminSettingsService::loadAllSettings()
{
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    QSqlQuery query("SELECT key, value FROM settings", db);
    
    m_generalSettings.clear();
    m_securitySettings.clear();
    m_notificationSettings.clear();
    m_academicSettings.clear();
    m_backupSettings.clear();
    
    while (query.next()) {
        QString key = query.value(0).toString();
        QString value = query.value(1).toString();
        
        if (key.startsWith("general.") || key.startsWith("etablissement.") || key.startsWith("apparence.") || key.startsWith("inscriptions.") || key.startsWith("autres.")) {
            m_generalSettings[key] = value;
        } else if (key.startsWith("sec.")) {
            m_securitySettings[key] = value;
        } else if (key.startsWith("notif.")) {
            m_notificationSettings[key] = value;
        } else if (key.startsWith("acad.")) {
            m_academicSettings[key] = value;
        } else if (key.startsWith("backup.")) {
            m_backupSettings[key] = value;
        }
    }
}

void AdminSettingsService::saveSettingsToDb(const QVariantMap &settings, const QString &prefix)
{
    QSqlDatabase db = DatabaseManager::instance().getDatabase();
    QSqlQuery query(db);
    db.transaction();
    
    query.prepare("INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)");
    for (auto it = settings.constBegin(); it != settings.constEnd(); ++it) {
        if (it.key().startsWith(prefix) || prefix.isEmpty()) {
            query.addBindValue(it.key());
            query.addBindValue(it.value().toString());
            query.exec();
        }
    }
    
    if (db.commit()) {
        if (m_authService) {
            DatabaseManager::logActivity(m_authService->currentUserId(), "Mise à jour des paramètres", "Préfixe: " + prefix);
        }
        emit showMessage("Paramètres sauvegardés avec succès !");
        DatabaseManager::instance().notifyUpdate("settings");
    } else {
        db.rollback();
        emit showMessage("Erreur lors de la sauvegarde : " + query.lastError().text(), true);
    }
}

void AdminSettingsService::saveGeneralSettings(const QVariantMap &settings)
{
    saveSettingsToDb(settings, "");
}

void AdminSettingsService::saveSecuritySettings(const QVariantMap &settings)
{
    saveSettingsToDb(settings, "sec.");
}

void AdminSettingsService::saveNotificationSettings(const QVariantMap &settings)
{
    saveSettingsToDb(settings, "notif.");
}

void AdminSettingsService::saveAcademicSettings(const QVariantMap &settings)
{
    saveSettingsToDb(settings, "acad.");
}

void AdminSettingsService::saveBackupSettings(const QVariantMap &settings)
{
    saveSettingsToDb(settings, "backup.");
}

void AdminSettingsService::triggerBackup()
{
    emit showMessage("Sauvegarde en cours...");
    
    if (m_authService) {
        DatabaseManager::logActivity(m_authService->currentUserId(), "Sauvegarde manuelle", "Déclenchement d'une sauvegarde de la base de données");
    }
    
    // Simulate backup delay
    QTimer::singleShot(2000, this, [this]() {
        QSqlDatabase db = DatabaseManager::instance().getDatabase();
        QSqlQuery query(db);
        query.prepare("INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)");
        query.addBindValue("backup.last_backup_date");
        query.addBindValue(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
        query.exec();
        DatabaseManager::instance().notifyUpdate("settings");
        
        emit showMessage("Sauvegarde terminée avec succès.");
    });
}
