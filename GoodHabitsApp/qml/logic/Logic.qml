import QtQuick 2.0

Item {
    // actions
    signal loadHabits()

    signal importHabits(var habits)

    signal loadHabitDetails(string habitId)

    signal storeHabit(var habit)

    signal storeHabits()

    signal clearCache()

    signal addEmptyHabit()

    signal removeHabit(string habitId)
}
