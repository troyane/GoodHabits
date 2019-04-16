import QtQuick 2.0
import Felgo 3.0

Item {
    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy

    // whether a user is logged in
    readonly property bool userLoggedIn: _.userLoggedIn

    // model data properties
    readonly property alias habits: _.habits
    readonly property alias habitDetails: _.habitDetails

    // action success signals
    signal habitStored(var habit)

    // action error signals
    signal fetchHabitsFailed(var error)
    signal fetchHabitDetailsFailed(int id, var error)
    signal storeHabitFailed(var habit, var error)

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        // action 1 - fetchHabits
        onFetchHabits: {
            // check cached value first
            var cached = cache.getValue("habits")
            if (cached) {
                _.habits = cached
            }

            // load from api
            api.getHabits(
                        function(data) {
                            // cache data before updating model property
                            cache.setValue("habits", data)
                            _.habits = data
                        },
                        function(error) {
                            // action failed if no cached data
                            if (!cached)
                                fetchhabitsFailed(error)
                        })
        }

        // action 2 - fetchHabitDetails
        onFetchHabitDetails: {
            // check cached habit details first
            var cached = cache.getValue("habit_" + id)
            if (cached) {
                _.habitDetails[id] = cached
                habitDetailsChanged() // signal change within model to update UI
            }

            // load from api
            api.getHabitById(id,
                            function(data) {
                                // cache data first
                                cache.setValue("habit_" + id, data)
                                _.habitDetails[id] = data
                                habitDetailsChanged()
                            },
                            function(error) {
                                // action failed if no cached data
                                if (!cached) {
                                    fetchhabitDetailsFailed(id, error)
                                }
                            })
        }

        // action 3 - storeHabit
        onStoreHabit: {
            // store with api
            api.addHabit(habit,
                        function(data) {
                            // NOTE: Dummy REST API always returns 201 as id of new habit
                            // To simulate a new habit, we set correct local id based on current model
                            data.id = _.habits.length + 1

                            // cache newly added item details
                            cache.setValue("habit_" + data.id, data)

                            // add new item to habits
                            _.habits.unshift(data)

                            // cache updated habit list
                            cache.setValue("habits", _.habits)
                            habitsChanged()

                            habitstored(data)
                        },
                        function(error) {
                            storeHabitFailed(habit, error)
                        })
        }

        // action 4 - clearCache
        onClearCache: {
            cache.clearAll()
        }

        // action 5 - login
        onLogin: _.userLoggedIn = true

        // action 6 - logout
        onLogout: _.userLoggedIn = false
    }

    // you can place getter functions here that do not modify the data
    // pages trigger write operations through logic signals only

    // rest api for data access
    RestAPI {
        id: api
        maxRequestTimeout: 3000 // use max request timeout of 3 sec
    }

    // storage for caching
    Storage {
        id: cache
    }

    // private
    Item {
        id: _

        // data properties
        property var habits: []  // Array
        property var habitDetails: ({}) // Map

        // auth
        property bool userLoggedIn: false
    }
}
