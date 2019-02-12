<div align="center">
  <span align="center"> <img width="80" height="70" class="center" src="https://github.com/aggalex/Wineglass/blob/master/data/images/com.github.Wineglass.png" alt="Icon"></span>
  <h1 align="center">Wineglass</h1>
  <h3 align="center">A GUI for Wine</h3>
</div>

<br/>

<p align="center">
    <a href="https://appcenter.elementary.io/com.github.Wineglass">
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
    <img  src="https://github.com/aggalex/Wineglass/blob/master/data/images/screenshot.png" alt="Screenshot"> <br>
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


Use the App script to simplify installation by running `./app install-deps`
 
### Building

```
git clone https://github.com/aggalex/Wineglass.git com.github.Wineglass
```

### Deconstruct

```
./app uninstall
```

### Development & Testing

Officeworks Author includes a script to simplify the development process. This script can be accessed in the main project directory through `./app`.

```
Usage:
  ./app [OPTION]

Options:
  clean             Removes build directories (can require sudo)
  generate-i18n     Generates .pot and .po files for i18n (multi-language support)
  install           Builds and installs application to the system (requires sudo)
  install-deps      Installs missing build dependencies
  run               Builds and runs the application
  test              Builds and runs testing for the application
  test-run          Builds application, runs testing and if successful application is started
  uninstall         Removes the application from the system (requires sudo)
```

### Contributing

To help, access the links below:

- [Guide on Code Style](https://github.com/aggalex/Wineglass/wiki/Guide-on-code-style)

- [Proposing Design Changes](https://github.com/aggalex/Wineglass/wiki/Proposing-Design-Changes)

- [Reporting Bugs](https://github.com/aggalex/Wineglass/wiki/Reporting-Bugs)

- [Translate](https://github.com/aggalex/Wineglass/wiki/Translate)


### License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE.md) file for details.
