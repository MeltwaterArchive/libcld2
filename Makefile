MACHINE := $(shell uname -m)

ifeq ($(MACHINE), x86_64)
libdir = lib64
endif
ifeq ($(MACHINE), i686)
libdir = lib
endif

ifndef $(PREFIX)
PREFIX = /usr
endif

TARGET           = cld2
VERSION_MAJOR    = 2
VERSION_MINOR    = 0
VERSION_REVISION = 0

APP_VERSION      = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_REVISION)

LIBRARY     = lib$(TARGET).so
LIBRARY_DIR = ./internal/$(LIBRARY)
TEST        = compact_lang_det_test_full0720

INSTALL_DIR = $(PREFIX)/${libdir}
INCLUDE_DIR = $(PREFIX)/include/$(TARGET)

INTERNAL_LIBRARY_INCLUDES := $(shell find ./internal -iname '*.h')
PUBLIC_LIBRARY_INCLUDES   := $(shell find ./public -iname '*.h')

all: 
	@echo Building library...
	@cd internal; ./compile_libs.sh

test:
	@echo Building tests...
	@cd internal; ./compile_full.sh
	./$(TEST)

install: all
	mkdir -p $(INCLUDE_DIR) $(INSTALL_DIR)
	mkdir -m 755 $(INCLUDE_DIR)/internal $(INCLUDE_DIR)/public
	install -m 644 $(PUBLIC_LIBRARY_INCLUDES) $(INCLUDE_DIR)/public
	install -m 644 $(INTERNAL_LIBRARY_INCLUDES) $(INCLUDE_DIR)/internal
	install -m 755 $(LIBRARY_DIR) $(INSTALL_DIR)/$(LIBRARY).$(APP_VERSION)
	ln -sf $(LIBRARY).$(APP_VERSION) $(INSTALL_DIR)/$(LIBRARY).$(VERSION_MAJOR)
	ln -sf $(LIBRARY).$(APP_VERSION) $(INSTALL_DIR)/$(LIBRARY)
	$(LDCONFIG)

uninstall:
	rm $(INSTALL_DIR)/$(LIBRARY).$(APP_VERSION)
	rm $(INSTALL_DIR)/$(LIBRARY).$(VERSION_MAJOR)
	rm $(INSTALL_DIR)/$(LIBRARY)
	rm -r $(INCLUDE_DIR)

clean:
	find . -regex ".*\.s?o" -exec rm {} +
