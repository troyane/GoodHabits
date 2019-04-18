import QtQuick 2.0
import Felgo 3.0

import "../components"

Item {
    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    //
    property alias cache: cache

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
            console.log(JSON.stringify(cached))

            if (cached) {
                _.habits = cached
                getUniqueId(cached)
                //console.log(JSON.stringify(cached["habits"]))
            } else {
                // TODO: Add Warning dialog
                console.log("Can't find any")
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

    // private
    Item {
        id: _
        // data properties
        property var habits: []  // Array
        property var habitDetails: ({}) // Map
    }
}
