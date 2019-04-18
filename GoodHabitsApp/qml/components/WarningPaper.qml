import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

// It is expected that WarningPaper will be layed out in *Layout.

AppPaper {
    id: editNote
    property alias text: appText.text
    property bool isVisible
    radius: dp(Constants.defaultSpacing)
    background.color: Constants.attentionColor

    AppText {
        id: appText
        width: parent.width
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        padding: dp(Constants.defaultSpacing)
    }

    clip: true

    states: [
        State {
            name: "invisible"
            when: isVisible
            PropertyChanges { target: editNote; Layout.preferredHeight: 0 }
        },
        State {
            name: "visible"
            when: !isVisible
            PropertyChanges { target: editNote; Layout.preferredHeight: appText.implicitHeight }
        }
    ]

    Behavior on Layout.preferredHeight { NumberAnimation { duration: Constants.animationDuration } }
}
