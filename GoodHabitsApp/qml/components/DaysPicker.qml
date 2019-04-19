import Felgo 3.0
import QtQuick 2.0

Grid {
    id: daysPicker

    readonly property string dayMonday:    qsTr("Mon")
    readonly property string dayTuesday:   qsTr("Tue")
    readonly property string dayWednesday: qsTr("Wed")
    readonly property string dayThursday:  qsTr("Thu")
    readonly property string dayFriday:    qsTr("Fri")
    readonly property string daySaturday:  qsTr("Sat")
    readonly property string daySunday:    qsTr("Sun")

    function getDays() {
        var result = ""
        result += habitDayMonday.checked    ? dayMonday    + "," : ""
        result += habitDayTuesday.checked   ? dayTuesday   + "," : ""
        result += habitDayWednesday.checked ? dayWednesday + "," : ""
        result += habitDayThursday.checked  ? dayThursday  + "," : ""
        result += habitDayFriday.checked    ? dayFriday    + "," : ""
        result += habitDaySaturday.checked  ? daySaturday  + "," : ""
        result += habitDaySunday.checked    ? daySunday    + "," : ""
        return result
    }

    function uncheckAll() {
        console.log("Uncheck all")
        for (var i = 0; i < daysPicker.children.length; ++i) {
            // TODO: Add checks if component is checkable
            daysPicker.children[i].checked = false
        }
    }

    function setDays(fromString) {
        uncheckAll()
        if (fromString == "") {
            console.log("No days specified")
            return
        }

        var days = fromString.split(",")
        if (days.length > 7) {
            console.warn("Something strange happenning")
        }
        for (var i = 0; i < days.length; ++i) {
            console.log("Day ", days[i])
            switch (days[i]) {
            case dayMonday: habitDayMonday.checked = true; break;
            case dayTuesday: habitDayTuesday.checked = true; break;
            case dayWednesday: habitDayWednesday.checked = true; break;
            case dayThursday: habitDayThursday.checked = true; break;
            case dayFriday: habitDayFriday.checked = true; break;
            case daySaturday: habitDaySaturday.checked = true; break;
            case daySunday : habitDaySunday .checked = true; break;
            }
        }
    }

    spacing: dp(Constants.defaultSpacing)
    AppCheckBox {
        id: habitDayMonday
        text: dayMonday
    }
    AppCheckBox {
        id: habitDayTuesday
        text: dayTuesday
    }
    AppCheckBox {
        id: habitDayWednesday
        text: dayWednesday
    }
    AppCheckBox {
        id: habitDayThursday
        text: dayThursday
    }
    AppCheckBox {
        id: habitDayFriday
        text: dayFriday
    }

    // TODO: Emphasize weekdays
    AppCheckBox {
        id: habitDaySaturday
        text: daySaturday
    }
    AppCheckBox {
        id: habitDaySunday
        text: daySunday
    }
}
