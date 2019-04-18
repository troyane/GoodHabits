pragma Singleton

import QtQuick 2.0

QtObject {
    // Constants used as field names
    readonly property string habitsDatabaseName: "GoodHabits"
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

    // Predefined colors
    readonly property color alternateListItemColor1: "#f7f7f7"
    readonly property color alternateListItemColor2: "white"
    readonly property color attentionColor: "#FF5722" // deep orange for attention
}
