TARGET := iphone:clang:13.3:14.0
export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

export GO_EASY_ON_ME = 1

BUNDLE_NAME = MacSpoof
MacSpoof_FILES = AmyRootListController.m WifiManager.m WiFiNetworkViewController.m MacConfigViewController.m
MacSpoof_FRAMEWORKS = UIKit
MacSpoof_PRIVATE_FRAMEWORKS = Preferences MobileWiFi
MacSpoof_INSTALL_PATH = /Library/PreferenceBundles
MacSpoof_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
