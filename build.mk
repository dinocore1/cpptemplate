

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

define compile_c
$(eval LOCAL_OBJS += $(OBJ))
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
$(LOCAL_ARTIFACT): $(LOCAL_OBJS)
	$(LOCAL_LD) $(LOCAL_LD_FLAGS) -o $(LOCAL_ARTIFACT) $(LOCAL_OBJS)

endef

define compile
$(LOCAL_BUILD_DIR):
	mkdir -p $(LOCAL_BUILD_DIR)

$(foreach SRC,$(LOCAL_C_FILES),$(eval $(call compile_c)))
$(foreach SRC,$(LOCAL_CPP_FILES),$(eval $(call compile_cpp)))
endef

define newmodule
MODULE :=
SRC_FILES :=
INCLUDES :=
LD_FLAGS :=
C_FLAGS :=
CPP_FLAGS :=
CXX_FLAGS :=
endef

define module
$(eval ALL_MODULES += $(MODULE))
$(eval LOCAL_C_FLAGS := $(include_flags) $(C_FLAGS))
$(eval LOCAL_CXX_FLAGS := $(include_flags) $(CXX_FLAGS))
$(eval LOCAL_SRCS := $(LOCAL_C_FILES) $(LOCAL_CPP_FILES))
$(eval LOCAL_BUILD_DIR := $(BUILD_DIR)/$(MODULE))
$(eval LOCAL_OBJS := )

$(call compile)

endef

define build_exe
$(eval $(call module))
$(eval LOCAL_ARTIFACT := $(LOCAL_BUILD_DIR)/$(MODULE))
$(eval ALL_EXE += $(LOCAL_ARTIFACT))
$(eval LOCAL_LD ?= $(CXX))
$(eval LOCAL_LD_FLAGS := $(LD_FLAGS))
$(eval $(call link))

$(info module=$(MODULE))
$(info src files=$(LOCAL_SRCS))
$(info objs=$(LOCAL_OBJS))
$(info ALL_EXE=$(ALL_EXE))
endef

