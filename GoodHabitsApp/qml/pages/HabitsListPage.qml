import Felgo 3.0
import QtQuick 2.3
import QtQuick.Layouts 1.3

import "../components"

/// Page for displaing a list of habits.
/// Have several tunables: \c sortAscByTitle and \c showSearchBox
Page {
    id: page
    title: qsTr("Habits list")
    /// Variable that reflects sort by title strategy (asc/desc)
    property bool sortAscByTitle
    /// Variable that reflects weather we need to show search box
    property bool showSearchBox: true

    function applySettings() {
        console.log("In apply")
        sortAscByTitle = app.getSettingsValueOrUseDefault(Constants.habitsSorted, true)
        showSearchBox = app.getSettingsValueOrUseDefault(Constants.showHabitsSearchBox, true)
    }

    function logTimeOnSelectedHabit(habitId) {
        logic.addRecord(habitId)
        navigationStack.popAllExceptFirstAndPush(recPage)
    }

    function editSelectedHabit(curHabitId) {
        logic.loadHabitDetails(curHabitId)
        navigationStack.popAllExceptFirstAndPush(detailPageComponent,
                                                      { habitId: curHabitId })
    }

    function toggleSortByTitle() {
        sortAscByTitle = !sortAscByTitle
        app.settings.setValue(Constants.habitsSorted, sortAscByTitle)
    }

    onAppeared: {
        applySettings()
    }

    Component.onCompleted: {
        applySettings()
    }

    backgroundColor: Theme.backgroundColor

    rightBarItem: NavigationBarRow {
        // add new habit
        IconButtonBarItem {
            icon: IconType.plus
            showItem: showItemAlways
            onClicked: {
                logic.addEmptyHabit()
            }
        }
    }

    // when a habit is added, we open the detail page for it unlocked
    Connections {
        target: dataModel
        onHabitStored: {
            page.navigationStack.popAllExceptFirstAndPush(detailPageComponent,
                                                          { habitId: habit.id, locked: false })
        }
        onHabitRemoved: {
            page.navigationStack.popAllExceptFirst()
        }
    }

    // JsonListModel
    // A ViewModel for JSON data that offers best integration and performance with list views
    JsonListModel {
        id: listModel
        source: dataModel.habits // show habits from data model
        keyField: "id"
        fields: ["id", "title", "description", "icon", "duration", "time"]
    }

    SortFilterProxyModel {
        id: filteredModel
        sourceModel: listModel
        filters: [
            RegExpFilter {
                roleName: "title"
                pattern: ".*" + searchBar.text
                enabled: searchBar.text != ""
                caseSensitivity: Qt.CaseInsensitive
            }]
        sorters: [
            StringSorter {
                id: sorter
                roleName: "title"
                enabled: true
                sortOrder: sortAscByTitle ? Qt.AscendingOrder : Qt.DescendingOrder
            }]
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            SearchBar {
                id: searchBar
                visible: showSearchBox
                Layout.fillWidth: true
                barBackgroundColor: Theme.backgroundColor
            }
            IconButton {
                icon: sortAscByTitle ? IconType.arrowdown : IconType.arrowup
                onClicked: toggleSortByTitle()
            }
        }

        // show sorted/filterd habits of data model
        AppListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            // the model specifies the data for the list view
            model: filteredModel

            // the delegate is the template item for each entry of the list
            delegate: SwipeOptionsContainer {
                id: container

                leftOption: SwipeButton {
                    text: qsTr("Edit")
                    icon: IconType.pencil
                    height: row.height
                    onClicked: {
                        editSelectedHabit(model.id)
                        container.hideOptions()
                    }
                }

                SimpleRow {
                    id: row
                    style.backgroundColor: index % 2 == 0
                                           ? Theme.backgroundColor
                                           : Theme.secondaryBackgroundColor
                    text: model.title
                    detailText: model.description
                    iconSource: IconType[model.icon]

                    MouseArea {
                        anchors.fill: parent
                        propagateComposedEvents: true // just in case...
                        onClicked: {
                            logTimeOnSelectedHabit(model.id)
                            mouse.accepted = true
                        }
                    }
                }
            }
        }
    }

    // component for creating detail pages
    Component {
        id: detailPageComponent
        HabitDetailPage { }
    }

    Component {
        id: recPage
        RecordPage {
            id: recordPage
            title: qsTr("Log your time on habit")
        }
    }
}
