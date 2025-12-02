# Qt Demo Simple Package for STM32MP157F-DK2

QT_DEMO_SIMPLE_VERSION = 1.0.0
QT_DEMO_SIMPLE_SITE_METHOD = local
QT_DEMO_SIMPLE_SITE = $(TOPDIR)/../layers/application-layer/recipes-qt/qt_demo_simple
QT_DEMO_SIMPLE_SOURCE = qt_demo_simple

QT_DEMO_SIMPLE_DEPENDENCIES = qt5base json-c qt5-ipc-system

QT_DEMO_SIMPLE_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

# Install to /opt/qt_demo for easy access
QT_DEMO_SIMPLE_INSTALL_TARGET_OPTS = --prefix=/usr

$(eval $(cmake-package))