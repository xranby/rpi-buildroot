################################################################################
#
# blackcoin
#
################################################################################

BLACKCOIN_VERSION = v1.1.2.1
BLACKCOIN_SITE = $(call github,rat4,blackcoin,$(BLACKCOIN_VERSION))
BLACKCOIN_LICENSE = MIT
BLACKCOIN_LICENSE_FILES = LICENSE

BLACKCOIN_DEPENDENCIES += berkeleydb 
BLACKCOIN_DEPENDENCIES += boost
BLACKCOIN_DEPENDENCIES += miniupnp
BLACKCOIN_DEPENDENCIES += openssl

ifeq ($(BR2_PACKAGE_QT),y)
BLACKCOIN_DEPENDENCIES += qt
define BLACKCOIN_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT_QMAKE))
endef
define BLACKCOIN_BUILD_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef
else ifeq ($(BR2_PACKAGE_QT5),y)
BLACKCOIN_DEPENDENCIES += qt5base
define BLACKCOIN_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT5_QMAKE))
endef
define BLACKCOIN_BUILD_CMDS
	# Using host qt4 lrelease tool to convert language .st to .qm files
	# as qt5 builds require .qm language files.
        cd $(@D); lrelease $(@D)/blackcoin-qt.pro
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef
endif

define BLACKCOIN_INSTALL_TARGET_CMDS
	cp -a $(@D)/blackcoin-qt $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
