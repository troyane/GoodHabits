import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2 as QQC
import QtQml 2.11

import "../components"
import "../pages"

Page {
    id: profilePage
    title: qsTr("Profile")

    QQC.ScrollView {
        id: scrollView
        padding: dp(Constants.defaultPadding)
        spacing: dp(Constants.defaultSpacing)
        anchors.fill: parent
        QQC.ScrollBar.horizontal.policy: QQC.ScrollBar.AlwaysOff
        QQC.ScrollBar.vertical.policy: QQC.ScrollBar.AsNeeded

        ColumnLayout {
            width: profilePage.width - 2*scrollView.padding

            AppPaper {
                radius: dp(Constants.defaultSpacing)
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
                text: qsTr("Export/Import all data we store")
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    profilePage.navigationStack.popAllExceptFirstAndPush(importExportPage)
                }
            }
        }
    }

    Component {
        id: importExportPage
        ImportExportPage { }
    }
}
