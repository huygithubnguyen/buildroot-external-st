#
# qt-demo-simple package for Buildroot
#

QT_DEMO_SIMPLE_SITE = $(call qstrip,$(BR2_EXTERNAL_ST_PATH))/../layers/application-layer/recipes-qt/qt_demo_simple
QT_DEMO_SIMPLE_SITE_METHOD = local
QT_DEMO_SIMPLE_DEPENDENCIES = qt5base

$(eval $(cmake-package))