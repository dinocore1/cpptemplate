.PHONY: all clean info

CC ?= cc
CXX ?= c++
BUILD_DIR := build

all: modules

clean:
	rm -rf $(BUILD_DIR)

include build.mk

$(eval $(call newmodule))
MODULE := hello
INCLUDES := src
SRC_FILES := hello.cc
LINK_DEPEND := mylib
$(eval $(call build_exe))

$(eval $(call newmodule))
MODULE := mylib
SRC_FILES := lib1.cpp
$(eval $(call build_sharedlib))

modules: $(ALL_EXE) $(ALL_LIB)
