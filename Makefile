MACHINE := $(shell uname -m)

ifeq ($(MACHINE), x86_64)
libdir = lib64
endif
ifeq ($(MACHINE), i686)
libdir = lib
endif

TARGET      = cld2
LIBRARY     = lib$(TARGET).so
TEST        = compact_lang_det_test_full0720

INSTALL_DIR = $(PREFIX)/${libdir}
INCLUDE_DIR = $(PREFIX)/include/$(TARGET)

all: 
	cd internal; ./compile_libs.sh

test:
	cd internal; ./compile_full.sh; ./$(TEST)

install: all
	mkdir -p ${INSTALL_DIR} ${INCLUDE_DIR}; \
	cp ./internal/$(LIBRARY) $(INSTALL_DIR)/${LIBRARY}; \
	cp -R ./public $(INCLUDE_DIR)/

uninstall:
	rm $(INSTALL_DIR)/$(LIBRARY); \
		rm -r $(INCLUDE_DIR)

clean:
	find . -regex ".*\.s?o" -exec rm {} +
