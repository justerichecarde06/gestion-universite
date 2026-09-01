cmake_minimum_required(VERSION 3.16)

project(USFAHLoginApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick Sql QuickControls2 REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)
if(COMMAND qt_policy)
    qt_policy(SET QTP0004 OLD)
endif()

qt_add_executable(appUSFAHLoginApp
    main.cpp
    DatabaseManager.h
    DatabaseManager.cpp
    AuthService.h
    AuthService.cpp
    StudentService.h
    StudentService.cpp
    DashboardService.h
    DashboardService.cpp
    NotificationService.h
    NotificationService.cpp
    DocumentService.h
    DocumentService.cpp
    AdminGradeService.h
    AdminGradeService.cpp
    AdminCourseService.h
    AdminCourseService.cpp
    AdminFinanceService.h
    AdminFinanceService.cpp
    AdminSettingsService.h
    AdminSettingsService.cpp
)

qt_add_qml_module(appUSFAHLoginApp
    URI USFAHLogin
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/LoginPage.qml
        qml/RegisterPage.qml
        qml/ForgotPasswordPage.qml
        qml/ResetPasswordPage.qml
        qml/AppDashboard.qml
        qml/components/PermissionGuard.qml
        qml/AdminDashboard.qml
        qml/StudentDashboard.qml
        qml/admin/Overview.qml
        qml/admin/UsersView.qml
        qml/admin/CoursesView.qml
        qml/admin/GradesView.qml
        qml/admin/ScheduleView.qml
        qml/admin/SettingsView.qml
        qml/admin/RegistrationRequestsView.qml
        qml/admin/FinancesView.qml
        qml/components/StyledTextField.qml
        qml/components/PrimaryButton.qml
        qml/components/Checkbox.qml
        qml/student/AttendanceView.qml
        qml/student/CoursesView.qml
        qml/student/DocumentsView.qml
        qml/student/EnrollmentsView.qml
        qml/student/FinanceView.qml
        qml/student/GradesView.qml
        qml/student/Overview.qml
        qml/student/ProfileView.qml
        qml/student/ScheduleView.qml
        qml/student/profile/ProfileHeader.qml
        qml/student/profile/PersonalInfoCard.qml
        qml/student/profile/AcademicInfoCard.qml
        qml/student/profile/ProgressCard.qml
        qml/student/profile/AcademicTimelineCard.qml
        qml/student/profile/SecurityCard.qml
        qml/student/profile/RecentActivityCard.qml
        qml/student/profile/DocumentsCard.qml
        qml/student/profile/StudentCardWidget.qml
        qml/student/profile/AcademicSummaryCard.qml
        qml/student/profile/QuickActionsCard.qml
        qml/student/dashboard/DashboardHeader.qml
        qml/student/dashboard/ProfileCard.qml
        qml/student/dashboard/StatsGrid.qml
        qml/student/dashboard/AcademicProgress.qml
        qml/student/dashboard/NextClassCard.qml
        qml/student/dashboard/ScheduleTimeline.qml
        qml/student/dashboard/RecentGrades.qml
        qml/student/dashboard/PerformanceChart.qml
        qml/student/dashboard/AttendanceWidget.qml
        qml/student/dashboard/FinanceWidget.qml
        qml/student/dashboard/AlertsWidget.qml
        qml/student/dashboard/QuickShortcuts.qml
        qml/student/dashboard/CurrentCoursesWidget.qml
    RESOURCES
        assets/logo_usfah.png
)

target_link_libraries(appUSFAHLoginApp
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
    PRIVATE Qt6::QuickControls2
)

# Set target properties for macOS/Windows bundles
set_target_properties(appUSFAHLoginApp PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE FALSE
)
