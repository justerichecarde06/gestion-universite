#ifndef DOCUMENTSERVICE_H
#define DOCUMENTSERVICE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class AuthService;

class DocumentService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList documents READ documents NOTIFY documentsChanged)

public:
    explicit DocumentService(AuthService *auth, QObject *parent = nullptr);

    QVariantList documents() const { return m_documents; }

public slots:
    void refreshData();
    void onDatabaseUpdated(const QString &tableName);

signals:
    void documentsChanged();

private:
    AuthService *m_auth;
    QVariantList m_documents;
};

#endif // DOCUMENTSERVICE_H
