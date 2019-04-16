import Felgo 3.0
import QtQuick 2.0

Page {
    id: habitDetailPage
    title: !!habitsData ? habitsData.title : ""

    // network activity indicator
    rightBarItem: ActivityIndicatorBarItem {
        id: activityBarItem
        visible: dataModel.isBusy && !dataModel.isStoringhabits
        showItem: showItemAlways // do not collapse into sub-menu on Android
    }

    // target id
    property int habitId: 0

    // data property for page
    property var habitsData: dataModel.habitDetails[habitId]

    // load data initially or when id changes
    onHabitIdChanged: {
        logic.fetchHabitDetails(habitId)
    }

    // column to show all habit object properties, if data is available
    Column {
        y: spacing
        width: parent.width - 2 * spacing
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: dp(Theme.navigationBar.defaultBarItemPadding)
        visible: !noDataMessage.visible

        // Repeater creates copies of given item based on configured model data
        Repeater {
            enabled: parent.visible
            model: !!habitsData ? Object.keys(habitsData) : undefined

            // Text Item to show each property - value pair
            AppText {
                property string propName: modelData
                property string value: habitsData[propName]

                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: implicitHeight

                text: "<strong>"+propName+":</strong> "+value
                wrapMode: AppText.WrapAtWordBoundaryOrAnywhere
            }
        }
    }

    // show message if data not available
    AppText {
        id: noDataMessage
        anchors.verticalCenter: parent.verticalCenter
        text: qsTr("Habit data not available. Please check your internet connection.")
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
        visible: !habitsData && !dataModel.isBusy
    }
}
