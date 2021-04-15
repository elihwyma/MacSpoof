TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MacSpoof

MacSpoof_FILES = Tweak.x
MacSpoof_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
