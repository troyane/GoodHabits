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

    // action error signals
    signal loadHabitsFailed(var error)
    signal storeHabitFailed(var habit, var error)

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
                //console.log(JSON.stringify(cached["habits"]))
            } else {
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
            cache.setValue(Constants.hHabits, _.habits)
            habitsChanged()
            habitDetailsChanged()
        }

        // action 4 - clearCache
        onClearCache: {
            cache.clearAll()
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
