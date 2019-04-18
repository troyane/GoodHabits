import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../components"

Page {
    id: page
    title: qsTr("Habits list")

    onPopped: {
        console.log("On popped")
    }

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
                                                          { habitId: habit.id, locked: false})
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
        fields: ["id", "title", "description", "icon"]
    }

    property bool sortByTitleActive: true
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
              roleName: "title"
              enabled: sortByTitleActive
            }]
    }


    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            SearchBar {
                id: searchBar
                Layout.fillWidth: true
            }
            IconButton {
                icon: sortByTitleActive ? IconType.arrowdown : IconType.arrowup
                onClicked: sortByTitleActive = !sortByTitleActive
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
            delegate: SimpleRow {
                style.backgroundColor: index % 2 == 0
                                       ? Constants.alternateListItemColor1
                                       : Constants.alternateListItemColor2
                text: model.title
                detailText: model.description
                iconSource: model.icon

                // push detail page when selected, pass chosen habit id
                onSelected: {
                    console.log("# Selected ", model.id)
                    logic.loadHabitDetails(model.id)
                    page.navigationStack.popAllExceptFirstAndPush(detailPageComponent,
                                                                  { habitId: model.id })
                }
            }
        }
    }

    // component for creating detail pages
    Component {
        id: detailPageComponent
        HabitDetailPage { }
    }
}
