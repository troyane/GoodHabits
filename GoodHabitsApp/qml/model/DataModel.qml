import QtQuick 2.0
import Felgo 3.0

import "../components"

import "../js/jsonpath.js" as JP
import "../js/dateUtils.js" as DateUtils

Item {
    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    //
    property alias cache: cache
    property alias records: _.records

    // model data properties
    // all habits
    readonly property alias habits: _.habits
    // current habit
    readonly property alias habitDetails: _.habitDetails
    property alias recordDetails: _.recordDetails

    // action success signals
    signal habitStored(var habit)

    signal habitRemoved()

    // action error signals
    signal loadHabitsFailed(var error)
    signal storeHabitFailed(var habit, var error)

    function getHabitTitleById(uid) {
        if (uid == "")
            return ""
        var h = getHabitById(uid)
        if (h == false) return ""
        return h.title
    }

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

    function generateId() {
        return Math.random().toString(36).substring(2) + (new Date()).getTime().toString(36);
    }

    // TODO: Add documentation
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

    function saveAndUpdateHabits() {
        cache.setValue(Constants.hHabits, _.habits)
        habitsChanged()
        habitDetailsChanged()
    }

    function saveAndUpdateRecords() {
        cache.setValue(Constants.records, _.records)
        recordsChanged()
        recordDetailsChanged()
    }

    // listen to actions from dispatcher
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
            console.log("--- ASKED FOR: ", recordId)
            _.recordDetails = _.records.find(function(element){ return element.id === recordId })
            console.log("--- FOUND: ", JSON.stringify(_.recordDetails))
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
                title: "My new habit...",
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
            console.log("In addrecord:")
            console.log(JSON.stringify(draft))

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
    }

    // storage for caching
    Storage {
        id: cache
        databaseName: Constants.habitsDatabaseName
    }

//    Storage {
//        id: recordsStorage
//        databaseName: Constants.recordsDatabaseName
//    }

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
