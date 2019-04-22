import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../components"

Page {
    id: habitDetailPage
    // target id
    property string habitId: "0"
    // data property for page
    property var currentHabit: dataModel.habitDetails
    property bool locked: true
    backNavigationEnabled: locked

    function saveAll() {
        // Store changes
        currentHabit[Constants.hHabitTitle] = habitTitleText.text
        currentHabit[Constants.hHabitDescription] = habitDescriptionText.text
        currentHabit[Constants.hHabitIcon] = habitIconButton.iconName
        currentHabit[Constants.hHabitDuration] = habitDurationSlider.value
        currentHabit[Constants.hHabitTime] = habitTypicalTime.text
        currentHabit[Constants.hHabitDays] = daysPicker.getDays()
        currentHabit[Constants.hHabitPrivate] = habitPrivate.checked
        currentHabit[Constants.hHabitNotifications] = habitNotification.checked
        logic.storeHabits()
    }

    function toggleLocked() {
        habitDetailPage.locked = !habitDetailPage.locked
        if (habitDetailPage.locked) {
            saveAll()
        }
    }

    rightBarItem: NavigationBarRow {
        // edit habit
        IconButtonBarItem {
            icon: habitDetailPage.locked ? IconType.lock : IconType.unlock
            showItem: showItemAlways
            onClicked: {
                if (iconPicker.visible)
                    iconPicker.canceled()
                toggleLocked()
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

    // load data initially or when id changes
    onHabitIdChanged: {
        daysPicker.setDays(getHabitDataByName(Constants.hHabitDays))
    }

    width: parent.width

    GHScrollView {
        id: scrollView
        anchors.fill: parent
        ColumnLayout {
            width: habitDetailPage.width - 2*scrollView.padding

            WarningPaper {
                text: qsTr("Apply changes and lock it.")
                needShow: !habitDetailPage.locked
                onClicked: toggleLocked()
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: dp(Constants.defaultSpacing)
                AppText {
                    visible: false // app.getSettingsValueOrUseDefault(Constants.showIdentifiers, false)
                    fontSize: Constants.fontSizeSmall
                    text: qsTr("Identifier: ") + habitId
                }
            }
            RowLayout {
                Layout.fillWidth: true
                AppText { text: qsTr("Title:") }
                AppTextEdit {
                    id: habitTitleText
                    text: getHabitDataByName(Constants.hHabitTitle)
                    readOnly: habitDetailPage.locked
                    Layout.fillWidth: true
                }

                GHPaper {
                    width: habitIconButton.implicitWidth
                    height: habitIconButton.implicitHeight
                    IconButton {
                        id: habitIconButton
                        property string iconName: getHabitDataByName(Constants.hHabitIcon)
                        icon: IconType[iconName]
                        enabled: !habitDetailPage.locked

                        onClicked: {
                            iconPicker.visible = true
                        }
                    }
                }
            }
            AppText { text: qsTr("Description:"); Layout.fillWidth: true}
            AppTextEdit {
                id: habitDescriptionText
                text: getHabitDataByName(Constants.hHabitDescription)
                readOnly: habitDetailPage.locked
                wrapMode: TextEdit.WordWrap
                Layout.fillWidth: true
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

            RowLayout {
                Layout.fillWidth: true

                AppText { text: qsTr("Typical time:") }

                GHTextInputTime {
                    id: habitTypicalTime
                    text: getHabitDataByName(Constants.hHabitTime)
                    Layout.fillWidth: true
                    enabled: !habitDetailPage.locked
                }
            }

            AppText { text: qsTr("Typical days:") }

            DaysPicker {
                id: daysPicker
                Layout.fillWidth: true
                Layout.fillHeight: true
                enabled: !habitDetailPage.locked
            }

            AppCheckBox {
                id: habitPrivate
                text: qsTr("Private")
                visible: false // TODO: implement it as soon as sharing options will be available
                enabled: !habitDetailPage.locked
                checked: getHabitDataByName(Constants.hHabitPrivate)
            }
            AppCheckBox {
                id: habitNotification
                text: qsTr("Need notifications")
                visible: false // TODO: implement it as soon as local notifications will be available
                enabled: !habitDetailPage.locked
                checked: getHabitDataByName(Constants.hHabitNotifications)
            }

            RowLayout {
                Layout.fillWidth: true
                Item { Layout.fillWidth: true }
                GHDeleteButton {
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        logic.removeHabit(currentHabit.id)
                    }
                }
            }
        }
    }

    IconPicker {
        id: iconPicker
        anchors.fill: parent
        visible: false

        onCanceled: {
            iconPicker.visible = false
        }
        onIconChoosed: {
            habitIconButton.icon = iconUtf
            habitIconButton.iconName = iconName
            iconPicker.visible = false
        }
    }
}
