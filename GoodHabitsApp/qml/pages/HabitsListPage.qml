import Felgo 3.0
import QtQuick 2.0

Page {
    id: page
    title: qsTr("Habits list") // use qsTr for strings you want to translate

    rightBarItem: NavigationBarRow {
        // network activity indicator
        ActivityIndicatorBarItem {
            enabled: dataModel.isBusy
            visible: enabled
            showItem: showItemAlways // do not collapse into sub-menu on Android
        }

        // add new habit
        IconButtonBarItem {
            icon: IconType.plus
            showItem: showItemAlways
            onClicked: {
                // use qsTr for strings you want to translate
                // var title = qsTr("New Habit")

                // this logic helper function creates a habit
                // logic.addHabit(title)
            }
        }
    }

    // when a habit is added, we open the detail page for it
    Connections {
        target: dataModel
        onHabitStored: {
            page.navigationStack.popAllExceptFirstAndPush(detailPageComponent, { habitId: habit.id })
        }
    }

    // JsonListModel
    // A ViewModel for JSON data that offers best integration and performance with list views
    JsonListModel {
        id: listModel
        source: dataModel.habits // show habits from data model
        keyField: "id"
        fields: ["id", "title", "description", "icon"]
    }

    // show sorted/filterd habits of data model
    AppListView {
        id: listView
        anchors.fill: parent

        // the model specifies the data for the list view
        model: listModel

        // the delegate is the template item for each entry of the list
        delegate: SimpleRow {
            text: model.title
            detailText: model.description
            iconSource: model.icon

            // push detail page when selected, pass chosen habit id
            onSelected: page.navigationStack.popAllExceptFirstAndPush(detailPageComponent,
                                                                      { habitId: model.id })
        }
    }

    // component for creating detail pages
    Component {
        id: detailPageComponent
        HabitDetailPage { }
    }
}
