# Qt5 IPC System Package for STM32MP157F-DK2

QT5_IPC_SYSTEM_VERSION = 1.0.0
QT5_IPC_SYSTEM_SITE_METHOD = local
QT5_IPC_SYSTEM_SITE = $(TOPDIR)/../layers/application-layer/recipes-qt/qt5-ipc-system
QT5_IPC_SYSTEM_SOURCE = qt5-ipc-system

QT5_IPC_SYSTEM_DEPENDENCIES = json-c

# IPC Daemon
QT5_IPC_SYSTEM_CONF_OPTS += -DQT5_IPC_SYSTEM_DAEMON=y

# IPC Client Library
QT5_IPC_SYSTEM_CONF_OPTS += -DQT5_IPC_SYSTEM_CLIENTS=y

$(eval $(cmake-package))
