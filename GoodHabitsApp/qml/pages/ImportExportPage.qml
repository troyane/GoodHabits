import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../components"

Page {
    id: importExportPage
    title: qsTr("Import/Export")

    function notifyAboutExportResultSuccess(success, fileName) {
        if (success) {
            exportHabitsResult.text = qsTr("Stored to: ") + fileName
            exportHabitsResult.isWarning = false
        } else {
            nativeUtils.displayAlertDialog(qsTr("Exporting failed"),
                                           qsTr("Can't store to ") + fileName + ".")
            exportHabitsResult.text = qsTr("Can't store to: ") + fileName
            exportHabitsResult.isWarning = true
        }
        exportHabitsResult.needShow = true
    }

    GHScrollView {
        id: scrollView
        anchors.fill: parent

        ColumnLayout {
            width: importExportPage.width - 2*scrollView.padding

            AppButton {
                id: exportButton
                text: qsTr("Export My Good Habits to file")
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    var fileContentAsString = JSON.stringify(dataModel.habits)

                    // write <Documents>/Particles/newParticle.json
                    var fileName = fileUtils.storageLocation(FileUtils.DocumentsLocation, "GoodHabits/habits.json")
                    var success = fileUtils.writeFile(fileName, fileContentAsString)
                    notifyAboutExportResultSuccess(success, fileName)
                }
            }

            WarningPaper {
                id: exportHabitsResult
                needShow: false
                onClicked: needShow = false
            }

            AppButton {
                id: shareHabitsButton
                text: qsTr("Share My Good Habits (as JSON)")
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    var info = qsTr("All my Good Habits JSONified:\n")
                            + JSON.stringify(dataModel.habits)
                    nativeUtils.share(info, "")
                }
            }

            AppButton {
                id: importHabitsButton
                enabled: false
                text: qsTr("(in progress) Import My Good Habits (from JSON)")
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    importHabitsDialog.open()
                }
            }
        }
    }

    Dialog {
        id: importHabitsDialog
        title: qsTr("Put your habits JSON here:")
        positiveActionLabel: qsTr("Done")
        negativeActionLabel: qsTr("Cancel")
        onCanceled: {
            importHabitsText.text = ""
            close()
        }
        onAccepted: {
            if (importHabitsText.text == "") {
                close()
            } else {
                var input
                try {
                    input = JSON.parse(importHabitsText.text)
                }
                catch (error) {
                    nativeUtils.displayMessageBox(qsTr("Something wrong with this JSON"),
                                                  error, 1)
                  console.log(error);
                }
                console.log("Loaded Good Habits!", input)
            }
            close()
        }

        AppTextEdit {
            id: importHabitsText
            anchors.fill: parent
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }
}
