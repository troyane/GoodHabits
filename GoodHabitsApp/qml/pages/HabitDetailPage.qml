import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2 as QQC

import "../components"

Page {
    id: habitDetailPage
    // target id
    property string habitId: "0"
    // data property for page
    property var currentHabit: dataModel.habitDetails
    property bool locked: true

    onPopped: {
        console.log("POPPED")
    }

    rightBarItem: NavigationBarRow {
        // edit habit
        IconButtonBarItem {
            icon: habitDetailPage.locked ? IconType.lock : IconType.unlock
            showItem: showItemAlways
            onClicked: {
                habitDetailPage.locked = !habitDetailPage.locked
                if (habitDetailPage.locked) {
                    // Store changes
                    currentHabit[Constants.hHabitDuration] = habitDurationSlider.value
                    logic.storeHabits()
                    backNavigationEnabled = true
                    editNote.visible = false
                } else {
                    // unlocked, so no way to go back
                    backNavigationEnabled = false
                    editNote.visible = true
                }
            }
        }
    }

    title: getHabitDataByName(Constants.hHabitTitle)
    function getHabitDataByName(fieldName) {
        if (!currentHabit) {
            return ""
        }

        var field = currentHabit[fieldName]
        return field ? field : ""
    }

    onCurrentHabitChanged: {

    }

    // load data initially or when id changes
    onHabitIdChanged: {
//        console.log(JSON.stringify(currentHabit))
    }

    width: parent.width

    QQC.ScrollView {
        id: scrollView
        padding: 10
        spacing: 10
        anchors.fill: parent
        QQC.ScrollBar.horizontal.policy: QQC.ScrollBar.AlwaysOff
        QQC.ScrollBar.vertical.policy: QQC.ScrollBar.AsNeeded

        // TODO: Prepare separate components

        // TODO: Prepare helper functions

        ColumnLayout {
            width: habitDetailPage.width - 2*scrollView.padding
            height: habitDetailPage.height - 2*scrollView.padding

            AppPaper {
                id: editNote
                // TODO: Add animation on appearance
                visible: false
                Layout.fillWidth: true
                height: appText.height
                radius: dp(5)
                background.color: Constants.attentionColor

                AppText {
                    id: appText
                    width: parent.width
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter

                    padding: dp(10)
                    text: qsTr("Apply changes and lock it.")
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: dp(10)
                AppText {
                    fontSize: 12
                    text: qsTr("ID:")
                }
                AppTextEdit {
                    id: habitIdText
                    fontSize: 12
                    text: habitId
                    readOnly: true
                }
            }
            RowLayout {
                Layout.fillWidth: true
                AppText { text: qsTr("Title:") }
                AppTextEdit {
                    id: habitTitleText
                    text: getHabitDataByName(Constants.hHabitTitle)
                    readOnly: !habitDetailPage.locked
                }
            }
            AppText { text: qsTr("Description:"); Layout.fillWidth: true}
            AppTextEdit {
                id: habitDescriptionText
                text: getHabitDataByName(Constants.hHabitDescription)
                readOnly: !habitDetailPage.locked
                wrapMode: TextEdit.WordWrap
                Layout.fillWidth: true
            }
            RowLayout {
                Layout.fillWidth: true
                AppText { text: qsTr("Icon:") }
                IconButton {
                    icon: getHabitDataByName(Constants.hHabitIcon)
                    enabled: !habitDetailPage.locked
                }
            }
            AppText {
                Layout.fillWidth: true
                text: qsTr("Typical duration (") + habitDurationSlider.value.toFixed(2) + "h)"
            }
            AppSlider {
                id: habitDurationSlider
                Layout.fillWidth: true
                from: 0.0
                to: 8.0
                value: getHabitDataByName(Constants.hHabitDuration)
                enabled: !habitDetailPage.locked
            }

            AppText { text: qsTr("Typical time:") }
            AppTextInput {
                id: habitTypicalTime
                text: getHabitDataByName(Constants.hHabitTime)
                Layout.fillWidth: true
                enabled: !habitDetailPage.locked
            }

            AppText { text: qsTr("Typical days:") }

            AppCheckBox {
                id: habitDayMonday
                text: qsTr("Monday")
                enabled: !habitDetailPage.locked
            }
            AppCheckBox {
                id: habitDayTuesday
                text: qsTr("Tuesday")
                enabled: !habitDetailPage.locked
            }
            AppCheckBox {
                id: habitDayWednesday
                text: qsTr("Wednesday")
                enabled: !habitDetailPage.locked
            }
            AppCheckBox {
                id: habitDayThursday
                text: qsTr("Thursday")
                enabled: !habitDetailPage.locked
            }
            AppCheckBox {
                id: habitDayFriday
                text: qsTr("Friday")
                enabled: !habitDetailPage.locked
            }
            AppCheckBox {
                id: habitDaySaturday
                text: qsTr("Saturday")
                enabled: !habitDetailPage.locked
            }
            AppCheckBox {
                id: habitDaySunday
                text: qsTr("Sunday")
                enabled: !habitDetailPage.locked
            }

            AppCheckBox {
                id: habitPrivate
                text: qsTr("Private")
                enabled: !habitDetailPage.locked
                checked: getHabitDataByName(Constants.hHabitPrivate)
            }
            AppCheckBox {
                id: habitNotification
                text: qsTr("Need notifications")
                enabled: !habitDetailPage.locked
                checked: getHabitDataByName(Constants.hHabitNotifications)
            }

            Item { // spacer
                Layout.fillHeight: true
            }
        }

    }
}
