################################################################################
#
# jamvm
#
################################################################################

# Upstream
#JAMVM_VERSION = 2.0.0
#JAMVM_SITE = http://downloads.sourceforge.net/project/jamvm/jamvm/JamVM%20$(JAMVM_VERSION)
# Upstream GIT
#JAMVM_SITE = git://git.code.sf.net/p/jamvm/code

# xranby github version 
JAMVM_VERSION = 112c35306e5a97ebc3672a5c6c988e9aae06fb47
JAMVM_SITE = $(call github,xranby,jamvm,$(JAMVM_VERSION))

JAMVM_LICENSE = GPLv2+
JAMVM_LICENSE_FILES = COPYING
JAMVM_DEPENDENCIES = zlib
# int inlining seems to crash jamvm
JAMVM_CONF_OPT = \
	--disable-int-inlining \
	--without-pic \
	--with-java-runtime-library=openjdk9

#Required for JamVM GIT builds.
define JAMVM_AUTO_CMDS
	cd $(@D) ; ./autogen.sh $(JAMVM_CONF_OPT)	
endef

JAMVM_PRE_CONFIGURE_HOOKS += JAMVM_AUTO_CMDS

# jamvm has ARM assembly code that cannot be compiled in Thumb2 mode,
# so we must force traditional ARM mode.
ifeq ($(BR2_arm),y)
JAMVM_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -marm"
endif


$(eval $(autotools-package))
