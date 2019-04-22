import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls 2.2 as QQC

/// Simple \c ScrollView override with predefined \c padding, \c spacing and \c ScrollBar policies.
QQC.ScrollView {
    id: scrollView
    clip: true
    padding: dp(Constants.defaultPadding)
    spacing: dp(Constants.defaultSpacing)
    QQC.ScrollBar.horizontal.policy: QQC.ScrollBar.AlwaysOff
    QQC.ScrollBar.vertical.policy: QQC.ScrollBar.AsNeeded
}
