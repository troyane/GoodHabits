import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../js/dateUtils.js" as DateUtils

Rectangle { // Rectangle, since we do really want to cover all
    id: recordDialog
    visible: false

    function show(hId, hName, hTypicalDuration, hStartTime) {
        habitId = hId
        habitName = hName
        habitDuration = hTypicalDuration
        habitStartTime = hStartTime
        recordDialog.visible = true
    }
    function hide() { recordDialog.visible = false }

    signal canceled()
    signal done()

    // TODO: Add microanimations

    property string habitId: ""
    property string habitName: ""
    property double habitDuration: 0.0
    property string habitStartTime: "09:00"

    property string todayText: qsTr("Today")
    property date choosedDate: new Date()

    HBPaper {
        anchors {
            fill: parent
            margins: dp(Constants.defaultSpacing)
        }
        background.color: Theme.backgroundColor


        Rectangle {
            anchors.fill: parent

            ColumnLayout {
                anchors.fill: parent
                AppText {
                    text: qsTr("Log your time on habit")
                    fontSize: Constants.fontSizeNormal
                    Layout.alignment: Qt.AlignHCenter
                }
                AppText {
                    text: habitName
                    fontSize: Constants.fontSizeNormal
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
                AppText {
                    text: habitId
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
                    Layout.fillWidth: true
                    text: recordDialog.todayText
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
                    value: 0.5
                    onValueChanged: habitDuration = value
                }
                AppText {
                    Layout.fillWidth: true
                    fontSize: Constants.fontSizeNormal
                    text: qsTr("... starting ")
                }

                AppTextInput {
                    id: habitTypicalTime
                    text: "09:00"
                    Layout.fillWidth: true
                    placeholderText: "00:00"
                    validator: RegExpValidator {
                        regExp: /^(0[0-9]|1[0-9]|2[0-3]|[0-9]):[0-5][0-9]$/
                    }
                    onTextChanged: habitStartTime = text
                }

                RowLayout {
                    Layout.fillWidth: true
                    AppButton {
                        text: qsTr("Cancel")
                        Layout.fillWidth: true
                        onClicked: {
                            console.log("Canceled")
                            canceled()
                            hide()
                        }
                    }
                    AppButton {
                        text: qsTr("Done!")
                        Layout.fillWidth: true
                        onClicked: {
                            console.log("Done clicked")
                            console.log(habitId, " ", habitName, " ", habitDuration, " ", habitStartTime)
                            done()
                            hide()
                        }
                    }
                }
            }
        }
    }
}

