import QtQuick 2.0
import Felgo 3.0

import "../components"

import "../js/jsonpath.js" as JP
import "../js/dateUtils.js" as DateUtils

/// Data access object. Component do read/write access to storage and holds in memory
/// all data required for application.
/// \note In future this component could be adapted to work with \c WebStorage.
Item {
    /// Property to configure target dispatcher / logic. \see \c Logic
    property alias dispatcher: logicConnection.target

    /// Main cache component
    property alias cache: cache
    /// Loaded in-memory records
    property alias records: _.records
    /// Loaded in-memory habits
    readonly property alias habits: _.habits
    /// Component for ease of usage, loaded in-memory habit
    readonly property alias habitDetails: _.habitDetails
    /// Component for ease of usage, loaded in-memory record
    property alias recordDetails: _.recordDetails

    /// Signal emited as habit stored.
    /// @param var habit JSON-onject of stored habit.
    signal habitStored(var habit)

    /// Signal emited as habit removed.
    signal habitRemoved()
    /// Signal emited as record removed.
    signal recordRemoved()

    /**
     * Function that returns title of habit by given id.
     * @param type:string uid identifier of habit
     * @return type:string containing title atribute of given habit if any, otherwise empty string.
     */
    function getHabitTitleById(uid) {
        if (uid == "")
            return ""
        var h = getHabitById(uid)
        if (h == false) return ""
        return h.title
    }

    /**
     * Helper function that returns habit by given id.
     * @param type:string uid identifier of habit
     * @return type:var JSON-object containing given habit.
     * \note this method uses JSONPath.
     */
    function getHabitById(uid) {
        // TODO: add checks
        var jpath = "$[?(@.id=='" + uid + "')]";
        var result = JP.jsonPath(dataModel.habits, jpath)
        if (result == false) {
            return ""
        } else {
            return result[0]
        }
    }

    /**
      * Function returns random id based on random and on time.
      * Simple and light implementation UUID.
      * @return type:string containing random uid.
      */
    function generateId() {
        return Math.random().toString(36).substring(2) + (new Date()).getTime().toString(36);
    }

    /**
      * Function generate unique id using \c generateId. Then iterate over given \c array to ensure that generated
      * id is unique. If so, returns it, otherwise generate new and repeat procedure until generated id will be
      * unique.
      * @param type:var JSON-array of elements with attribute `id`.
      * @return type:string containing random unique (on \c array) uid.
      */
    function getUniqueId(array) {
        var needToRegenerate = false
        do {
            var possibleUnique = generateId();
            for (var i = 0; i < array.length; ++i) {
                if (array[i].id == possibleUnique) {
                    needToRegenerate = true;
                    break;
                }
            }
        } while (needToRegenerate)
        return possibleUnique;
    }

    /**
      * Store habits permanently and notify views by sending respective signals.
      */
    function saveAndUpdateHabits() {
        cache.setValue(Constants.hHabits, _.habits)
        habitsChanged()
        habitDetailsChanged()
    }

    /**
      * Store records permanently and notify views by sending respective signals.
      */
    function saveAndUpdateRecords() {
        cache.setValue(Constants.records, _.records)
        recordsChanged()
        recordDetailsChanged()
    }

    // Listen to actions from dispatcher
    Connections {
        id: logicConnection

        onLoadHabits: {
            console.log("Going to load habits...")
            var cached = cache.getValue(Constants.hHabits)
            // console.log(JSON.stringify(cached))

            if (cached) {
                _.habits = cached
                //console.log(JSON.stringify(cached["habits"]))
            } else {
                console.log("Can't find any")
                nativeUtils.displayMessageBox(qsTr("Can't find any cached habits!"),
                                              qsTr("Looks like you run this application for first time."), 1)
            }
        }

        onLoadRecords: {
            console.log("Going to load records...")
            var cached = cache.getValue(Constants.records)

            if (cached) {
                _.records = cached
            } else {
                console.log("Can't find any")
                nativeUtils.displayMessageBox(qsTr("Can't find any cached records!"),
                                              qsTr("Looks like you run this application for first time."), 1)
            }
        }

        onImportHabits: {
            if (habits) {
                _.habits = habits
                saveAndUpdateHabits()
            } else {
                // TODO: Add checks
                nativeUtils.displayMessageBox(qsTr("Can't import any habits!"),
                                              qsTr("Something strange hapenning."), 1)

            }
        }

        onLoadHabitDetails: {
            _.habitDetails = _.habits.find(function(element){ return element.id === habitId })
            console.log(JSON.stringify(_.habitDetails))
        }

        onLoadRecordDetails: {
            _.recordDetails = _.records.find(function(element){ return element.id === recordId })
        }

        onStoreHabits: {
            saveAndUpdateHabits()
        }

        onStoreRecords: {
            saveAndUpdateRecords()
        }

        onClearCache: {
            cache.clearAll()
        }

        onAddEmptyHabit: {
            var draft = {
                id: getUniqueId(_.habits),
                // TODO: Add randomizer for habit names (tunable via settings)
                title: qsTr("My new habit..."),
                description: "",
                icon: "bed",
                duration: "1.0",
                time: "09:00",
                days: "Mon",
                private: false,
                notification: true,
            }
            _.habits.push(draft)
            saveAndUpdateHabits()
            _.habitDetails = draft
            habitStored(draft)
        }

        onAddRecord: {
            var habit = getHabitById(habitId)
            var draft = {
                id: getUniqueId(_.records),
                date: DateUtils.getCurrentDate(),
                habit: habitId,
                duration: habit.duration,
                time: habit.time
            }
            _.records.push(draft)
            saveAndUpdateRecords()
            _.recordDetails = draft
        }

        onRemoveHabit: {
            for (var i = _.habits.length - 1; i >= 0; --i) {
                if (_.habits[i].id == habitId) {
                    _.habits.splice(i, 1)
                }
            }
            saveAndUpdateHabits()
            habitRemoved()
        }

        onRemoveRecord: {
            for (var i = _.records.length - 1; i >= 0; --i) {
                if (_.records[i].id == recordId) {
                    _.records.splice(i, 1)
                }
            }
            saveAndUpdateRecords()
            recordRemoved()
        }
    }

    // storage for caching
    Storage {
        id: cache
        databaseName: Constants.habitsDatabaseName
    }

    // private
    Item {
        id: _
        // data properties
        property var habits: []  // Array
        property var habitDetails: ({}) // Map
        property var records: [] // Array
        property var recordDetails: ({}) // Map
    }
}
