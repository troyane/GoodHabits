pragma Singleton

import QtQuick 2.0

QtObject {
    // Constants used as field names
    readonly property string habitsDatabaseName: "GoodHabits"
    readonly property string recordsDatabaseName: "GoodHabitsRecords"

    readonly property string hHabits: "habits"
    readonly property string hHabitID: "id"
    readonly property string hHabitTitle: "title"
    readonly property string hHabitDescription: "description"
    readonly property string hHabitIcon: "icon"
    readonly property string hHabitDuration: "duration"
    readonly property string hHabitTime: "time"
    readonly property string hHabitDays: "days"
    readonly property string hHabitPrivate: "private"
    readonly property string hHabitNotifications: "notifications"

    readonly property string records: "records"
    readonly property string rRecordId: "id"
    readonly property string rRecordDate: "date"
    readonly property string rRecordHabit: "habit"
    readonly property string rRecordDuration: "duration"
    readonly property string rRecordTime: "time"

    // Predefined colors
    readonly property color alternateListItemColor1: "#f7f7f7"
    readonly property color alternateListItemColor2: "white"
    readonly property color attentionColor: "#FF5722" // deep orange for attention
    readonly property color okColor: "#ccff90" // light green for "it goes ok"

    // Default sizes
    readonly property int defaultPadding: 10
    readonly property int defaultSpacing: 5

    // Animations
    readonly property int animationDuration: 200

    // Default font sizes
    readonly property int fontSizeSmall: 10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeBig: 18

    // Settings names
    readonly property string habitsSorted: "habitsSorted"
    readonly property string showHabitsSearchBox: "showHabitsSearchBox"
    readonly property string showIdentifiers: "showIdentifiers"
}
