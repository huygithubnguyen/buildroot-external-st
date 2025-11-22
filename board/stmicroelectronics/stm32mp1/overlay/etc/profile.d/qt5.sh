#!/bin/sh

# Qt5 Environment Variables for STM32MP157F-DK2
# This script sets up Qt5 environment for all users

# Qt5 installation and platform settings
export QTDIR=/usr
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_KMS_CONFIG=/etc/qt5/kms-config.json

# Display settings for STM32MP157F-DK2
export QT_QPA_EGLFS_PHYSICAL_WIDTH=480
export QT_QPA_EGLFS_PHYSICAL_HEIGHT=272
export QT_QPA_EGLFS_ROTATION=0

# Qt5 plugin and QML paths
export QT_PLUGIN_PATH=/usr/lib/qt5/plugins
export QML2_IMPORT_PATH=/usr/lib/qt5/qml

# Font configuration
export QT_QPA_FONTDIR=/usr/share/fonts

# Input device configuration
export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0
export QT_QPA_EVDEV_KEYBOARD_PARAMETERS=/dev/input/event1
export QT_QPA_EVDEV_MOUSE_PARAMETERS=/dev/input/event2

# Touch screen configuration
export TSLIB_CONSOLEDEVICE=none
export TSLIB_FBDEVICE=/dev/fb0
export TSLIB_TSDEVICE=/dev/input/event0
export TSLIB_CALIBFILE=/etc/pointercal
export TSLIB_CONFFILE=/etc/ts.conf
export TSLIB_PLUGINDIR=/usr/lib/ts

# EGLFS specific settings
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms
export QT_QPA_EGLFS_ALWAYS_SET_MODE=1

# Debug and logging (disable for production)
# export QT_LOGGING_RULES=qt.qpa.*=true
# export QT_DEBUG_PLUGINS=1

# Add Qt5 binaries to PATH
export PATH=$PATH:/usr/lib/qt5/bin

# Library path for Qt5
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/qt5/lib

