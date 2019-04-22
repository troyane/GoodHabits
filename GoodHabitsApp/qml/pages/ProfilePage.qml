import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQml 2.11

import "../components"
import "../pages"

Page {
    id: profilePage
    title: qsTr("Profile")

    GHScrollView {
        id: scrollView
        anchors.fill: parent

        ColumnLayout {
            width: profilePage.width - 2*scrollView.padding

            GHPaper {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                ColumnLayout {
                    anchors.fill: parent

                    AppText {
                        fontSize: Constants.fontSizeBig
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Good Habits")
                    }

                    AppText {
                        fontSize: Constants.fontSizeNormal
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("version ...")
                    }

                    AppButton {
                        readonly property string siteUrl: "https://troyane.github.io/GoodHabits/"
                        text: siteUrl
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            nativeUtils.openUrl(siteUrl)
                        }
                    }
                }
            }

            AppButton {
                text: qsTr("Export/Import data we store...")
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    profilePage.navigationStack.popAllExceptFirstAndPush(importExportPage)
                }
            }

            AppButton {
                text: qsTr("Settings...")
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    profilePage.navigationStack.popAllExceptFirstAndPush(settingsPage)
                }
            }
        }
    }

    Component {
        id: importExportPage
        ImportExportPage { }
    }

    Component {
        id: settingsPage
        SettingsPage { }
    }
}
