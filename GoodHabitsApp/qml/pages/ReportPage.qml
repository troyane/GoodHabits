import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../components"
import "../js/dateUtils.js" as DateUtils

/// Page that display list of user's records.
Page {
    id: reportPage
    title: qsTr("Report")

    // list model for json data
    JsonListModel {
        id: jsonModel
        source: dataModel.records
        keyField: "id"
        fields: ["id", "date", "habit", "duration", "time"]
    }

    function applySettings() {
        console.log("Apply Settings in ReportPage")
    }

    // SortFilterProxyModel for sorting or filtering lists
    SortFilterProxyModel {
        id: sortedModel
        // Note: when using JsonListModel, the sorters or filter might not be applied correctly when directly assigning sourceModel
        // use the Component.onCompleted handler instead to initialize SortFilterProxyModel
        Component.onCompleted: sourceModel = jsonModel
        sorters: StringSorter { id: typeSorter; roleName: "date"; ascendingOrder: false }
    }

    ColumnLayout {
        height: parent.height
        width: parent.width
        AppListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: sortedModel
            delegate: ReportItemDelegate {
                height: dp(60)
                width: parent.width
                icon: IconType[dataModel.getHabitById(model.habit).icon]
                text: dataModel.getHabitTitleById(model.habit)
                duration: model.duration
                time: model.time

                onSelected: {
                    // console.log(JSON.stringify(model.id))
                    logic.loadRecordDetails(model.id)
                    reportPage.navigationStack.popAllExceptFirstAndPush(recPage,
                                                                        { choosedDate: model.date } )
                }
            }
            section.property: "date"
            section.delegate: SimpleSection {
                title: DateUtils.formatDateToStringFancy(section)
                style: ReportSectionStyleDelegate { }
            }
        }
    }

    Component {
        id: recPage
        RecordPage {
            id: recordPage
            title: qsTr("Logged time on")
            visible: false
        }
    }
}
