import QtQuick 2.0

Item {
    // actions
    signal loadHabits()
    signal loadRecords()

    signal importHabits(var habits)

    signal loadHabitDetails(string habitId)
    signal loadRecordDetails(string recordId)

    signal storeHabit(var habit)

    signal storeHabits()
    signal storeRecords()

    signal clearCache()

    signal addEmptyHabit()
    signal addRecord(string habitId)

    signal removeHabit(string habitId)
}
