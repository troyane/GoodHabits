# GoodHabits application

This is quite simple application that uses next Felgo features and/or components:

For native looking:

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


