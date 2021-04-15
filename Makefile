export ARCHS = arm64 arm64e
export TARGET = iphone:clang:13.3:14.0
export THEOS_DEVICE_IP = 192.168.0.113

INSTALL_TARGET_PROCESSES = Preferences
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk
SUBPROJECTS += src/MacSpoofTweak src/Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk

purge::
	$(ECHO_BEGIN)$(PRINT_FORMAT_RED) "Purging"$(ECHO_END); $(ECHO_PIPEFAIL)
	find . -name '.theos' -exec rm -rf {} \; -o -name 'packages' -exec rm -rf {} \; -o -name '.dragon' -exec rm -rf {} \; -o -name '*.ninja' -exec rm -rf {} \; -o -name '.DS_Store' -exec rm -rf {} \; 2>&1 | grep -v 'find' ; echo -n ""
