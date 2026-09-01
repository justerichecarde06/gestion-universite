#ifndef ADMINGRADESERVICE_H
#define ADMINGRADESERVICE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class AuthService;

class AdminGradeService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList faculties READ faculties NOTIFY facultiesChanged)
    Q_PROPERTY(QVariantList courses READ courses NOTIFY coursesChanged)
    Q_PROPERTY(QVariantList studentsList READ studentsList NOTIFY studentsListChanged)

public:
    explicit AdminGradeService(AuthService *authService, QObject *parent = nullptr);

    QVariantList faculties() const { return m_faculties; }
    QVariantList courses() const { return m_courses; }
    QVariantList studentsList() const { return m_studentsList; }

    Q_INVOKABLE void loadFaculties();
    Q_INVOKABLE void loadCourses(const QString &facultyName);
    Q_INVOKABLE void loadStudents(int courseId);
    Q_INVOKABLE QVariantMap getGradeStats(int courseId);
    Q_INVOKABLE void saveGrade(int enrollmentId, double intraGrade, double finalGrade);
    Q_INVOKABLE void publishGrades(int courseId);

signals:
    void facultiesChanged();
    void coursesChanged();
    void studentsListChanged();
    void operationSuccess(const QString &message);
    void operationError(const QString &error);

private:
    AuthService *m_authService;
    QVariantList m_faculties;
    QVariantList m_courses;
    QVariantList m_studentsList;

    QString getInitials(const QString &nom, const QString &prenom);
};

#endif // ADMINGRADESERVICE_H
