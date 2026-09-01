#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QQuickStyle>
#include "AuthService.h"
#include "StudentService.h"
#include "DashboardService.h"
#include "NotificationService.h"
#include "DocumentService.h"
#include "AdminGradeService.h"
#include "AdminCourseService.h"
#include "AdminFinanceService.h"
#include "AdminSettingsService.h"

#include <QFile>
#include <QTextStream>
#include <QDateTime>

void customMessageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QFile outFile("qt_debug.log");
    (void)outFile.open(QIODevice::WriteOnly | QIODevice::Append);
    QTextStream ts(&outFile);
    ts << msg << "\n";
}

int main(int argc, char *argv[])
{
    // qInstallMessageHandler(customMessageHandler);
    QQuickStyle::setStyle("Basic");
    QGuiApplication app(argc, argv);
    
    // Application info for QSettings
    app.setOrganizationName("USFAH");
    app.setOrganizationDomain("usfah.edu.ht");
    app.setApplicationName("PortailEtudiant");
    
    QQmlApplicationEngine engine;
    
    // Register Services as context properties so they are available in QML
    AuthService authService;
    StudentService studentService(&authService);
    DashboardService dashboardService(&authService);
    NotificationService notificationService(&authService);
    DocumentService documentService(&authService);
    AdminGradeService adminGradeService(&authService);
    AdminCourseService adminCourseService(&authService);
    AdminFinanceService adminFinanceService(&authService);
    AdminSettingsService adminSettingsService(&authService);
    
    // Keep 'authManager' name for backward compatibility with QML login pages
    engine.rootContext()->setContextProperty("authManager", &authService);
    engine.rootContext()->setContextProperty("studentService", &studentService);
    engine.rootContext()->setContextProperty("dashboardService", &dashboardService);
    engine.rootContext()->setContextProperty("notificationService", &notificationService);
    engine.rootContext()->setContextProperty("documentService", &documentService);
    engine.rootContext()->setContextProperty("adminGradeService", &adminGradeService);
    engine.rootContext()->setContextProperty("adminCourseService", &adminCourseService);
    engine.rootContext()->setContextProperty("adminFinanceService", &adminFinanceService);
    engine.rootContext()->setContextProperty("adminSettingsService", &adminSettingsService);
    
    // Connect services for real-time sync
    QObject::connect(&adminCourseService, &AdminCourseService::coursesChanged, &studentService, &StudentService::refreshData);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("USFAHLogin", "Main");

    return app.exec();
}
