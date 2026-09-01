#ifndef STUDENTSERVICE_H
#define STUDENTSERVICE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class AuthService;

class StudentService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap profile READ profile NOTIFY profileChanged)
    Q_PROPERTY(QVariantList enrolledCourses READ enrolledCourses NOTIFY enrolledCoursesChanged)
    Q_PROPERTY(QVariantList availableCourses READ availableCourses NOTIFY availableCoursesChanged)
    Q_PROPERTY(QVariantList grades READ grades NOTIFY gradesChanged)
    Q_PROPERTY(QVariantList schedule READ schedule NOTIFY scheduleChanged)
    Q_PROPERTY(QVariantList finances READ finances NOTIFY financesChanged)
    Q_PROPERTY(QVariantList attendance READ attendance NOTIFY attendanceChanged)
    Q_PROPERTY(QVariantList recentActivity READ recentActivity NOTIFY recentActivityChanged)
    Q_PROPERTY(QVariantList profileDocuments READ profileDocuments NOTIFY profileDocumentsChanged)
    Q_PROPERTY(QVariantMap academicProgress READ academicProgress NOTIFY academicProgressChanged)
    Q_PROPERTY(QVariantList academicHistory READ academicHistory NOTIFY academicHistoryChanged)
    Q_PROPERTY(QVariantMap financeSummary READ financeSummary NOTIFY financesChanged)

public:
    explicit StudentService(AuthService *auth, QObject *parent = nullptr);

    QVariantMap profile() const;
    QVariantList enrolledCourses() const;
    QVariantList availableCourses() const;
    QVariantList grades() const;
    QVariantList schedule() const;
    QVariantList finances() const;
    QVariantList attendance() const;
    QVariantList recentActivity() const;
    QVariantList profileDocuments() const;
    QVariantMap academicProgress() const;
    QVariantList academicHistory() const;
    QVariantMap financeSummary() const;

    Q_INVOKABLE void refreshData();
    Q_INVOKABLE bool enrollInCourse(int courseId);
    
    Q_INVOKABLE QVariantMap updateProfile(const QVariantMap &data);
    Q_INVOKABLE QVariantMap changePassword(const QString &oldPassword, const QString &newPassword);
    Q_INVOKABLE bool updateProfilePhoto(const QString &filePath);

signals:
    void profileChanged();
    void enrolledCoursesChanged();
    void availableCoursesChanged();
    void gradesChanged();
    void scheduleChanged();
    void financesChanged();
    void attendanceChanged();
    void recentActivityChanged();
    void profileDocumentsChanged();
    void academicProgressChanged();
    void academicHistoryChanged();

private:
    AuthService *m_auth;
    QVariantMap m_profile;
    QVariantList m_enrolledCourses;
    QVariantList m_availableCourses;
    QVariantList m_grades;
    QVariantList m_schedule;
    QVariantList m_finances;
    QVariantList m_attendance;
    QVariantList m_recentActivity;
    QVariantList m_profileDocuments;
    QVariantMap m_academicProgress;
    QVariantList m_academicHistory;
    QVariantMap m_financeSummary;

    void loadProfile();
    void loadEnrolledCourses();
    void loadAvailableCourses();
    void loadGrades();
    void loadSchedule();
    void loadFinances();
    void loadAttendance();
    void loadRecentActivity();
    void loadProfileDocuments();
    void loadAcademicProgress();
    void loadAcademicHistory();
};

#endif // STUDENTSERVICE_H
