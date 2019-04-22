---
layout: default
title: Developer info
permalink: /dev/
navigation_weight: 1
---

# Developers section

...

## Get source code

You can fork/clone the project from [here](https://github.com/troyane/GoodHabits).

## Prepare build environment

...

## Build and run

...

## Documentation

### Required software for documentation build

To build documentation you need to have installed required software: 
* [`graphviz`](https://www.graphviz.org/), 
* [`doxygen`](http://www.doxygen.nl/), 
* [`doxyqml`](https://github.com/agateau/doxyqml).

To install it on Debian-based distro do:

```bash
sudo apt install graphviz
sudo apt install doxygen
pip3 install doxyqml --user
```

### Build instructions

If you've got all required soft installed, it is very easy to build documentation. All you need to do is to run:

```bash
cd GoodHabits
dosygen Doxygen
```

As a result -- you'll get documentation already built inside folder `GoodHabits/docs/doxy/`. Open `index.html`.

### Already built documentation

Documentation is avaialble [here](https://troyane.github.io/GoodHabits/doxy/).
