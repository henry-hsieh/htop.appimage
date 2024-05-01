prefix ?= /usr/local/
build_dir ?= $(CURDIR)/build
appimage_dir ?= $(build_dir)/AppDir
install_prefix := $(appimage_dir)/usr
packages_dir ?= $(CURDIR)/packages
htop_ver := $(shell cat $(packages_dir)/htop.yaml | grep version | sed 's/.\+:\s//g')
ncurses_ver := $(shell cat $(packages_dir)/ncurses.yaml | grep version | sed 's/.\+:\s//g')
sensors_ver := $(shell cat $(packages_dir)/sensors.yaml | grep version | sed 's/.\+:\s//g')
libcap_ver := $(shell cat $(packages_dir)/libcap.yaml | grep version | sed 's/.\+:\s//g')
hwloc_ver := $(shell cat $(packages_dir)/hwloc.yaml | grep version | sed 's/.\+:\s//g')
libnl_ver := $(shell cat $(packages_dir)/libnl.yaml | grep version | sed 's/.\+:\s//g')
runtime_libs := libncursesw.so libtinfow.so libsensors.so libcap.so libhwloc.so libnl-3.so libnl-genl-3.so
runtime_libs_src := $(addprefix $(build_dir)/deps/lib/,$(runtime_libs))
runtime_libs_dst := $(addprefix $(appimage_dir)/usr/lib/,$(runtime_libs))

all: $(appimage_dir)/usr/bin/htop $(runtime_libs_dst)

# htop
$(appimage_dir)/usr/bin/htop: $(build_dir)/htop-$(htop_ver)/htop
	@$(MAKE) install -C $(build_dir)/htop-$(htop_ver)/

$(build_dir)/htop-$(htop_ver)/htop: $(runtime_libs_src) | $(build_dir)/htop-$(htop_ver).tar.xz
	@cd $(build_dir)/htop-$(htop_ver); \
		export LD_LIBRARY_PATH="$(build_dir)/deps/lib:${LD_LIBRARY_PATH}"; \
		./autogen.sh; \
		CFLAGS="           $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --cflags $(build_dir)/deps/lib/pkgconfig/ncursesw.pc      )  \
		                   $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --cflags $(build_dir)/deps/lib/pkgconfig/libcap.pc        )" \
		HWLOC_CFLAGS="     $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --cflags $(build_dir)/deps/lib/pkgconfig/hwloc.pc         )" \
		LIBNL3_CFLAGS="    $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --cflags $(build_dir)/deps/lib/pkgconfig/libnl-3.0.pc     )" \
		LIBNL3GENL_CFLAGS="$(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --cflags $(build_dir)/deps/lib/pkgconfig/libnl-genl-3.0.pc)" \
		LDFLAGS="          $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --libs   $(build_dir)/deps/lib/pkgconfig/ncursesw.pc      )  \
		                   $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --libs   $(build_dir)/deps/lib/pkgconfig/libcap.pc        )" \
		HWLOC_LIBS="       $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --libs   $(build_dir)/deps/lib/pkgconfig/hwloc.pc         )" \
		LIBNL3_LIBS="      $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --libs   $(build_dir)/deps/lib/pkgconfig/libnl-3.0.pc     )" \
		LIBNL3GENL_LIBS="  $(shell PKG_CONFIG_PATH=$(build_dir)/deps/lib/pkgconfig/ pkg-config --libs   $(build_dir)/deps/lib/pkgconfig/libnl-genl-3.0.pc)" \
		./configure --prefix=$(appimage_dir)/usr --enable-sensors --enable-capabilities --enable-hwloc --enable-delayacct --enable-openvz --enable-vserver; \
		$(MAKE)

$(build_dir)/deps/lib/libncursesw.so: | $(build_dir)/ncurses-$(ncurses_ver).tar.gz $(build_dir)/deps
	@cd $(build_dir)/ncurses-$(ncurses_ver); \
		./configure --prefix=$(build_dir)/deps --with-shared --without-normal --without-debug --with-termlib \
		--with-pkg-config=$(build_dir)/deps/lib/pkgconfig/ --with-pkg-config-libdir=$(build_dir)/deps/lib \
		--enable-widec --enable-ext-colors --enable-ext-mouse --enable-bsdpad --enable-opaque-curses --enable-pc-files --enable-symlinks; \
		$(MAKE); \
		$(MAKE) install.includes; \
		$(MAKE) install.libs

$(build_dir)/deps/lib/libtinfow.so: $(build_dir)/deps/lib/libncursesw.so

$(build_dir)/deps/lib/libsensors.so: | $(build_dir)/lm-sensors-$(sensors_ver).tar.gz $(build_dir)/deps
	@cd $(build_dir)/lm-sensors-$(sensors_ver); \
		$(MAKE); \
		$(MAKE) install PREFIX=$(build_dir)/deps ETCDIR=$(build_dir)/deps/etc

$(build_dir)/deps/lib/libcap.so: | $(build_dir)/libcap-$(libcap_ver).tar.gz $(build_dir)/deps
	@cd $(build_dir)/libcap-$(libcap_ver); \
		$(MAKE) install prefix=$(build_dir)/deps lib=/lib

$(build_dir)/deps/lib/libhwloc.so: | $(build_dir)/hwloc-$(hwloc_ver).tar.gz $(build_dir)/deps
	@cd $(build_dir)/hwloc-$(hwloc_ver); \
		./autogen.sh; \
		./configure --prefix=$(build_dir)/deps; \
		$(MAKE); \
		$(MAKE) install

$(build_dir)/deps/lib/libnl-3.so: | $(build_dir)/libnl-$(libnl_ver).tar.gz $(build_dir)/deps
	@cd $(build_dir)/libnl-$(libnl_ver); \
		./configure --prefix=$(build_dir)/deps; \
		$(MAKE); \
		$(MAKE) install

$(build_dir)/deps/lib/libnl-genl-3.so: $(build_dir)/deps/lib/libnl-3.so

# Download files
$(build_dir)/htop-$(htop_ver).tar.xz:
	@$(CURDIR)/download_file.sh https://github.com/htop-dev/htop/releases/download/$(htop_ver)/htop-$(htop_ver).tar.xz $(build_dir)/htop-$(htop_ver).tar.xz
	@tar -axf $(build_dir)/htop-$(htop_ver).tar.xz -C $(build_dir)

$(build_dir)/ncurses-$(ncurses_ver).tar.gz:
	@$(CURDIR)/download_file.sh https://invisible-mirror.net/archives/ncurses/ncurses-$(ncurses_ver).tar.gz $(build_dir)/ncurses-$(ncurses_ver).tar.gz
	@tar -axf $(build_dir)/ncurses-$(ncurses_ver).tar.gz -C $(build_dir)

$(build_dir)/lm-sensors-$(sensors_ver).tar.gz:
	@$(CURDIR)/download_file.sh https://github.com/lm-sensors/lm-sensors/archive/refs/tags/V$(sensors_ver).tar.gz $(build_dir)/lm-sensors-$(sensors_ver).tar.gz
	@tar -axf $(build_dir)/lm-sensors-$(sensors_ver).tar.gz -C $(build_dir)

$(build_dir)/libcap-$(libcap_ver).tar.gz:
	@$(CURDIR)/download_file.sh https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/libcap-$(libcap_ver).tar.gz $(build_dir)/libcap-$(libcap_ver).tar.gz
	@tar -axf $(build_dir)/libcap-$(libcap_ver).tar.gz -C $(build_dir)

$(build_dir)/hwloc-$(hwloc_ver).tar.gz:
	@$(CURDIR)/download_file.sh https://github.com/open-mpi/hwloc/archive/refs/tags/hwloc-$(hwloc_ver).tar.gz $(build_dir)/hwloc-$(hwloc_ver).tar.gz
	@tar -axf $(build_dir)/hwloc-$(hwloc_ver).tar.gz -C $(build_dir)
	@mv $(build_dir)/hwloc-hwloc-$(hwloc_ver) $(build_dir)/hwloc-$(hwloc_ver)

$(build_dir)/libnl-$(libnl_ver).tar.gz:
	@$(CURDIR)/download_file.sh https://www.infradead.org/~tgr/libnl/files/libnl-$(libnl_ver).tar.gz $(build_dir)/libnl-$(libnl_ver).tar.gz
	@tar -axf $(build_dir)/libnl-$(libnl_ver).tar.gz -C $(build_dir)

# runtime-libs
$(appimage_dir)/usr/lib/%.so: $(build_dir)/deps/lib/%.so | $(appimage_dir)/usr/lib
	/usr/bin/cp -P --preserve=mode,timestamps $<* $(appimage_dir)/usr/lib/

# mkdir
$(build_dir)/deps:
	@mkdir -p $(build_dir)/deps

$(appimage_dir)/usr/lib:
	@mkdir -p $(appimage_dir)/usr/lib

clean:
	rm -rf $(build_dir) $(appimage_dir)
