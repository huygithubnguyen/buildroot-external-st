# Buildroot Integration Guide for Qt5 Bike Computer

## Overview

This guide provides comprehensive instructions for integrating qt-bike-gui and qt5-ipc-system packages into Buildroot for STM32MP157F-DK2 embedded platform.

## Package Structure

```
buildroot-external-st/
├── package/
│   ├── qt5-ipc-system/
│   │   ├── Config.in
│   │   ├── qt5-ipc-system.mk
│   │   └── qt5-ipc-system.hash
│   └── qt-bike-gui/
│       ├── Config.in
│       ├── qt-bike-gui.mk
│       └── qt-bike-gui.hash
├── Config.in
└── external.desc
```

## Build Configuration

### 1. Configure Buildroot

```bash
# Navigate to Buildroot directory
cd /home/huynguyen/Workspace/STM32MP157F-DK2/buildroot

# Configure with external tree support
make BR2_EXTERNAL=/home/huynguyen/Workspace/STM32MP157F-DK2/buildroot-external-st st_stm32mp157f_dk2_defconfig

# Run menuconfig to enable packages
make menuconfig
```

### 2. Enable Packages in Menuconfig

Navigate to:
```
-> External STM32MP157F-DK2 Packages
    [*] qt5-ipc-system
        [*] Enable debug build (optional)
    [*] qt-bike-gui
        [*] Enable demo mode (optional)
        [*] Build unit tests (optional)
        [*] Enable debug build (optional)
```

### 3. Build Packages

```bash
# Build all packages
make -j$(nproc)

# Build specific packages
make qt5-ipc-system
make qt-bike-gui

# Rebuild after changes
make qt5-ipc-system-rebuild
make qt-bike-gui-rebuild
```

## Cross-Compilation Optimization

### ARM-Specific Compiler Flags

The packages are optimized for STM32MP157F-DK2 with:
- Architecture: ARMv7-A
- FPU: NEON-VFPv4
- Float ABI: Hard
- Optimization: -O2

### Qt5 Embedded Configuration

- Platform: EGLFS with KMS/DRM
- Hardware acceleration: Enabled
- Input handling: Touch screen support
- Graphics: 32-bit color depth

## Dependency Management

### Package Dependencies

```
qt5-ipc-system:
├── json-c
├── qt5base
└── qt5declarative

qt-bike-gui:
├── qt5base
├── qt5declarative
├── qt5multimedia
├── qt5svg
└── qt5-ipc-system
```

### Build Order

1. qt5-ipc-system (provides IPC library)
2. qt-bike-gui (depends on IPC system)

## Installation and Services

### IPC System Installation

- Daemon: `/usr/sbin/ipc-daemon`
- Libraries: `/usr/lib/libqt5-ipc-system.so`
- Headers: `/usr/include/qt5-ipc-system/`
- Init script: `/etc/init.d/S50ipc-daemon`
- Config: `/etc/qt5/`

### Bike GUI Installation

- Executable: `/usr/bin/qt_bike_gui`
- Init script: `/etc/init.d/S99qt-bike-gui`
- Config: `/opt/qt-bike-gui/config/`
- Logs: `/opt/qt-bike-gui/logs/`
- Documentation: `/usr/share/doc/qt-bike-gui/`

## Runtime Configuration

### Environment Variables

```bash
# Qt5 platform configuration
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms
export QT_QPA_EGLFS_KMS_ATOMIC=1
export QT_QPA_EGLFS_FORCE888=1
export QT_QPA_EGLFS_DISABLE_INPUT=0

# Logging configuration
export QT_LOGGING_RULES="*=false"
```

### Service Management

```bash
# Start IPC daemon
/etc/init.d/S50ipc-daemon start

# Start Bike GUI
/etc/init.d/S99qt-bike-gui start

# Check status
/etc/init.d/S50ipc-daemon status
/etc/init.d/S99qt-bike-gui status
```

## Debugging and Troubleshooting

### Debug Builds

Enable debug options in menuconfig:
- `qt5-ipc-system` → `Enable debug build`
- `qt-bike-gui` → `Enable debug build`

### Log Files

- IPC daemon: `/var/log/qt5/ipc-server.log`
- Bike GUI: `/opt/qt-bike-gui/logs/`
- System logs: `dmesg | grep -i qt`

### Common Issues

1. **Library not found**: Check LD_LIBRARY_PATH and /etc/ld.so.cache
2. **Display issues**: Verify DRM device `/dev/dri/card0` exists
3. **IPC connection**: Ensure daemon is running before GUI starts
4. **Permission errors**: Check file permissions in /opt/qt-bike-gui/

## Performance Optimization

### Build Performance

```bash
# Enable ccache for faster builds
export BR2_CCACHE=y

# Parallel builds
make -j$(nproc)

# Use local mirrors
export BR2_PRIMARY_SITE="file:///path/to/local/mirror"
```

### Runtime Performance

- Use static linking for reduced memory usage
- Enable NEON optimizations for ARM
- Configure appropriate swap space
- Monitor memory usage with `free -h`

## Testing and Validation

### Unit Tests

```bash
# Run IPC system tests
/usr/lib/qt5-ipc-system/tests/ipc-test-client

# Run Bike GUI tests (if enabled)
/usr/lib/qt-bike-gui/tests/qt-bike-gui-test
```

### Integration Tests

```bash
# Test IPC communication
/etc/init.d/S50ipc-daemon test

# Test GUI functionality
export QT_BIKE_GUI_DEMO_MODE=1
/usr/bin/qt_bike_gui
```

## Deployment

### Target Deployment

```bash
# Deploy to STM32MP157F-DK2
export TARGET_IP="10.55.184.123"
export TARGET_USER="root"
export TARGET_PASS="root"

# Transfer files
sshpass -p "$TARGET_PASS" scp -r output/target/* $TARGET_USER@$TARGET_IP:/

# Restart services
sshpass -p "$TARGET_PASS" ssh $TARGET_USER@$TARGET_IP "/etc/init.d/S50ipc-daemon restart"
sshpass -p "$TARGET_PASS" ssh $TARGET_USER@$TARGET_IP "/etc/init.d/S99qt-bike-gui restart"
```

### Image Generation

```bash
# Generate complete rootfs
make

# Output images
ls -la output/images/
# - sdcard.img
# - rootfs.tar
# - zImage
# - stm32mp157f-dk2.dtb
```

## Maintenance and Updates

### Package Updates

```bash
# Update source code
cd layers/application-layer/recipes-qt/
git pull

# Rebuild packages
make qt5-ipc-system-rebuild
make qt-bike-gui-rebuild

# Generate new image
make
```

### Configuration Changes

```bash
# Save configuration
make savedefconfig

# Update defconfig
cp defconfig buildroot-external-st/configs/st_stm32mp157f_dk2_defconfig
```

## References

- Buildroot Manual: https://buildroot.org/manual.html
- Qt5 for Embedded: https://doc.qt.io/qt-5/embedded-linux.html
- STM32MP157F-DK2 Documentation: https://www.st.com/stm32mp157f-dk2
