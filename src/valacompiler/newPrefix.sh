#!/bin/bash
mkdir "$1" || exit 1
WINEPREFIX="$1" wine wineboot
