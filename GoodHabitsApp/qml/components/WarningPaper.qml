import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

/// Simple GHPaper override for any in-place message boxes.
/// Appearance and dissappearance of this box will be animated.
/// \warning It is expected that WarningPaper will be layed out in *Layout.

GHPaper {
    id: editNote
    /// Message text that will be placed inside Paper.
    property alias text: appText.text
    /// Property that should be set to `true` in case if this component need to be shown. Otherwise, `false`.
    /// \note Default value is `false`
    property bool needShow: false
    /// Property to reflect if this message is warning. If it is warning it will have \c Constants.attentionColor
    /// background. Otherwise, \c Constants.okColor. \note Default value is `true`.
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
