import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../components"

Page {
    id: importExportPage
    title: qsTr("Settings")

    GHScrollView {
        id: scrollView
        anchors.fill: parent

        ColumnLayout {
            width: importExportPage.width - 2*scrollView.padding

            AppCheckBox {
                id: showSearchBarCheckBox
                checked: app.getSettingsValueOrUseDefault(Constants.showHabitsSearchBox, true)
                text: qsTr("Show search bar on habits list")
                Layout.alignment: Qt.AlignHCenter
                onClicked:  app.settings.setValue(Constants.showHabitsSearchBox,
                                                  showSearchBarCheckBox.checked)
            }

            AppCheckBox {
                id: showIdentifiersCheckBox
                checked: app.getSettingsValueOrUseDefault(Constants.showIdentifiers, false)
                enabled: false
                text: qsTr("[debug] Show identifiers")
                Layout.alignment: Qt.AlignHCenter
                onClicked:  app.settings.setValue(Constants.showIdentifiers,
                                                  showIdentifiersCheckBox.checked)
            }
        }
    }
}
