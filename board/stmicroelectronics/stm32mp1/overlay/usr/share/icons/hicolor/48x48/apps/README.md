# Qt5 Application Icons for STM32MP157F-DK2

## Overview
This directory contains 48x48 PNG icons for Qt5 applications running on STM32MP157F-DK2 embedded Linux platform.

## Icons

### qt5-demo.png
- **Purpose**: Qt5 Demo Application
- **Design**: Modern Qt-themed design with green Qt colors
- **Elements**: Qt logo representation with gear indicator
- **Size**: 48x48 pixels, 544 bytes
- **Format**: PNG with RGBA transparency
- **Target Application**: `/opt/qt_demo/qt_demo`

### bike-computer.png
- **Purpose**: Bike Computer Application  
- **Design**: Cycling-themed with sporty orange colors
- **Elements**: Simplified bike frame, wheels, speed indicator
- **Size**: 48x48 pixels, 571 bytes
- **Format**: PNG with RGBA transparency
- **Target Application**: `/opt/bike_computer/bike-computer`

## Integration
- Icons are automatically copied to target rootfs during Buildroot build
- Final location on target: `/usr/share/icons/hicolor/48x48/apps/`
- Referenced by .desktop files in `/usr/share/applications/`
- Used by Qt5 desktop environment for application launcher

## Design Considerations
- High contrast for visibility on embedded LCD displays
- Optimized for touch-screen interaction
- Small file size for embedded system constraints
- Clear, recognizable designs at 48x48 resolution
- Professional embedded system appearance

## Buildroot Integration
These icons are part of the Buildroot overlay and will be included in the target filesystem when building the STM32MP157F-DK2 image.

Build command:
```bash
cd buildroot/
make st_stm32mp157f_dk2_defconfig
make -j$(nproc)
```

The icons will be available on the target system after deployment.
