import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3

/** Component as a \c Rectangle for choosing icon from a grid of available icons.
  * \see IconType
  */
Rectangle {
    // Rectangle, since we do really want to cover all

    id: iconPicker

    /// Signal that emits as soon as user choose icon.
    /// @param string iconName Human-friendly icon name.
    /// @param string iconUtf Icon representation as UTF-8 symbol, e.g.: `\uf042` for `adjust` icon.
    signal iconChoosed(string iconName, string iconUtf)
    /// Signal that emits as user click "Cancel" button.
    signal canceled()

    /// Default backgound color
    color: Theme.backgroundColor

    // TODO: Add microanimations

    GHPaper {
        anchors {
            fill: parent
            margins: dp(Constants.defaultSpacing)
        }
        background.color: Theme.backgroundColor

        SortFilterProxyModel {
            id: filteredModel
            // Note: when using JsonListModel, the sorters or filter might not be applied correctly when directly assigning sourceModel
            // use the Component.onCompleted handler instead to initialize SortFilterProxyModel
            Component.onCompleted: sourceModel = IconTypeHelper.iconsModel
            filters: [
                RegExpFilter {
                    roleName: "iconText"
                    pattern: ".*" + searchBar.text
                    enabled: searchBar.text != ""
                    caseSensitivity: Qt.CaseInsensitive
                }]
        }

        Rectangle {
            anchors.fill: parent
            color: iconPicker.color

            ColumnLayout {
                anchors.fill: parent
                AppText {
                    text: qsTr("Find best icon:")
                    fontSize: Constants.fontSizeNormal
                    Layout.alignment: Qt.AlignHCenter
                }

                SearchBar {
                    id: searchBar
                    Layout.fillWidth: true
                }

                GHScrollView {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    GridView {
                        id: grid
                        delegate: Item {
                            id: delegate
                            width: grid.cellWidth
                            height: grid.cellHeight
                            Column {
                                anchors.fill: parent
                                IconButton {
                                    icon: iconUtf
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    onClicked: {
                                        console.log("Choosed: ", iconUtf, " which is ", iconText)
                                        iconChoosed(iconText, iconUtf)
                                    }
                                }
                                AppText {
                                    text: iconText
                                    fontSize: Constants.fontSizeSmall
                                    width: delegate.width - dp(Constants.defaultSpacing)
                                    elide: Text.ElideRight
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                        model: filteredModel
                    }
                }

                AppButton {
                    text: qsTr("Cancel")
                    Layout.fillWidth: true
                    onClicked: {
                        console.log("Canceled")
                        canceled()
                    }
                }
            }
        }
    }
}

