#!/bin/bash
mkdir "$1" || exit 1
WINEPREFIX="$1" WINEARCH="win32" wine wineboot
