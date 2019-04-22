---
layout: post
author: troyane
---

Development of components:
* General improvements.
* Work on [Doxygen documentation](https://troyane.github.io/GoodHabits/doxy/).
* Work on [RecordPage](https://github.com/troyane/GoodHabits/blob/master/GoodHabitsApp/qml/pages/RecordPage.qml) and [ReportPage](https://github.com/troyane/GoodHabits/blob/master/GoodHabitsApp/qml/pages/ReportPage.qml).
* Apply usage of [JSONPath](https://github.com/troyane/GoodHabits/blob/master/GoodHabitsApp/qml/js/jsonpath.js).

---

| What task                                                                	| How long 	|
|------------------------------------------------------------------------	|----------	|
| Investigation, apply JSONPath and use it.                                	|     2.5  	|
| Establish Doxygen, write docs.                                          	|     1  	|
| Writing documentation for code.                                          	|     2  	|
| Work on Records. General improvements.                                    |     2.5  	|
|                                                                  Total 	|    8h 	|


---

Reason for providing documentation "late" is because whole application is in deep development, and its parts possibly
could have unstable API. So, covering it all with documentation will be much easear as soon as all unknown become known
and all undefined became stable.

---

**P.S.:**

Faced several problems using Felgo framework.

* No recommendation to keep `Secrets` like `licenseKey` and/or another keys. Instead provided own way to do this. For more information see [Secrets.qml_template](https://github.com/troyane/GoodHabits/blob/master/GoodHabitsApp/qml/secrets/Secrets.qml_template).
* No `TimePicker` component available.
* Several times got strange output of `Qt.application.version` (it was something like 4.22) and `Qt.application.organization` (it was `V-Play`).
* ...
