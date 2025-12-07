################################################################################
#
# qt-bike-gui
#
################################################################################

QT_BIKE_GUI_VERSION = 1.0.0
QT_BIKE_GUI_SITE = $(TOPDIR)/../layers/application-layer/recipes-qt/qt-bike-gui
QT_BIKE_GUI_SITE_METHOD = local
QT_BIKE_GUI_LICENSE = MIT
QT_BIKE_GUI_LICENSE_FILES = LICENSE
QT_BIKE_GUI_INSTALL_STAGING = YES

# Dependencies - qt5-ipc-system must be built first
QT_BIKE_GUI_DEPENDENCIES = qt5base qt5declarative qt5multimedia qt5svg qt5-ipc-system

QT_BIKE_GUI_CONF_OPTS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DQT_QPA_PLATFORM=eglfs \
	-DQT_QPA_EGLFS_INTEGRATION=eglfs_kms \
	-DQT_QPA_EGLFS_KMS_ATOMIC=1 \
	-DQT_QPA_EGLFS_FORCE888=1 \
	-DQT_QPA_EGLFS_DISABLE_INPUT=0

# Buildroot specific configuration
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT_BIKE_GUI_CONF_OPTS += -DQT5_VERSION=5.15
endif

# Demo mode option
ifeq ($(BR2_PACKAGE_QT_BIKE_GUI_DEMO_MODE),y)
QT_BIKE_GUI_CONF_OPTS += -DQT_BIKE_GUI_DEMO_MODE=ON
endif

# Build tests option
ifeq ($(BR2_PACKAGE_QT_BIKE_GUI_BUILD_TESTS),y)
QT_BIKE_GUI_CONF_OPTS += -DQT_BIKE_GUI_BUILD_TESTS=ON
endif

# Enable debug for development builds
ifeq ($(BR2_PACKAGE_QT_BIKE_GUI_DEBUG),y)
QT_BIKE_GUI_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
endif

# Static library option
ifeq ($(BR2_STATIC_LIBS),y)
QT_BIKE_GUI_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
else
QT_BIKE_GUI_CONF_OPTS += -DBUILD_SHARED_LIBS=ON
endif

# STM32MP157F-DK2 specific optimizations
QT_BIKE_GUI_CONF_OPTS += \
	-DCMAKE_CXX_FLAGS="-march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -O2 -pipe -g -Wall -Wextra" \
	-DQT_NO_DEBUG_OUTPUT=ON

# Install init script
define QT_BIKE_GUI_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(@D)/init.d/S99qt-bike-gui \
		$(TARGET_DIR)/etc/init.d/S99qt-bike-gui
endef

# Install systemd service (if enabled)
ifeq ($(BR2_INIT_SYSTEMD),y)
define QT_BIKE_GUI_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/systemd/qt-bike-gui.service \
		$(TARGET_DIR)/usr/lib/systemd/system/qt-bike-gui.service
endef
endif

# Create runtime directories
define QT_BIKE_GUI_CREATE_RUNTIME_DIRS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/opt/qt-bike-gui
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/opt/qt-bike-gui/logs
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/opt/qt-bike-gui/config
endef

QT_BIKE_GUI_POST_INSTALL_TARGET_HOOKS += QT_BIKE_GUI_CREATE_RUNTIME_DIRS

# Install configuration files
define QT_BIKE_GUI_INSTALL_CONFIG
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/opt/qt-bike-gui/config
	$(INSTALL) -m 0644 $(@D)/config/* \
		$(TARGET_DIR)/opt/qt-bike-gui/config/ 2>/dev/null || true
endef

QT_BIKE_GUI_POST_INSTALL_TARGET_HOOKS += QT_BIKE_GUI_INSTALL_CONFIG

# Install documentation
define QT_BIKE_GUI_INSTALL_DOCS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/share/doc/qt-bike-gui
	$(INSTALL) -m 0644 $(@D)/README.md \
		$(TARGET_DIR)/usr/share/doc/qt-bike-gui/ 2>/dev/null || true
	$(INSTALL) -m 0644 $(@D)/docs/ui_design.md \
		$(TARGET_DIR)/usr/share/doc/qt-bike-gui/ 2>/dev/null || true
endef

QT_BIKE_GUI_POST_INSTALL_TARGET_HOOKS += QT_BIKE_GUI_INSTALL_DOCS

# Set proper permissions for the executable
define QT_BIKE_GUI_PERMISSIONS
	/usr/bin/qt_bike_gui f 4755 0 0 - - - - -
endef

$(eval $(cmake-package))
