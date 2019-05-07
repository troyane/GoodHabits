pragma Singleton

import QtQuick 2.0

/**
 *  Lightweight object that stores all constants that could be used in application.
 */
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
    /// Predefined deep orange color for attention.
    readonly property color attentionColor: "#FF5722"
    /// Predefined light green color for "it goes Ok".
    readonly property color okColor: "#ccff90"

    // Default sizes
    /// Default component padding in pixels. Use in application with \c app.dp().
    readonly property int defaultPadding: 10
    /// Default spacing between components in pixels. Use in application with \c app.dp().
    readonly property int defaultSpacing: 5

    // Animations
    readonly property int animationDuration: 200

    // Default font sizes
    /// Default font size for timy text. Use in application as argument to \c AppText.fontSize
    readonly property int fontSizeTiny: 7
    /// Default font size for small text. Use in application as argument to \c AppText.fontSize
    readonly property int fontSizeSmall: 10
    /// Default font size for normal text. Should be used everywhere for easy readable text.
    /// Use in application as argument to \c AppText.fontSize.
    readonly property int fontSizeNormal: 14
    /// Default font size for big text. Should be used only for headers, etc.
    /// Use in application as argument to \c AppText.fontSize.
    readonly property int fontSizeBig: 18

    // Settings names
    readonly property string habitsSorted: "habitsSorted"
    readonly property string showHabitsSearchBox: "showHabitsSearchBox"
    readonly property string showIdentifiers: "showIdentifiers"
}
