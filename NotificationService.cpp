#include "NotificationService.h"
#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

NotificationService::NotificationService(AuthService *auth, QObject *parent)
    : QObject(parent), m_auth(auth)
{
    connect(m_auth, &AuthService::currentUserIdChanged, this, &NotificationService::refreshData);
    connect(&DatabaseManager::instance(), &DatabaseManager::databaseUpdated, this, &NotificationService::onDatabaseUpdated);
}

void NotificationService::onDatabaseUpdated(const QString &tableName)
{
    if (tableName == "notifications") {
        refreshData();
    }
}

void NotificationService::refreshData()
{
    if (m_auth->currentUserId() == -1) {
        m_notifications.clear();
        m_unreadCount = 0;
        emit notificationsChanged();
        emit unreadCountChanged();
        return;
    }

    m_notifications.clear();
    m_unreadCount = 0;

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT id, titre, message, type, date, lu FROM notifications WHERE etudiant_id = :id ORDER BY date DESC");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap notif;
            notif["id"] = query.value("id").toInt();
            notif["titre"] = query.value("titre").toString();
            notif["message"] = query.value("message").toString();
            notif["type"] = query.value("type").toString();
            notif["date"] = query.value("date").toString();
            int lu = query.value("lu").toInt();
            notif["lu"] = (lu == 1);
            
            if (lu == 0) m_unreadCount++;
            
            m_notifications.append(notif);
        }
        emit notificationsChanged();
        emit unreadCountChanged();
    }
}

void NotificationService::markAsRead(int id)
{
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("UPDATE notifications SET lu = 1 WHERE id = :id AND etudiant_id = :etudiant_id");
    query.bindValue(":id", id);
    query.bindValue(":etudiant_id", m_auth->currentUserId());
    
    if (query.exec()) {
        DatabaseManager::instance().notifyUpdate("notifications");
    }
}

void NotificationService::markAllAsRead()
{
    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("UPDATE notifications SET lu = 1 WHERE etudiant_id = :etudiant_id");
    query.bindValue(":etudiant_id", m_auth->currentUserId());
    
    if (query.exec()) {
        DatabaseManager::instance().notifyUpdate("notifications");
    }
}
