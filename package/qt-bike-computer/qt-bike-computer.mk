#
# qt-bike-computer package for Buildroot
#

QT_BIKE_COMPUTER_SITE = $(call qstrip,$(BR2_EXTERNAL_ST_PATH))/../layers/application-layer/recipes-qt/qt-bike-computer
QT_BIKE_COMPUTER_SITE_METHOD = local
QT_BIKE_COMPUTER_DEPENDENCIES = qt5base qt5declarative qt5quickcontrols2

$(eval $(cmake-package))