
ARCHS =  armv7 arm64 
include theos/makefiles/common.mk
TARGET = iphone:latest:8.0

LDFLAGS += -F. -framework JavaScriptCore -framework Security -current_version 1.0 -compatibility_version 1.0 -framework UIKit -framework CFNetwork

TWEAK_NAME = JailedTweak
JailedTweak_FILES = $(wildcard ./*.xm) 

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WeChat"
