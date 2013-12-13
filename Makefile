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

TARGET      = cld2
LIBRARY     = lib$(TARGET).so
TEST        = compact_lang_det_test_full0720

INSTALL_DIR = $(PREFIX)/${libdir}
INCLUDE_DIR = $(PREFIX)/include/$(TARGET)

all: 
	cd internal; ./compile_libs.sh

test:
	cd internal; ./compile_full.sh
	./$(TEST)

install: all
	mkdir -p ${INSTALL_DIR} ${INCLUDE_DIR}/internal; \
	cp ./internal/$(LIBRARY) $(INSTALL_DIR)/${LIBRARY}; \
	cp -R ./public $(INCLUDE_DIR)/; \
	cp -R ./internal/*.h $(INCLUDE_DIR)/internal

uninstall:
	rm $(INSTALL_DIR)/$(LIBRARY); \
	rm -r $(INCLUDE_DIR)

clean:
	find . -regex ".*\.s?o" -exec rm {} +
