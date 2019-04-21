import Felgo 3.0
import QtQuick 2.0

AppPaper {
    id: hbPaper
    signal clicked()

    radius: dp(Constants.defaultSpacing)
    clip: true

    MouseArea {
        anchors.fill: parent
        onClicked: hbPaper.clicked()
    }
}
