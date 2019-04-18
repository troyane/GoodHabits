import QtQuick 2.0

Item {
    // actions
    signal loadHabits()

    signal loadHabitDetails(string habitId)

    signal storeHabit(var habit)

    signal storeHabits()

    signal clearCache()

    // function to store a new habit
    function addHabit(title) {
        var draft = {
            id: "Z",
            title: title,
            description: "",
            icon: "",
            duration: "1.0",
            time: "09:00",
            days: "",
            private: false,
            notification: true,
        }
        storeHabit(draft)
    }
}
