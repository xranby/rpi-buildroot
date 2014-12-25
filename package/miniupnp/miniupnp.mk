################################################################################
#
# miniupnp
#
################################################################################

MINIUPNP_VERSION = 1.9.20141128
MINIUPNP_DOWNLOAD = http://miniupnp.free.fr/files/download.php?file=miniupnpc-$(MINIUPNP_VERSION).tar.gz
MINIUPNP_INSTALL_STAGING = YES
MINIUPNP_LICENSE = BSD-3c
MINIUPNP_LICENSE_FILES = LICENSE

define MINIUPNP_DOWNLOAD_CMDS
	wget -c $(MINIUPNP_DOWNLOAD) -O $(BR2_DL_DIR)/miniupnpc-$(MINIUPNP_VERSION).tar.gz
endef

MINIUPNP_PRE_DOWNLOAD_HOOKS += MINIUPNP_DOWNLOAD_CMDS

define MINIUPNP_EXTRACT_CMDS
	tar zxvf $(BR2_DL_DIR)/miniupnpc-$(MINIUPNP_VERSION).tar.gz -C $(@D)
        mv $(@D)/miniupnpc-1.9.20141128/* $(@D)/
endef

$(eval $(cmake-package))
