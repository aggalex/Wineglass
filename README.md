<div align="center">
  <span align="center"> <img class="center" src="https://github.com/aggalex/Wineglass/blob/master/data/icons/64/com.github.aggalex.Wineglass.svg" alt="Icon"></span>
  <h1 align="center">Wineglass</h1>
  <h3 align="center">A GUI for Wine</h3>
</div>

<br/>

<p align="center">
    <a href="https://appcenter.elementary.io/com.github.aggalex.Wineglass">
        <img src="https://appcenter.elementary.io/badge.svg">
    </a>
</p>

<p align="center">
  <a href="https://github.com/aggalex/Wineglass/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/License-GPL-3.0-blue.svg">
  </a>
  <a href="https://github.com/aggalex/Wineglass/releases">
    <img src="https://img.shields.io/badge/Release-v%201.0.0-orange.svg">
  </a>
</p>

<p align="center">
    <img  src="https://github.com/aggalex/Wineglass/blob/master/data/Images/Screenshot.png" alt="Screenshot"> <br>
  <a href="https://github.com/aggalex/Wineglass/issues/new"> Report a problem! </a>
</p>

## Installation

### Dependencies
These dependencies must be present before building:
 - `meson`
 - `valac`
 - `debhelper`
 - `libgranite-dev`
 - `libgtk-3-dev`
 - `wine`


### Building
After installing all the required dependencies, you can build Wineglass using:
```
git clone https://github.com/aggalex/Wineglass.git com.github.aggalex.Wineglass && cd com.github.aggalex.Wineglass
meson build
meson configure -Dprefix=/usr
ninja install
```

### Deconstruct
Go to the build folder and run:
```
ninja uninstall
```

### Contributing

To help, access the links below:

- [Guide on Code Style](https://github.com/aggalex/Wineglass/wiki/Guide-on-code-style)

- [Proposing Design Changes](https://github.com/aggalex/Wineglass/wiki/Proposing-Design-Changes)

- [Reporting Bugs](https://github.com/aggalex/Wineglass/wiki/Reporting-Bugs)

- [Translate](https://github.com/aggalex/Wineglass/wiki/Translate)


### License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE.md) file for details.
