#ifndef NOTIFICATIONSERVICE_H
#define NOTIFICATIONSERVICE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class AuthService;

class NotificationService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList notifications READ notifications NOTIFY notificationsChanged)
    Q_PROPERTY(int unreadCount READ unreadCount NOTIFY unreadCountChanged)

public:
    explicit NotificationService(AuthService *auth, QObject *parent = nullptr);

    QVariantList notifications() const { return m_notifications; }
    int unreadCount() const { return m_unreadCount; }

public slots:
    void refreshData();
    void markAsRead(int id);
    void markAllAsRead();
    void onDatabaseUpdated(const QString &tableName);

signals:
    void notificationsChanged();
    void unreadCountChanged();

private:
    AuthService *m_auth;
    QVariantList m_notifications;
    int m_unreadCount = 0;
};

#endif // NOTIFICATIONSERVICE_H
