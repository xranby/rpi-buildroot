################################################################################
#
# openjdk
#
# Please be aware that, when cross-compiling, the OpenJDK configure script will
# generally use 'target' where autoconf traditionally uses 'host'
#
################################################################################

#Version is the same as OpenJDK HG tag

OPENJDK_VERSION = jdk-9+150 
OPENJDK_RELEASE = jdk9
OPENJDK_PROJECT = jdk9

# --with-cpu-port         specify sources to use for Hotspot 64-bit ARM port
#                          (arm64,aarch64) [aarch64]
# There is an additional ARM specific option, --with-cpu-port, which can be used to specify the new aarch64 build --with-cpu-port=arm64 or the existing aarch64 build --with-cpu-port=aarch64.
# If no option is specified the build defaults to the existing aarch64 build. 

# --with-abi-profile      specify ABI profile for ARM builds
#                          (arm-vfp-sflt,arm-vfp-hflt,arm-sflt,
#                          armv5-vfp-sflt,armv6-vfp-hflt,arm64,aarch64)
# arm-vfp-sflt then
# ARM_FLOAT_TYPE=vfp-sflt
# ARM_ARCH_TYPE_FLAGS='-march=armv7-a -mthumb'
#
# arm-vfp-hflt then
# ARM_FLOAT_TYPE=vfp-hflt
# ARM_ARCH_TYPE_FLAGS='-march=armv7-a -mthumb'
#
# arm-sflt then
# ARM_FLOAT_TYPE=sflt
# ARM_ARCH_TYPE_FLAGS='-march=armv5t -marm'
#
# armv5-vfp-sflt then
# ARM_FLOAT_TYPE=vfp-sflt
# ARM_ARCH_TYPE_FLAGS='-march=armv5t -marm'
#
# armv6-vfp-hflt then
# ARM_FLOAT_TYPE=vfp-hflt
# ARM_ARCH_TYPE_FLAGS='-march=armv6 -marm'
#

# VALID_JVM_FEATURES="compiler1 compiler2 zero shark minimal dtrace jvmti jvmci \
#    graal fprof vm-structs jni-check services management all-gcs nmt cds \
#    static-build link-time-opt aot"

# configure: error: AOT is currently only supported on Linux-x86_64. Remove --enable-aot.
# --enable-aot=yes \ --with-jvm-features=aot \

# --with-native-debug-symbols=[none|internal|external|zipped]

OPENJDK_CONF_OPTS = \
	--with-jdk-variant=normal \
	--with-abi-profile=armv6-vfp-hflt \
	--with-conf-name=hardfp \
	--with-jvm-variants=minimal \
	--with-debug-level=release \
	--with-native-debug-symbols=none \
	--enable-openjdk-only \
	--enable-unlimited-crypto \
	--openjdk-target=$(GNU_TARGET_NAME) \
	--with-freetype-include=$(STAGING_DIR)/usr/include/freetype2 \
	--with-freetype-lib=$(STAGING_DIR)/usr/lib \
	--with-freetype=$(STAGING_DIR)/usr/ \
	--disable-freetype-bundling \
	--with-x=$(STAGING_DIR)/usr/include \
	--with-sys-root=$(STAGING_DIR) \
	--with-tools-dir=$(HOST_DIR)/bin \
	--disable-warnings-as-errors

ifeq ($(BR2_OPENJDK_CUSTOM_BOOT_JDK),y)
OPENJDK_CONF_OPTS += --with-boot-jdk=$(call qstrip,$(BR2_OPENJDK_CUSTOM_BOOT_JDK_PATH))
endif

OPENJDK_MAKE_OPTS = images profiles

OPENJDK_DEPENDENCIES = elfutils freetype cups xlib_libX11 xlib_libXext xlib_libXtst xlib_libXrender xlib_libXt alsa-lib host-pkgconf
OPENJDK_LICENSE = GPLv2+ with exception
OPENJDK_LICENSE_FILES = COPYING

ifeq ($(BR2_OPENJDK_CUSTOM_LOCAL),y)

OPENJDK_SITE = $(call qstrip,$(BR2_OPENJDK_CUSTOM_LOCAL_PATH))
OPENJDK_SITE_METHOD = local

else

OPENJDK_DOWNLOAD_SITE = http://hg.openjdk.java.net/$(OPENJDK_PROJECT)/$(OPENJDK_RELEASE)
OPENJDK_SOURCE =
OPENJDK_SITE = $(OPENJDK_DOWNLOAD_SITE)
OPENJDK_SITE_METHOD = wget

# OpenJDK uses a mercurial forest structure
# thankfully the various forests can be downloaded as individual .tar.gz files using
# the following URL structure
# http://hg.openjdk.java.net/$(OPENJDK_PROJECT)/archive/$(OPENJDK_VERSION).tar.bz2
# http://hg.openjdk.java.net/$(OPENJDK_PROJECT)/corba/archive/$(OPENJDK_VERSION).tar.bz2
# ...
OPENJDK_OPENJDK_DOWNLOAD = $(OPENJDK_DOWNLOAD_SITE)/archive/$(OPENJDK_VERSION).tar.gz
OPENJDK_HOTSPOT_DOWNLOAD = $(OPENJDK_DOWNLOAD_SITE)/hotspot/archive/$(OPENJDK_VERSION).tar.gz
OPENJDK_CORBA_DOWNLOAD = $(OPENJDK_DOWNLOAD_SITE)/corba/archive/$(OPENJDK_VERSION).tar.gz
OPENJDK_JAXP_DOWNLOAD = $(OPENJDK_DOWNLOAD_SITE)/jaxp/archive/$(OPENJDK_VERSION).tar.gz
OPENJDK_JAXWS_DOWNLOAD = $(OPENJDK_DOWNLOAD_SITE)/jaxws/archive/$(OPENJDK_VERSION).tar.gz
OPENJDK_JDK_DOWNLOAD = $(OPENJDK_DOWNLOAD_SITE)/jdk/archive/$(OPENJDK_VERSION).tar.gz
OPENJDK_LANGTOOLS_DOWNLOAD = $(OPENJDK_DOWNLOAD_SITE)/langtools/archive/$(OPENJDK_VERSION).tar.gz
OPENJDK_NASHORN_DOWNLOAD = $(OPENJDK_DOWNLOAD_SITE)/nashorn/archive/$(OPENJDK_VERSION).tar.gz

define OPENJDK_DOWNLOAD_CMDS
	wget -c $(OPENJDK_OPENJDK_DOWNLOAD) -O $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-openjdk-$(OPENJDK_VERSION).tar.gz
	wget -c $(OPENJDK_HOTSPOT_DOWNLOAD) -O $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-hotspot-$(OPENJDK_VERSION).tar.gz
	wget -c $(OPENJDK_CORBA_DOWNLOAD) -O $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-corba-$(OPENJDK_VERSION).tar.gz
	wget -c $(OPENJDK_JAXP_DOWNLOAD) -O $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-jaxp-$(OPENJDK_VERSION).tar.gz
	wget -c $(OPENJDK_JAXWS_DOWNLOAD) -O $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-jaxws-$(OPENJDK_VERSION).tar.gz
	wget -c $(OPENJDK_JDK_DOWNLOAD) -O $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-jdk-$(OPENJDK_VERSION).tar.gz
	wget -c $(OPENJDK_LANGTOOLS_DOWNLOAD) -O $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-langtools-$(OPENJDK_VERSION).tar.gz
	wget -c $(OPENJDK_NASHORN_DOWNLOAD) -O $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-nashorn-$(OPENJDK_VERSION).tar.gz
endef

OPENJDK_PRE_DOWNLOAD_HOOKS += OPENJDK_DOWNLOAD_CMDS

define OPENJDK_EXTRACT_CMDS
	tar zxvf $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-openjdk-$(OPENJDK_VERSION).tar.gz -C $(@D)
	mv $(@D)/$(OPENJDK_RELEASE)-*/* $(@D)
	tar zxvf $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-hotspot-$(OPENJDK_VERSION).tar.gz -C $(@D)
        ln -s $(@D)/hotspot-* $(@D)/hotspot
	tar zxvf $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-corba-$(OPENJDK_VERSION).tar.gz -C $(@D)
	ln -s $(@D)/corba-* $(@D)/corba
	tar zxvf $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-jaxp-$(OPENJDK_VERSION).tar.gz -C $(@D)
	ln -s $(@D)/jaxp-* $(@D)/jaxp
	tar zxvf $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-jaxws-$(OPENJDK_VERSION).tar.gz -C $(@D)
	ln -s $(@D)/jaxws-* $(@D)/jaxws
	tar zxvf $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-jdk-$(OPENJDK_VERSION).tar.gz -C $(@D)
	ln -s $(@D)/jdk-* $(@D)/jdk
	tar zxvf $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-langtools-$(OPENJDK_VERSION).tar.gz -C $(@D)
	ln -s $(@D)/langtools-* $(@D)/langtools
	tar zxvf $(BR2_DL_DIR)/openjdk-$(OPENJDK_RELEASE)-nashorn-$(OPENJDK_VERSION).tar.gz -C $(@D)
	ln -s $(@D)/nashorn-* $(@D)/nashorn
endef

endif 

define OPENJDK_CONFIGURE_CMDS
	chmod +x $(@D)/configure
        cd $(@D); ./configure $(OPENJDK_CONF_OPTS) OBJCOPY=$(TARGET_OBJCOPY) STRIP=$(TARGET_STRIP) CPP_FLAGS=-lstdc++ CXX_FLAGS=-lstdc++ CPP=$(TARGET_CPP) CXX=$(TARGET_CXX) CC=$(TARGET_CC) LD=$(TARGET_CC)
endef

define OPENJDK_BUILD_CMDS
	# LD is using CC because busybox -ld do not support -Xlinker -z hence linking using gcc instead
        cd $(@D); make OBJCOPY=$(TARGET_OBJCOPY) STRIP=$(TARGET_STRIP) BUILD_CC=gcc BUILD_LD=gcc CPP=$(TARGET_CPP) CXX=$(TARGET_CXX) CC=$(TARGET_CC) LD=$(TARGET_CC)
        # make OPENJDK_MAKE_OPTS (images and profiles) fail unless a regular make has been built once
        # therefore we run make twice
        cd $(@D); make $(OPENJDK_MAKE_OPTS)
endef

define OPENJDK_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/jvm/
	cp -arf $(@D)/build/*/images/j* $(TARGET_DIR)/usr/lib/jvm/
endef

#openjdk configure is not based on automake
$(eval $(generic-package))
