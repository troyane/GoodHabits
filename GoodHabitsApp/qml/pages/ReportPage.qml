import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../components"

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
            delegate: SimpleRow {
                style.backgroundColor: index % 2 == 0
                                       ? Theme.backgroundColor
                                       : Theme.secondaryBackgroundColor
                text: dataModel.getHabitTitleById(model.habit)
                detailText: model.time
                badgeValue: model.duration + "h"

                // TODO: Add range-slider-like element for visualization

                MouseArea {
                    anchors.fill: parent
                    propagateComposedEvents: true // just in case...
                    onClicked: {
                        console.log(JSON.stringify(model.id))
                        logic.loadRecordDetails(model.id)
                        reportPage.navigationStack.popAllExceptFirstAndPush(recPage)
                        mouse.accepted = true
                    }
                }
            }
            section.property: "date"
            section.delegate: SimpleSection {
                // TODO: provide visible delegate
                textItem.font.bold: true
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
