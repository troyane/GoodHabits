import Felgo 3.0 as Felgo
import QtQuick 2.0
import QtQuick.Layouts 1.3

/// 
Item {
    id: delegate
    property string icon
    property string text
    property double duration
    property string time

    signal selected()

    Item {
        anchors {
            fill: parent
        }

        RowLayout {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: dp(Constants.defaultSpacing)
            }
            height: parent.height * 0.7

            Felgo.Icon {
                icon: delegate.icon
            }
            Felgo.AppText {
                text: delegate.text
                fontSize: Constants.fontSizeNormal
                font.bold: true
            }
            Felgo.AppText {
                text: qsTr(" for ") + delegate.duration.toFixed(2) + qsTr("h")
                fontSize: Constants.fontSizeNormal
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        anchors.right: parent.right

        TimeScale {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: parent.height * 0.3
            startTime: delegate.time
            duration: delegate.duration
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: delegate.selected()
    }
}
