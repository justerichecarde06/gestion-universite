#include "DocumentService.h"
#include "AuthService.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>

DocumentService::DocumentService(AuthService *auth, QObject *parent)
    : QObject(parent), m_auth(auth)
{
    connect(m_auth, &AuthService::currentUserIdChanged, this, &DocumentService::refreshData);
    connect(&DatabaseManager::instance(), &DatabaseManager::databaseUpdated, this, &DocumentService::onDatabaseUpdated);
}

void DocumentService::onDatabaseUpdated(const QString &tableName)
{
    if (tableName == "documents") {
        refreshData();
    }
}

void DocumentService::refreshData()
{
    if (m_auth->currentUserId() == -1) {
        m_documents.clear();
        emit documentsChanged();
        return;
    }

    m_documents.clear();

    QSqlQuery query(DatabaseManager::instance().getDatabase());
    query.prepare("SELECT id, nom, type, date_emission, chemin_fichier FROM documents WHERE etudiant_id = :id ORDER BY date_emission DESC");
    query.bindValue(":id", m_auth->currentUserId());

    if (query.exec()) {
        while (query.next()) {
            QVariantMap doc;
            doc["id"] = query.value("id").toInt();
            doc["nom"] = query.value("nom").toString();
            doc["type"] = query.value("type").toString();
            doc["date"] = query.value("date_emission").toString();
            doc["chemin_fichier"] = query.value("chemin_fichier").toString();
            m_documents.append(doc);
        }
        emit documentsChanged();
    }
}
