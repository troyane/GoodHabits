import Felgo 3.0
import QtQuick 2.0

/// Component that displays time scale with time marks on it
Rectangle {
    // ...
    color: "transparent"
    property string startTime: "12:30" // just an example
    property double duration: 2.5

    onStartTimeChanged: _inside.calculate()
    onDurationChanged: _inside.calculate()

    Component.onCompleted: _inside.calculate()

    Item { // private item
        id: _inside
        property int startTimeInMinutes: 0
        property int endTimeInMinutes: 0
        property double startTimeInPercent: 0.0
        property double durationInPercent: 0.0
        property double endTimeInPercent: 0.0
        readonly property int totalTimeInMinutes: 24*60
        property bool over: false

        function calculate() {
            var split = startTime.split(":")
            // add checks
            var hours = parseInt(split[0], 10)
            var minutes = parseInt(split[1], 10)
            startTimeInMinutes = hours*60 + minutes

            var durationInMinutes = duration * 60
            endTimeInMinutes = startTimeInMinutes + durationInMinutes
            durationInPercent = durationInMinutes / totalTimeInMinutes

            startTimeInPercent = startTimeInMinutes / totalTimeInMinutes
            endTimeInPercent = endTimeInMinutes / totalTimeInMinutes

            if (endTimeInPercent > 1.0) {
                over = true
                endTimeInPercent = 1.0
            } else {
                over = false
            }
        }
    }

    Rectangle {
        id: axisLine
        width: parent.width
        height: dp(1)
        anchors.centerIn: parent
        color: Theme.colors.tintLightColor
    }

    Rectangle { // bullet
        id: bullet
        x: _inside.startTimeInPercent * parent.width
        width: _inside.durationInPercent * parent.width
        height: dp(5)
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.colors.tintColor
        border {
            color: Theme.colors.tintLightColor
            width: dp(1)
        }
        radius: dp(3)
    }

    AppText {
        id: startTimeLabel
        anchors {
            left: bullet.left
            top: parent.top
            topMargin: -startTimeLabel.height / 2
        }
        fontSize: Constants.fontSizeSmall
        text: startTime
    }

    AppText {
        anchors {
            left: axisLine.left
            leftMargin: dp(1)
            top: parent.top
            topMargin: -dp(5)
        }
        text: "00:00"
        fontSize: Constants.fontSizeTiny
    }

    AppText {
        anchors {
            right: axisLine.right
            rightMargin: dp(1)
            top: parent.top
            topMargin: -dp(5)
        }
        text: _inside.over ? ">" : "24:00"
        fontSize: Constants.fontSizeTiny
    }
}
