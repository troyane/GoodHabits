import Felgo 3.0
import QtQuick 2.0
import "model"
import "logic"
import "pages"
import "secrets"

import "js/testData.js" as TestData
import "components"

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)

    id: app

    /// See `GoodHabitsApp/qml/secrets/Secrets.qml` for more information regarding license key
    licenseKey: Secrets.key

    /**
      * Gets stored settings value with given \c name, or if not found -- returns default value
      * @param string name name of settings
      * @param string defaultValue dafault value of settings that will be used in case if given not found.
      * @return var value
      */
    function getSettingsValueOrUseDefault(name, defaultValue) {
        var value = app.settings.getValue(name)
        if (value === undefined) {
            value = defaultValue
            app.settings.setValue(name, value)
        }
        return value
    }

    /**
      * Function for testing purposes. It loads test data.
      */
    function _debugPrepareData() {
        dataModel.cache.clearAll()

        var habitsData = TestData.habitsData
        dataModel.cache.setValue(Constants.hHabits, habitsData)

        var recordsData = TestData.recordsData
        dataModel.cache.setValue(Constants.records, recordsData)
    }

    // app initialization
    Component.onCompleted: {
        // _debugPrepareData()
        logic.loadHabits()
        logic.loadRecords()
    }

    // business logic
    Logic { id: logic }

    // model
    DataModel {
        id: dataModel
        dispatcher: logic // data model handles actions sent by logic
    }

    // view
    Navigation {
        id: navigation
        enabled: true
        NavigationItem {
            id: navHabits
            title: qsTr("Habits list")
            icon: IconType.list

            onSelected: {
                navHabits.navigationStack.currentPage.applySettings()
            }

            NavigationStack {
                id: niHabitsList
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
            title: qsTr("Profile")
            icon: IconType.user

            NavigationStack {
                initialPage: ProfilePage { }
            }
        }
    }
}
