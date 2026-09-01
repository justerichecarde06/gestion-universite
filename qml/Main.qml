import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: mainWindow
    width: 1440
    height: 900
    minimumWidth: 1024
    minimumHeight: 680
    visible: true
    title: qsTr("Portail Étudiant - USFAH")
    
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: loginPageComponent
    }

    Component {
        id: loginPageComponent
        LoginPage {
            onLoginAccepted: function(role, name) {
                stackView.push(appDashboardComponent)
            }
            onRegisterRequested: stackView.push(registerPageComponent)
            onForgotPasswordRequested: stackView.push(forgotPasswordPageComponent)
        }
    }

    Component {
        id: forgotPasswordPageComponent
        ForgotPasswordPage {
            onBackToLogin: stackView.pop()
            onResetTokenReceived: function(email) {
                // Remove ForgotPasswordPage and push ResetPasswordPage
                stackView.replace(resetPasswordPageComponent)
            }
        }
    }

    Component {
        id: resetPasswordPageComponent
        ResetPasswordPage {
            onCancelReset: stackView.pop()
            onPasswordResetSuccessfully: {
                stackView.pop() // go back to login
            }
        }
    }

    Component {
        id: registerPageComponent
        RegisterPage {
            onBackToLogin: stackView.pop()
            onRegistrationSuccess: {
                stackView.pop() // Go back to login after successful registration
            }
        }
    }

    Component {
        id: appDashboardComponent
        AppDashboard {
            onLogout: stackView.pop()
        }
    }
}
