.PHONY: all clean info

CC ?= cc
CXX ?= c++
BUILD_DIR := build

all: 

clean:
	rm -rf $(BUILD_DIR)

include build.mk

$(eval $(call newmodule))
MODULE := hello
SRC_FILES := hello.cc
$(eval $(call build_exe))


