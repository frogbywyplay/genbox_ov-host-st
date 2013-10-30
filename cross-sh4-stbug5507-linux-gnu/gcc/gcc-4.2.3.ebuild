# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.2.3.ebuild,v 1.3 2008/03/20 20:39:50 vapier Exp $

#Wyplay
# Disable apply of Gentoo patch
#PATCH_VER="1.0"
#UCLIBC_VER="1.0"

ETYPE="gcc-compiler"

# whether we should split out specs files for multiple {PIE,SSP}-by-default
# and vanilla configurations.
SPLIT_SPECS=no #${SPLIT_SPECS-true} hard disable until #106690 is fixed

inherit toolchain

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~sh ~x86"

RDEPEND=">=sys-libs/zlib-1.1.4
	>=sys-devel/gcc-config-1.4
	virtual/libiconv
	fortran? (
		>=dev-libs/gmp-4.2.1
		>=dev-libs/mpfr-2.2.0_p10
	)
	!build? (
		gcj? (
			gtk? (
				x11-libs/libXt
				x11-libs/libX11
				x11-libs/libXtst
				x11-proto/xproto
				x11-proto/xextproto
				>=x11-libs/gtk+-2.2
				x11-libs/pango
			)
			>=media-libs/libart_lgpl-2.1
			app-arch/zip
			app-arch/unzip
		)
		>=sys-libs/ncurses-5.2-r2
		nls? ( sys-devel/gettext )
	)"
DEPEND="${RDEPEND}
	test? ( sys-devel/autogen dev-util/dejagnu )
	>=sys-apps/texinfo-4.2-r4
	>=sys-devel/bison-1.875
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"
PDEPEND=">=sys-devel/gcc-config-1.4"
if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.3.6 )"
fi

src_unpack() {
	#gcc_src_unpack
	unpack ${P}.tar.bz2
	cd "${S}"

	use vanilla && return 0
	if [[ $(tc-arch) == "sh" ]]; then
		# Apply ST patches
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-cross_search_paths-1.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-stm-release.patch
		# SH4 common
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-st40r2-4.2.1.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-linux-multilib-fix.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-sh-use-gnu-hash-style.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-sh-linux-atomic-fixes.patch
		# SH4 uClibc
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-conf.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-locale.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-missing-execinfo_h.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-snprintf.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-complex-ugly-hack.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-libstdc++-namespace.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-libbackend_dep_gcov-iov.h.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-flatten-switch-stmt-00.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-locale_facets.patch
		epatch ${FILESDIR}/st_patches/${PV}/gcc-4.2.3-uclibc-libstdc++_no_nls.patch
	fi

	# Useless for Wyplay (NEED CHECK)
	# [[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env.patch

	# Fix cross-compiling
	epatch "${FILESDIR}"/gcc-4.1.0-cross-compile.patch

	# Useless for Wyplay (NEED CHECK)
	# [[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/4.0.2/gcc-4.0.2-softfloat.patch
}
