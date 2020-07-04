
LOCAL_CPP_FILES = \
	$(sort $(strip \
	$(filter %.cpp,$(SRC_FILES)) \
	$(filter %.cxx,$(SRC_FILES)) \
	$(filter %.cc,$(SRC_FILES)))) \

LOCAL_C_FILES = \
	$(sort $(strip $(filter %.c,$(SRC_FILES))))

define src_to_obj
$(foreach file,$(LOCAL_SRCS),$(LOCAL_BUILD_DIR)/$(addsuffix .o,$(notdir $(file))))
endef

define newmodule
MODULE :=
SRC_FILES :=
LD_FLAGS :=
C_FLAGS :=
CPP_FLAGS :=
endef

define module
$(eval ALL_MODULES += $(MODULE))
$(eval LOCAL_SRCS := $(LOCAL_C_FILES) $(LOCAL_CPP_FILES))
$(eval LOCAL_BUILD_DIR := $(BUILD_DIR)/$(MODULE))
$(eval LOCAL_OBJS := $(call src_to_obj))
endef

define build_exe
$(eval $(call module))
$(info module=$(MODULE))
$(info src files $(LOCAL_SRCS))
$(info objs $(LOCAL_OBJS))
endef

