.PHONY: all clean

CXX := c++
BUILD_DIR := build

all: $(ALL_EXE) $(ALL_LIBS) $(ALL_TESTS)

include makelib/definitions.mk

MODULE := module1
CPP_FLAGS :=
LD_FLAGS := 
SRC_FILES := \
	src/file1.cxx \
	src/file2.cxx \
	src/file3.cc \
	src/file4.c

$(eval $(call build_exe))

MODULE := module2
SRC_FILES := kewl.cc

$(eval $(call build_exe))

MODULE := hello
SRC_FILES := hello.cc

$(eval $(call build_exe))


$(info allmodules $(ALL_EXE))

