#ifndef ADMINCOURSESERVICE_H
#define ADMINCOURSESERVICE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class AuthService;

class AdminCourseService : public QObject
{
    Q_OBJECT
public:
    explicit AdminCourseService(AuthService *authService, QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getCourses(const QString &departmentFilter = "Tous", const QString &statusFilter = "Tous", const QString &searchQuery = "");
    Q_INVOKABLE QVariantMap getCourseStats();
    
    Q_INVOKABLE bool addCourse(const QVariantMap &courseData);
    Q_INVOKABLE bool updateCourse(int courseId, const QVariantMap &courseData);
    Q_INVOKABLE bool deleteCourse(int courseId);

signals:
    void coursesChanged();
    void actionSuccess(const QString &message);
    void actionFailed(const QString &error);

private:
    AuthService *m_authService;
};

#endif // ADMINCOURSESERVICE_H
