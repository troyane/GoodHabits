import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

// It is expected that WarningPaper will be layed out in *Layout.

GHPaper {
    id: editNote
    property alias text: appText.text
    property bool needShow
    property bool isWarning: true

    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    background.color: isWarning
                      ? Constants.attentionColor
                      : Constants.okColor
    AppText {
        id: appText
        width: parent.width
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        padding: dp(Constants.defaultSpacing)
    }

    states: [
        State {
            name: "invisible"
            when: !needShow
            PropertyChanges { target: editNote; Layout.preferredHeight: 0 }
        },
        State {
            name: "visible"
            when: needShow
            PropertyChanges { target: editNote; Layout.preferredHeight: appText.implicitHeight }
        }
    ]

    Behavior on Layout.preferredHeight { NumberAnimation { duration: Constants.animationDuration } }
}
