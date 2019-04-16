import Felgo 3.0
import QtQuick 2.0
import "model"
import "logic"
import "pages"
import "secrets"

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)

    licenseKey: Secrets.key

    // app initialization
    Component.onCompleted: {
        // if device has network connection, clear cache at startup
        // you'll probably implement a more intelligent cache cleanup for your app
        // e.g. to only clear the items that aren't required regularly
        if (isOnline) {
            logic.clearCache()
        }

        // fetch todo list data
        logic.fetchHabits()
        logic.fetchDraftHabits()
    }

    // business logic
    Logic { id: logic }

    // model
    DataModel {
        id: dataModel
        dispatcher: logic // data model handles actions sent by logic

        onFetchHabitsFailed: nativeUtils.displayMessageBox(qsTr("Unable to load habits"), error, 1)
    }

    // view
    Navigation {
        id: navigation

        // only enable if user is logged in
        // login page below overlays navigation then
        enabled: true // dataModel.userLoggedIn

        NavigationItem {
            title: qsTr("Habits list")
            icon: IconType.list

            NavigationStack {
                splitView: tablet // use side-by-side view on tablets
                initialPage: HabitsListPage { }
            }
        }

        NavigationItem {
            title: qsTr("Report")
            icon: IconType.barchart

            NavigationStack {
                splitView: tablet // use side-by-side view on tablets
                initialPage: ReportPage { }
            }
        }

        NavigationItem {
            title: qsTr("Profile") // use qsTr for strings you want to translate
            icon: IconType.user

            NavigationStack {
                initialPage: ProfilePage {
                    // handle logout
                    onLogoutClicked: {
                        //                        logic.logout()
                        // jump to main page after logout
                        //                        navigation.currentIndex = 0
                        //                        navigation.currentNavigationItem.navigationStack.popAllExceptFirst()
                    }
                }
            }
        }
    }
}
