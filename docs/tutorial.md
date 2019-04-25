---
layout: page
title: How to make a GoodHabits application with Felgo
permalink: /tutorial/
navigation_weight: -1
---

# How to make a GoodHabits application with Felgo

This app helps people to understand how much time do they spend on their hobbies and interests, 
how sustainable their wishes and aims are and where the habit starts to benefit you in the new 
skills form. And the one effect we’re expecting is that being motivated to spend more time on 
good habits, you won’t spend time on bad habits...

So, basically it is advanced time tracker with categories mobile application (suitable for tablets 
too).

![habits](imgs/habits.gif)
![records](imgs/records.gif)

In this tutorial we will strip up basic things required for each mobile application like:

* stacked-page navigation,
* usage of layouts and preparation of adaptive UI,
* dealing with native dialogs,
* customizing controls,
* MVC:
  * model preparation,
  * view organization,
* loading and storing persistant data,
* oraganization of source code files,
* importing third party JS-modules.


## Project structure

We could start from creating basic Felgo application. To prepare basic project structure, use wizard in Felgo QtCreator:

New Project -> Felgo Apps -> Single-Page Application.

Provide name, choose correct folder to store your project to; choose Felgo Toolchain.

### Felgo Project Properties

As Felgo Project Properties provide:
* **App display name:** `GoodHabits`
* **App identifier:** provide your unique application identifier in format `com.yourcompany.GoodHabits`.
* **Interface orientation:** choose `Auto`, since we are going to use layouts and scroll areas to create adaptive UI for application.

### Felgo Plugin Selection

For this application no plugins required. No need to choose any.

### Project management

As a result wizard will create a list of files reqired for distributing application as on iOS same for Android:

```bash
/home/user/Projects/GoodHabits:

android/* [...]
assets/felgo-logo.png
ios/* [...]
macx/app_icon.icns
qml/Main.qml
qml/config.json
win/app_icon.ico
win/app_icon.rc
GoodHabits.pro
main.cpp
resources.qrc
```

That's great. We'll touch only few of them. Now we are ready to start programming.

## Keeping all secrets

As you may see, there is our main file `Main.qml` -- it will be our entry point to application.

You may see comment regarding license. In case you've already generated your license, this is great.
Let's avoid showing your license key in this `Main.qml` file. Create new directory `qml/secrets`. 
Put there 2 files:
 * `Secrets.qml` -- actual file that will be used in application. No one can see it. Let's agree that this will be file with sensitive data. Do not forget to add this file to your `.gitignore` file, so in case you are using git -- this very file will not get into remote repository.
 * `Secrets.qml_template` -- file that will not be used in applicatino, but will reflect secrets-file structure. This file could be uploaded to repositry without any problems.

 To be sure that secrets-component will be as lightweight as possible, we'll create it as singletone [`QtObject`](https://doc.qt.io/qt-5/qml-qtqml-qtobject.html):
```qml
pragma Singleton

import QtQuick 2.0

/**
 * This file intended to be secret and available only on build-machine.
 *   1. Rename License.qml_template -> License.qml.
 *   2. Insert your key into <KEY GOES HERE>.
 *   3. Add License.qml into .gitignore (if not added yet).
 */

QtObject {
    readonly property string key: "<KEY GOES HERE>"
}
```


## Application

You may see that newly created project already has [`App`] as a main component. The `App` type is used to create the top-level item in a new Felgo application. Every Felgo app begins with a single `App` component defined at the root of its hierarchy. We'll use its 

* properties:
  * [`tablet`] -- read-only property that is `true` if the screen's diameter is bigger than 6.7 inches. We'll use it to trigger a [`splitView`] in used [`NavigationStack`]s.
  * [`settings`] -- as persistent storage for key-value pairs of data, that are also available when the user closes the app and restarts it. This one we'll use for storing user defined settings.
* method [`dp()`] -- for density-independent measurements for pixel values. This will allow us to define the same physical size for elements across platforms and screens with different densities.


## Navigation

Newly created application already has [`NavigationStack`] with one [`Page`] already defined.

The [`NavigationStack`] item manages the navigation of hierarchical content represented by a stack of [`Pages`]. The [`NavigationStack`] component adds a navigation bar and is used to navigate between pages. The [`Page`] component is the container for a single page of content.

We'll have 3 different navigation stacks -- each for different purpose:

* **Habits** list -- to see a list of habits, see detailed information on habit, edit habits 
* **Report** -- to see a list of reported logged habits (called `records` in terms of application), see detailed information on records, edit records
* **Profile** -- see application information, access export/import page, access settings page.

You may understand that each of stacks is stand-alone, and could be navigatable by its own, to its own sub-pages.

We are going to create next hierarchical structure. Give this pages easy names that describes its content the best.

* Main page -- `Main.qml`
  * Habits
    * Page with a list of habits -- `HabitsListPage.qml`
    * View/Edit/Create habit page -- `HabitDetailPage.qml`
    * Create record on habit -- `RecordPage.qml`
  * Records
    * Report page with a list of records -- `ReportPage.qml`
    * Page to view/edit record -- `RecordPage.qml`
  * Profile
    * Page with general application info -- `ProfilePage.qml`
    * Export/Import application data -- `ImportExportPage.qml`
    * Page with settings -- `SettingsPage.qml`

Best approach is to reflect this structure in your source code folder structure. We'll create folder `qml/pages` where put all of mentioned pages. 

We'll implement page changing logic first. Create each page as simple and clean as possible with one item inside (couloured rectangle or centered text), e.g.:

```qml
Page {
    title: qsTr("Habits list")
    AppText {
    	text: qsTr("Habits list here")
    }
}

```

As soon as there are ready page components, lets get back to main component and prepare all required navigation stacks.
```qml
Navigation {
    id: navigation

    NavigationItem {
        title: qsTr("Habits list")
        icon: IconType.list

        NavigationStack {
            id: niHabitsList
            initialPage: HabitsListPage { }
        }
    }

    NavigationItem {
        title: qsTr("Report")
        icon: IconType.barchart

        NavigationStack {
            initialPage: ReportPage { }
        }
    }

    NavigationItem {
        title: qsTr("Profile")
        icon: IconType.user

        NavigationStack {
            initialPage: ProfilePage { }
        }
    }
}
```

As a result we'll have native look [`Navigation`] that will automatically use different navigation modes depending on the used platform. For iOS it will be tab bar with three icons on the bottom of the screen. 

We've set different icons for each tab (`icon`). Icon could be choosed from [`IconType`] -- a global object containing the possible `Icons`.

Each [`NavigationItem`] contains [`NavigationStack`] in it -- now our application could run and do some simple navigation between different stacks, each has one page inside.

Let's add possibility to navigate over pages inside stacks. Inside `HabitsListPage` create component:

```qml
Component {
    id: detailPageComponent
    HabitDetailPage { }
}
``` 

To load this page, add [`AppButton`] component into `HabitsListPage`:

```qml
AppButton {
    text: qsTr("Show Detail Page")
    onClicked: habitsListPage.navigationStack.popAllExceptFirstAndPush(detailPageComponent)
}
```

Code is self explanatory, on button click it will access `HabitsListPage`'s attached property [`navigationStack`] and pop every page inside stack except first and push page by its id `detailPageComponent`.

You may see that as soon as you get into `HabitDetailPage`, button `Back` appears on navigation bar. It will [`pop`] your current page and get you to previous page in stack.

Prepare rest of pages required for application, so we can do application navigation as it is expected. 


## Data structures 

Main task of application is to create and store information, so used data structures is vital question.

To simplify testing process and to get instant results, lets create file `qml/js/testData.js` and use it as data source for now. We could easily use [imported JavaScript resources in QML](https://doc.qt.io/qt-5/qtqml-javascript-imports.html).

### Habits data structure

Let's define all required fields for Habit structure. There should be:

* `id` as a unique identifier, key value,
* `title` -- name of habit,
* `description` -- optional detailed description of habit,
* `icon` -- text identifier of icon used for habit,
* `duration` -- float number that represents default amount of time  in hours spent on habit,
* `time` -- string that contains default time of the day that best suitable for habit,
* `days` -- string containing comma separated day values best suitable for habit.

Example of such predefined habit could be next one:
```js
"id": "g19yc4bd3vjumu3h2n",
"title": "Reading",
"description": "Read books, comics, tech literature etc",
"icon": "book",
"duration": "0.75",
"time": "09:00",
"days": "Mon,Tue,Wed",
```

Into `testData.js` we could put next variable:
```js
var habitsData = [
	{
	    "id": "g19yc4bd3vjumu3h2n",
	    "title": "Reading",
	    "description": "Read books, comics, tech literature etc",
	    "icon": "book",
	    "duration": "0.75",
	    "time": "09:00",
	    "days": "Mon,Tue,Wed",
	    "private": false,
	    "notifications": true
	},
	{
	    "id": "iiiuerpitpgjumu3xcg",
	    "title": "Board Games",
	    "description": "Play board games with friends",
	    "icon": "cube",
	    "duration": "2.5",
	    "time": "19:00",
	    "days": "Sun",
	    "private": false,
	    "notifications": true
	},
	{
	    "id": "r9we6s329jjumu41k4",
	    "title": "Calligraphy",
	    "description": "Use brushes to practice in Japanese calligraphy",
	    "icon": "paintbrush",
	    "duration": "1.0",
	    "time": "18:00",
	    "days": "Mon,Wed,Fri",
	    "private": false,
	    "notifications": true
	}
];
```
So, it will contain JSON array of objects of previously defined structure.

### Feeding habits model

Let's create [`AppListView`]  (`ListView` that provids native `ScrollIndicator`, an empty view and swipe gestures for its list delegates) in `HabitListPage` to show habits from `testData.js`.

```qml
AppListView {
    id: listView
    model: listModel

    delegate: SimpleRow {
        text: model.title
        detailText: model.description
        iconSource: IconType[model.icon]
        }
    }
}
```

As a `listModel` we'll use [`JsonListModel`] that is proxy view model for JSON data sources. Let's feed it ours test data, include respective file:
```js
import "../js/testData.js" as TestData
```
and use:
```qml
JsonListModel {
    id: listModel
    source: TestData.habitsData
    keyField: "id"
    fields: ["id", "title", "description", "icon", "duration", "time"]
}
```

Beeing right here we could extend view possibility by adding one more proxy [`SortFilterProxyModel`] in chain. We'll have this proxy chain:

Actual data from `testData.js` -> `JsonListModel` -> `SortFilterProxyModel` -> `AppListView` that will actually show sorted, filtered data using its delegate [`SimpleRow`].

`SortFilterProxyModel` will filter and sort our model. We'd like to have sorting of items by `title`. Also, it will be great to be able to filter habits by its title (in case if user has 10+ habits -- it is vital feature for quick access). Beforehand, create [`SearchBar`] component where user can input his search query. We'll use `RegExpFilter` for this purpose, because we want to get smarter strings matching approach. In case if input query is `car` we would like to get not only results that starts from `car`, but every else that contain `car` inside. To do it we use simple regular expression `.*` + our query.

```qml
SortFilterProxyModel {
    id: filteredModel
    sourceModel: listModel
    sorters: [
        StringSorter {
          roleName: "title"
          enabled: true
        }]
    filters: [
        RegExpFilter {
            roleName: "title"
            pattern: ".*" + searchBar.text
            enabled: searchBar.text != ""
            caseSensitivity: Qt.CaseInsensitive
        }]
}
```

### Records data structure

Records data structure is simpler than habits data structure. Each record will contain:

* `id` -- unique identifier of this record
* `date` -- date where the record was made
* `habit` -- identifier of habit
* `duration` -- float value, time spent on habit
* `time` -- string representation of time, when work on habit started.


```js
{
    "id": "123",
    "date": "2019-04-01",
    "habit": "g19yc4bd3vjumu3h2n",
    "duration": "0.75",
    "time": "09:00"
}
```

Let's populate `testData.js` file with JSON array of records.


### Feeding records model

Do the same at `ReportPage` as it was done for `HabitsListPage`: add same components: `JsonListModel`, `SortFilterProxyModel`, `AppListView` with `SimpleRow` delegate.

Main changes from Habits page are:
* We need to populate `jsonModel` with `DataModel.recordsData`. Key field is same called `id`, and fields that are interesting to us are `["id", "date", "habit", "duration", "time"]`.
* No need to apply any filters, just do sort by date.
* `AppListView` will contain section by property `date`, so all our records will be structured by date.

```qml
JsonListModel {
    id: jsonModel
    source: DataModel.recordsData
    keyField: "id"
    fields: ["id", "date", "habit", "duration", "time"]
}

// ...

SortFilterProxyModel {
    id: sortedModel
    // Note: when using JsonListModel, the sorters or filter might not be applied correctly when directly assigning sourceModel
    // use the Component.onCompleted handler instead to initialize SortFilterProxyModel
    Component.onCompleted: sourceModel = jsonModel
    sorters: StringSorter { id: typeSorter; roleName: "date"; ascendingOrder: false }
}

// ...

AppListView {
    id: listView
    model: sortedModel
    delegate: SimpleRow {
        text: model.habit
        detailText: model.time
        badgeValue: model.duration + "h"

    section.property: "date"
    section.delegate: SimpleSection {
        textItem.font.bold: true
    }
}

```

Now you are able to view a list of habits and list of a records.

---

App
AppButton
AppListView
Page
JsonListModel
SortFilterProxyModel
SimpleRow
SearchBar
navigationStack as Page's
pop 

<!-- settings // https://felgo.com/doc/felgo-app/#settings-prop -->
<!-- dp() // https://felgo.com/doc/felgo-app/#dp-method -->
[`tablet`]: https://felgo.com/doc/felgo-app/#tablet-prop
[`NavigationStack`]: https://felgo.com/doc/felgo-navigationstack/
[`splitView`]: https://felgo.com/doc/felgo-navigationstack/#splitView-prop
