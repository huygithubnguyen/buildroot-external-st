#!/bin/sh
# Qt5 Input Configuration for STM32MP157F-DK2
# Maps correct input devices for touch and keyboard

# Touch device is EP0110M09 on event1
export QT_QPA_EVDEV_MOUSE_PARAMETERS="/dev/input/event1"
export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS="/dev/input/event1"

# Power button keyboard is pmic_onkey on event0  
export QT_QPA_EVDEV_KEYBOARD_PARAMETERS="/dev/input/event0"