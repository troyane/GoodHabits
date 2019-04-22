import QtQuick 2.0

/// Signals-only component that trigers signals related to data manipulations.
/// Signals-approach gives us flexibility. In case we switch to WebStorage, logic
/// will remain the same.
Item {
    /// Signal to load \c DataModel.habits.
    signal loadHabits()
    /// Signal to load \c DataModel.records.
    signal loadRecords()

    /// Signal to import \c DataModel.habits. Replace it by list given as argument.
    /// @param var habits list of habits (JSON object), see structure in ...
    signal importHabits(var habits)

    /// Signal to load \c DataModel.habitDetails by given \c habitId
    /// @param string habitId Unique identifier of habit.
    signal loadHabitDetails(string habitId)
    /// Signal to load \c DataModel.recordDetails by given \c recordId
    /// @param string recordId Unique identifier of record.
    signal loadRecordDetails(string recordId)

    /// Signal to permanently store habits.
    signal storeHabits()
    /// Signal to permanently store records.
    signal storeRecords()

    /// Signal to append new empty habit. E.g. Triggered on "+" click.
    signal addEmptyHabit()
    /// Signal to create and append new record object "linked" to habit id.
    /// @param string habitId Unique identifier of habit.
    signal addRecord(string habitId)

    /// Signal to permanently remove habit by given \c habitId.
    /// @param string habitId Unique identifier of habit.
    signal removeHabit(string habitId)
    /// Signal to permanently remove record by given \c recordId.
    /// @param string recordId Unique identifier of record.
    signal removeRecord(string recordId)
    /// Signal to clear all application cache.
    signal clearCache()
}
