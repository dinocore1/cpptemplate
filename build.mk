

LOCAL_CPP_FILES = \
	$(sort $(strip \
	$(filter %.cpp,$(SRC_FILES)) \
	$(filter %.cxx,$(SRC_FILES)) \
	$(filter %.cc,$(SRC_FILES)))) \

LOCAL_C_FILES = \
	$(sort $(strip $(filter %.c,$(SRC_FILES))))

OBJ = $(LOCAL_BUILD_DIR)/$(addsuffix .o,$(notdir $(SRC)))

define include_flags
$(addprefix -I,$(INCLUDES))
endef

define link_dependencies
$(foreach mod,$(LOCAL_LINK_DEPEND),$$($(mod)_ARTIFACT))
endef

define compile_c
LOCAL_OBJS += $(OBJ)
$(OBJ): $(SRC) | $(LOCAL_BUILD_DIR)
	echo "building $(OBJ)"
	$(CC) -c $(LOCAL_C_FLAGS) -o $(OBJ) $(SRC)

endef

define compile_cpp
$(eval LOCAL_OBJS += $(OBJ))
$(OBJ): $(SRC) | $(LOCAL_BUILD_DIR)
	echo "building $(OBJ)"
	$(CXX) -c $(LOCAL_CXX_FLAGS) -o $(OBJ) $(SRC)

endef

define link
$(LOCAL_ARTIFACT): $(LOCAL_OBJS) $(LOCAL_LINK_DEPEND)
	$(LOCAL_LD) $(LOCAL_LD_FLAGS) -o $(LOCAL_ARTIFACT) $(LOCAL_OBJS)

endef

define compile
$(LOCAL_BUILD_DIR):
	mkdir -p $(LOCAL_BUILD_DIR)

$(foreach SRC,$(LOCAL_C_FILES),$(call compile_c))
$(foreach SRC,$(LOCAL_CPP_FILES),$(call compile_cpp))
endef

define newmodule
MODULE :=
SRC_FILES :=
INCLUDES :=
LD_FLAGS :=
C_FLAGS :=
CPP_FLAGS :=
CXX_FLAGS :=
LINK_DEPEND :=
COMPILE_DEPEND :=
endef

define module
ALL_MODULES += $(MODULE)
LOCAL_C_FLAGS := $(include_flags) $(C_FLAGS)
LOCAL_CXX_FLAGS := $(include_flags) $(CXX_FLAGS)
LOCAL_LD ?= $(CXX)
LOCAL_LD_FLAGS := $(LD_FLAGS)
LOCAL_SRCS := $(LOCAL_C_FILES) $(LOCAL_CPP_FILES)
LOCAL_BUILD_DIR := $(BUILD_DIR)/$(MODULE)
LOCAL_LINK_DEPEND := $(LINK_DEPEND)
LOCAL_OBJS := 
endef

define build_exe
$(eval $(MODULE)_TYPE := exe)
$(eval $(call module))
$(eval LOCAL_ARTIFACT := $(LOCAL_BUILD_DIR)/$(MODULE))
$(eval ALL_EXE += $(LOCAL_ARTIFACT))
$(eval $(MODULE)_ARTIFACT := $(LOCAL_ARTIFACT))
$(eval $(MODULE): $(LOCAL_ARTIFACT))
$(call compile)
$(call link)

endef

define build_sharedlib
$(eval $(MODULE)_TYPE := sharedlib)
$(eval $(call module))
$(eval LOCAL_ARTIFACT := $(LOCAL_BUILD_DIR)/$(MODULE).so)
$(eval ALL_LIBS += $(LOCAL_ARTIFACT))
$(eval $(MODULE)_ARTIFACT := $(LOCAL_ARTIFACT))
$(eval $(MODULE): $(LOCAL_ARTIFACT))
$(call compile)
$(call link)
endef

