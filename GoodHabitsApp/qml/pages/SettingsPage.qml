import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2 as QQC

import "../components"

Page {
    id: importExportPage
    title: qsTr("Settings")

    QQC.ScrollView {
        id: scrollView
        padding: dp(Constants.defaultPadding)
        spacing: dp(Constants.defaultSpacing)
        anchors.fill: parent
        QQC.ScrollBar.horizontal.policy: QQC.ScrollBar.AlwaysOff
        QQC.ScrollBar.vertical.policy: QQC.ScrollBar.AsNeeded

        ColumnLayout {
            width: importExportPage.width - 2*scrollView.padding

            AppCheckBox {
                id: showSearchBarCheckBox
                checked: app.getSettingsValueOrUseDefault(Constants.showHabitsSearchBox, true)
                text: qsTr("Show search bar on habits list")
                Layout.alignment: Qt.AlignHCenter
                onClicked:  app.settings.setValue(Constants.showHabitsSearchBox, checked)
            }
        }
    }
}
