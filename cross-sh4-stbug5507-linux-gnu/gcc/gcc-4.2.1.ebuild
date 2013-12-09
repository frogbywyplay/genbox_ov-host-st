# Copyright 2006-2013 Wyplay. All Rights Reserved.

#Wyplay
# Disable apply of Gentoo patch
#PATCH_VER="1.0"
#UCLIBC_VER="1.0"

ETYPE="gcc-compiler"

# whether we should split out specs files for multiple {PIE,SSP}-by-default
# and vanilla configurations.
SPLIT_SPECS=no #${SPLIT_SPECS-true} hard disable until #106690 is fixed

inherit toolchain xdistcc

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="sh x86"

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
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-cross_search_paths-1.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-stm-release.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-makeinfo.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-stm_sh_R4.1_070806.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-linux-multilib-fix.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-sh-use-gnu-hash-style.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-dwarfreg-fix.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-packed_align.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-sh-linux-atomic-fixes.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-switch-tbit.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-static_dtors.patch
		epatch ${FILESDIR}/st_patches/gcc-4.2.1-sh_cond_branch_size.patch
	fi

	# Useless for Wyplay (NEED CHECK)
	# [[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env.patch

	# Fix cross-compiling
	epatch "${FILESDIR}"/gcc-4.1.0-cross-compile.patch

	# Useless for Wyplay (NEED CHECK)
	# [[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/4.0.2/gcc-4.0.2-softfloat.patch
}

pkg_postinst() {
	toolchain_pkg_postinst
	xdistcc_pkg_postinst
}

pkg_postrm() {
	toolchain_pkg_postrm
	xdistcc_pkg_postrm
}

