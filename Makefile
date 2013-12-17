MACHINE := $(shell uname -m)

LIB_DIR = lib
ifeq ($(MACHINE), x86_64)
LIB_DIR = lib64
endif

PREFIX = /usr

TARGET           = cld2
VERSION_MAJOR    = 2
VERSION_MINOR    = 0
VERSION_REVISION = 1

APP_VERSION      = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_REVISION)

BUILD_PATH   = ./build
LIBRARY      = lib$(TARGET).so
LIBRARY_PATH = $(BUILD_PATH)/$(LIBRARY)
TEST         = cld2_unittest_full
TEST_PATH    = $(BUILD_PATH)/$(TEST)

INSTALL_DIR = $(PREFIX)/$(LIB_DIR)
INCLUDE_DIR = $(PREFIX)/include/$(TARGET)

INTERNAL_LIBRARY_INCLUDES := $(shell find ./internal -iname '*.h')
PUBLIC_LIBRARY_INCLUDES   := $(shell find ./public -iname '*.h')

CXX = g++
CXXFLAGS = -fPIC -O2 -m64

LD = $(CXX)

# Extracted from ./internal/compile_libs.sh
ALL_OBJECTS := $(patsubst %.cc, ./internal/%.o, cldutil.cc cldutil_shared.cc \
	compact_lang_det.cc compact_lang_det_hint_code.cc \
	compact_lang_det_impl.cc  debug.cc fixunicodevalue.cc \
	generated_entities.cc  generated_language.cc generated_ulscript.cc  \
	getonescriptspan.cc lang_script.cc offsetmap.cc  scoreonescriptspan.cc \
	tote.cc utf8statetable.cc  \
	cld_generated_cjk_uni_prop_80.cc cld2_generated_cjk_compatible.cc  \
	cld_generated_cjk_delta_bi_32.cc generated_distinct_bi_0.cc  \
	cld2_generated_quad0720.cc cld2_generated_deltaocta0527.cc \
	cld2_generated_distinctocta0527.cc cld_generated_score_quad_octa_1024_256.cc )

# Extracted from ./internal/compile_full.sh
ALL_TEST_OBJECTS := $(patsubst %.cc, ./internal/%.o, cld2_unittest_full.cc \
	cldutil.cc cldutil_shared.cc compact_lang_det.cc  compact_lang_det_hint_code.cc \
	compact_lang_det_impl.cc  debug.cc fixunicodevalue.cc \
	generated_entities.cc  generated_language.cc generated_ulscript.cc  \
	getonescriptspan.cc lang_script.cc offsetmap.cc  scoreonescriptspan.cc \
	tote.cc utf8statetable.cc  \
	cld_generated_cjk_uni_prop_80.cc cld2_generated_cjk_compatible.cc  \
	cld_generated_cjk_delta_bi_32.cc generated_distinct_bi_0.cc  \
	cld2_generated_quad0720.cc cld2_generated_deltaocta0527.cc \
	cld2_generated_distinctocta0527.cc  cld_generated_score_quad_octa_1024_256.cc )

all: $(ALL_OBJECTS)
	@echo Building library...
	@mkdir -p $(BUILD_PATH)
	$(LD) $(LD_FLAGS) -shared -o $(LIBRARY_PATH) $(ALL_OBJECTS)

check: $(ALL_TEST_OBJECTS)
	@echo Building tests...
	@mkdir -p $(BUILD_PATH)
	$(LD) $(LD_FLAGS) -o $(TEST_PATH) $(ALL_TEST_OBJECTS)
	$(TEST_PATH)

install: all
	mkdir -p $(INCLUDE_DIR) $(INSTALL_DIR)
	mkdir -m 755 $(INCLUDE_DIR)/internal $(INCLUDE_DIR)/public
	install -m 644 $(PUBLIC_LIBRARY_INCLUDES) $(INCLUDE_DIR)/public
	install -m 644 $(INTERNAL_LIBRARY_INCLUDES) $(INCLUDE_DIR)/internal
	install -m 755 $(LIBRARY_PATH) $(INSTALL_DIR)/$(LIBRARY).$(APP_VERSION)
	ln -sf $(LIBRARY).$(APP_VERSION) $(INSTALL_DIR)/$(LIBRARY).$(VERSION_MAJOR)
	ln -sf $(LIBRARY).$(APP_VERSION) $(INSTALL_DIR)/$(LIBRARY)
	$(LDCONFIG)

uninstall:
	rm $(INSTALL_DIR)/$(LIBRARY).$(APP_VERSION)
	rm $(INSTALL_DIR)/$(LIBRARY).$(VERSION_MAJOR)
	rm $(INSTALL_DIR)/$(LIBRARY)
	rm -r $(INCLUDE_DIR)

clean:
	@echo Cleaning...
	@find . -regex ".*\.s?o" -exec rm {} +
	@rm -rf ./build

$(OBJECT_PATH)/%.o: $(SRC_PATH)/%.cc
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(COMMON_FLAGS) $(CONFIG_FLAGS) -c -o $@ $<
