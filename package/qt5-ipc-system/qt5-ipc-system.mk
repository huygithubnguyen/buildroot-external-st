################################################################################
#
# qt5-ipc-system
#
################################################################################

QT5_IPC_SYSTEM_VERSION = 1.0.0
QT5_IPC_SYSTEM_SITE = $(TOPDIR)/../layers/application-layer/recipes-qt/qt5-ipc-system
QT5_IPC_SYSTEM_SITE_METHOD = local
QT5_IPC_SYSTEM_LICENSE = MIT
QT5_IPC_SYSTEM_LICENSE_FILES = LICENSE
QT5_IPC_SYSTEM_INSTALL_STAGING = YES

QT5_IPC_SYSTEM_DEPENDENCIES = json-c qt5base qt5declarative

QT5_IPC_SYSTEM_CONF_OPTS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DQT_QPA_PLATFORM=eglfs \
	-DQT_QPA_EGLFS_INTEGRATION=eglfs_kms \
	-DQT_QPA_EGLFS_KMS_ATOMIC=1

# Buildroot specific configuration
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5_IPC_SYSTEM_CONF_OPTS += -DQT5_VERSION=5.15
endif

# Enable debug for development builds
ifeq ($(BR2_PACKAGE_QT5_IPC_SYSTEM_DEBUG),y)
QT5_IPC_SYSTEM_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
endif

# Static library option
ifeq ($(BR2_STATIC_LIBS),y)
QT5_IPC_SYSTEM_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
else
QT5_IPC_SYSTEM_CONF_OPTS += -DBUILD_SHARED_LIBS=ON
endif

# Install init script
define QT5_IPC_SYSTEM_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(@D)/services/S50ipc-daemon \
		$(TARGET_DIR)/etc/init.d/S50ipc-daemon
endef

# Install systemd service (if enabled)
ifeq ($(BR2_INIT_SYSTEMD),y)
define QT5_IPC_SYSTEM_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/systemd/ipc-daemon.service \
		$(TARGET_DIR)/usr/lib/systemd/system/ipc-daemon.service
endef
endif

# Create runtime directories
define QT5_IPC_SYSTEM_CREATE_RUNTIME_DIRS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/var/run/qt5/sockets
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/var/log/qt5
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/qt5
endef

QT5_IPC_SYSTEM_POST_INSTALL_TARGET_HOOKS += QT5_IPC_SYSTEM_CREATE_RUNTIME_DIRS

# Install configuration files
define QT5_IPC_SYSTEM_INSTALL_CONFIG
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/qt5
	$(INSTALL) -m 0644 $(@D)/services/*.json \
		$(TARGET_DIR)/etc/qt5/ 2>/dev/null || true
endef

QT5_IPC_SYSTEM_POST_INSTALL_TARGET_HOOKS += QT5_IPC_SYSTEM_INSTALL_CONFIG

$(eval $(cmake-package))
