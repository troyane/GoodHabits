import QtQuick 2.0
import Felgo 3.0

import "../components"

import "../js/jsonpath.js" as JP


Item {
    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    //
    property alias cache: cache
    property alias records: recordsStorage

    // model data properties
    // all habits
    readonly property alias habits: _.habits
    // current habit
    readonly property alias habitDetails: _.habitDetails

    // action success signals
    signal habitStored(var habit)

    signal habitRemoved()

    // action error signals
    signal loadHabitsFailed(var error)
    signal storeHabitFailed(var habit, var error)

    function getHabitTitleById(uid) {
        // TODO: add checks
        var jpath = "$[?(@.id=='" + uid + "')]";
        var result = JP.jsonPath(dataModel.habits, jpath)
        return result[0].title
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

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        // action 1 - loadHabits
        onLoadHabits: {
            // check cached value first
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

        // action 2 - loadHabitDetails
        onLoadHabitDetails: {
            _.habitDetails = _.habits.find(function(element){ return element.id === habitId })
            console.log(JSON.stringify(_.habitDetails))
        }

        // action 3 - storeHabit
        onStoreHabits: {
            saveAndUpdateHabits()
        }

        // action 4 - clearCache
        onClearCache: {
            cache.clearAll()
        }

        onAddEmptyHabit: {
            var draft = {
                id: getUniqueId(_.habits),
                // TODO: Add randomizer for habit names (tunable via settings)
                title: "My new habit...",
                description: "",
                icon: "",
                duration: "1.0",
                time: "09:00",
                days: "",
                private: false,
                notification: true,
            }
            _.habits.push(draft)
            saveAndUpdateHabits()
            _.habitDetails = draft
            habitStored(draft)
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

    Storage {
        id: recordsStorage
        databaseName: Constants.recordsDatabaseName
    }

    // private
    Item {
        id: _
        // data properties
        property var habits: []  // Array
        property var habitDetails: ({}) // Map
    }
}
