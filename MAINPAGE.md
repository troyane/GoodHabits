# GoodHabits application

## Felgo features and/or components

* [`App`](https://felgo.com/doc/felgo-app/) -- as main application instance. It provides lots of useful properties, like `tablet` -- to check if it is tablet mode, `settings` for persistent settings storage, values for work with pixel density on different screens etc.
* **For application structure and navigation:**
  * [`Navigation`](https://felgo.com/doc/felgo-navigation/) -- as a native look and feel navigation control. Respectively:
  * [`NavigationItem`](https://felgo.com/doc/felgo-navigationitem/) -- as a base type for items inside `Navigation`.
  * [`NavigationStack`](https://felgo.com/doc/felgo-navigationstack/) -- as a stack of `Pages` with navigation.
  * [`Page`](https://felgo.com/doc/felgo-page/) -- container for the contents of a single page, designed to be used together with components like `Navigation` or `NavigationStack` to provide a native-looking UI and user experience.
* **As Native-looking controls:**
  * [`AppCheckBox`](https://felgo.com/doc/felgo-appcheckbox/) -- widely used as native component "check box".
  * [`AppListView`](https://felgo.com/doc/felgo-applistview/) -- as a native-looking view with scroll indicator.
  * [`AppText`](https://felgo.com/doc/felgo-apptext/) -- a styled text control.
  * [`AppButton`](https://felgo.com/doc/felgo-appbutton/) -- native-looking button.
  * [`AppSlider`](https://felgo.com/doc/felgo-appslider/) -- native-looking slider with one handle.
  * [`Dialog`](https://felgo.com/doc/felgo-dialog/) -- dialog with custom content and one or two buttons.
  
  
* **For data manipulations:**
  * [`JsonListModel`](https://felgo.com/doc/felgo-jsonlistmodel/) -- very easy to use proxy view model for JSON data sources.
  * [`SortFilterProxyModel`](https://felgo.com/doc/felgo-sortfilterproxymodel/) -- sort and/or filter proxy model to apply filter and/or sorting settings to QML ListModel items.
  * [`Storage`](https://felgo.com/doc/felgo-storage/) -- for persistent and offline storage for arbitrary key-value pair data. In future it could be changed for [`WebStorage`](https://felgo.com/doc/felgo-webstorage/).

## Developed components

## Standalone components
* [`Constants`](https://troyane.github.io/GoodHabits/doxy/classConstants.html) -- to ease usage of components. We created one component that holds all constants, that could be used application wide.
* [`DaysPicker`](https://troyane.github.io/GoodHabits/doxy/classDaysPicker.html) -- visual component that has days checkboxes on a grid.
* [`IconPicker`](https://troyane.github.io/GoodHabits/doxy/classIconPicker.html) -- as component for choosing icon from available in [`IconType`](https://felgo.com/doc/felgo-icontype/) icons. unfortunately `IconType` have no possibility to use and store human names for icons. That's why [`IconTypeHelper`](https://troyane.github.io/GoodHabits/doxy/classIconTypeHelper.html) was created. 
* [`WarningPaper`](https://troyane.github.io/GoodHabits/doxy/classWarningPaper.html) -- as `AppPaper` override for any in-place message boxes. Appearance and dissappearance of this box is animated. 
* `Secrets.qml` -- file didn't presented in repository and excluded from `.gitignore`. See [`Secrets.qml_template`](https://github.com/troyane/GoodHabits/blob/master/GoodHabitsApp/qml/secrets/Secrets.qml_template) for reference. This file intended to be secret and available only on build-machine. One just can put Felgo `license` string here, `gameId` and `gameSecret`.

### Helper UI components
* [`GHDeleteButton`](https://troyane.github.io/GoodHabits/doxy/classGHDeleteButton.html) -- button with trashcan on it.
* [`GHPaper`](https://troyane.github.io/GoodHabits/doxy/classGHPaper.html) -- [`AppPaper`](https://felgo.com/doc/felgo-apppaper/) override for ease of use inside the application. Component has predefined radius and could react to clicks.
* [`GHScrollView`](https://troyane.github.io/GoodHabits/doxy/classGHScrollView.html) -- simple [`ScrollView`](https://felgo.com/doc/qt/qml-qtquick-controls-scrollview/) override with predefined \c padding, \c spacing and \c [`ScrollBar`](https://felgo.com/doc/qt/qml-qtquick-controls2-scrollbar/) policies. 
* [`GHTextInputTime`](https://troyane.github.io/GoodHabits/doxy/classGHTextInputTime.html) -- simple [`TextInput`](https://felgo.com/doc/qt/qml-qtquick-textinput/) with predefined \c placeholderText (as `"00:00"`) and with applied \c RegExp validator to filter only time in 24H format.

## Pages
 
* [`HabitDetailPage`](https://troyane.github.io/GoodHabits/doxy/classHabitDetailPage.html) -- application page for display habit details.
* [`HabitsListPage`](https://troyane.github.io/GoodHabits/doxy/classHabitsListPage.html) -- application page for displaing a list of habits.
* [`ImportExportPage`](https://troyane.github.io/GoodHabits/doxy/classImportExportPage.html) -- application page where user can import and export data managed by this application.
* [`ProfilePage`](https://troyane.github.io/GoodHabits/doxy/classProfilePage.html) -- application page that contains information about application and leads to another pages where user can Export/Import his habits, records, apply settings, etc.
* [`RecordPage`](https://troyane.github.io/GoodHabits/doxy/classRecordPage.html) -- application page that displays details on specific record. It gives ability to view and edit record.
* [`ReportPage`](https://troyane.github.io/GoodHabits/doxy/classReportPage.html) -- application page that display list of user's records.
* [`SettingsPage`](https://troyane.github.io/GoodHabits/doxy/classSettingsPage.html) -- application page to access to settings. Mostly check-boxes for settings user can change.
