import QtQuick 2.0

Item {

    // actions
    signal fetchHabits()

    signal fetchHabitDetails(int id)

    signal fetchDraftHabits()

    signal storeHabit(var habit)

    signal clearCache()

    signal login(string username, string password)

    signal logout()

    // function to store a new habit
    function addHabit(title) {
        var draft = {
            completed: false,
            title: title,
            userId: 1,
        }

        storeHabit(draft)
    }

}
