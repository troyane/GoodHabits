import Felgo 3.0
import QtQuick 2.0

/// Simple \c AppPaper override for ease of use inside the application.
/// Component has predefined radius and could react to clicks.
AppPaper {
    id: paper
    /// Signal emits each time user clicks on it.
    signal clicked()

    radius: dp(Constants.defaultSpacing)
    clip: true

    MouseArea {
        anchors.fill: parent
        onClicked: paper.clicked()
    }
}
