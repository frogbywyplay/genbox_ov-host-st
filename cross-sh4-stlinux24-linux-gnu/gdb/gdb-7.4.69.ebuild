# Copyright 2006-2013 Wyplay. All Rights Reserved.

EAPI=1

inherit eutils

DESCRIPTION="cross-gdb for sh4-stlinux24-linux-gnu"
HOMEPAGE="http://www.gnu.org/software/gdb/"
SRC_URI="mirror://stlinux/gdb-${PV}-stlinux.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86-host"
IUSE="python"
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
!${CATEGORY}/gdb-bin"
S="${WORKDIR}/gdb-7.4"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}"/7.4/gdb-wyplay-find_separate_debug_file_by_debuglink.patch
}

src_compile() {
	CFLAGS="-g -ggdb" econf --target="${CATEGORY/cross-}" \
		--prefix=/usr \
		--disable-nls \
		--disable-gdbserver \
		--disable-werror \
		--enable-shtdi \
		--without-included-gettext \
		--enable-debug \
		--with-sysroot=/usr/targets/current/root \
		$(use_with python) || die "econf failed"
	emake configure-gdb || die "emake configure-gdb failed"

	sed -i -e "s|/usr/lib/libexpat\.so|/usr/lib/libexpat.a|g" gdb/Makefile
	#sed -i -e "s/-lncurses/-Wl,-Bstatic \0 -Wl,-Bdynamic/g" gdb/Makefil
	emake || die "emake failed"
}


src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# cleanup
	rm -f -r "${D}"/usr/share
	rm -f "${D}"/usr/lib/libiberty.a

}
