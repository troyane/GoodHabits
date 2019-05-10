import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../js/dateUtils.js" as DateUtils
import "../components"

/// Page that displays details on specific record. It gives ability to view and edit record.
Page {
    id: recordPage
    /// Currently loaded record
    property var currentRecord: dataModel.recordDetails
    /// Dynamically loaded habit name of currently loaded record
    readonly property string habitName: dataModel.getHabitTitleById(currentRecord.habit)
    property date choosedDate: new Date()

    /// Signal that emits as user click "Done" button
    signal done()

    function saveAll() {
        currentRecord[Constants.rRecordDate] = DateUtils.formatDateToString(choosedDate)
        currentRecord[Constants.rRecordDuration] = habitDurationSlider.value.toFixed(2)
        currentRecord[Constants.rRecordTime] = habitTypicalTime.text
        logic.storeRecords()
    }

    // TODO: Add microanimations

    Connections {
        target: dataModel
        onRecordRemoved: {
            recordPage.navigationStack.pop()
        }
    }

    GHPaper {
        height: parent.height
        width: parent.width
        anchors {
            margins: dp(Constants.defaultSpacing)
        }
        background.color: Theme.backgroundColor

        ColumnLayout {
            anchors {
                fill: parent
                margins: dp(Constants.defaultPadding)
            }
            AppText {
                text: habitName
                fontSize: Constants.fontSizeNormal
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            AppText {
                visible: false
                text: currentRecord.habit
                fontSize: Constants.fontSizeSmall
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Connections {
                target: nativeUtils
                onDatePickerFinished: {
                    choosedDate = accepted ? date : new Date()
                    dateButton.text = DateUtils.formatDateToString(choosedDate)
                }
            }

            AppButton {
                id: dateButton
                enabled: false
                Layout.fillWidth: true
                text: DateUtils.formatDateToString(choosedDate)
                onClicked: nativeUtils.displayDatePicker()
            }

            AppText {
                Layout.fillWidth: true
                fontSize: Constants.fontSizeNormal
                text: qsTr("I've spent ") + habitDurationSlider.value.toFixed(2) + " hours"
            }
            AppSlider {
                id: habitDurationSlider
                Layout.fillWidth: true
                from: 0.0
                to: 8.0
                value: currentRecord.duration
            }

            RowLayout {
                Layout.fillWidth: true

                AppText {
                    Layout.fillWidth: true
                    fontSize: Constants.fontSizeNormal
                    text: qsTr("... starting ")
                }

                GHTextInputTime {
                    id: habitTypicalTime
                    Layout.fillWidth: true
                    text: currentRecord.time
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }


            RowLayout {
                Layout.fillWidth: true
                Item { Layout.fillWidth: true }
                GHDeleteButton {
                    Layout.alignment: Qt.AlignRight
                    onClicked: logic.removeRecord(currentRecord.id)
                }
            }

            AppButton {
                text: qsTr("Done!")
                Layout.fillWidth: true
                onClicked: {
                    console.log("Done clicked")
                    saveAll()
                    recordPage.navigationStack.pop()
                }
            }
        }
    }
}

