# Copyright 2006-2013 Wyplay. All Rights Reserved.

PATCH_VER="1.10"
UCLIBC_VER="1.1"

BRANCH_UPDATE=""

ETYPE="gcc-compiler"

# whether we should split out specs files for multiple {PIE,SSP}-by-default
# and vanilla configurations.
SPLIT_SPECS=no #${SPLIT_SPECS-true} hard disable until #106690 is fixed

inherit toolchain

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking"

#MY_P="stlinux22-cross-gcc-4.1.1-21.src.rpm"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="x86-host"
#SRC_URI="http://mirrors.wyplay.int/STLinux/2.2/SRPMS/${MY_P}"

RDEPEND=">=sys-libs/zlib-1.1.4
	|| ( >=sys-devel/gcc-config-1.3.12-r4 app-admin/eselect-compiler )
	virtual/libiconv
	fortran? (
		>=dev-libs/gmp-4.2.1
		>=dev-libs/mpfr-2.2.0_p10
	)
	!build? (
		gcj? (
			gtk? (
				|| ( ( x11-libs/libXt x11-libs/libX11 x11-libs/libXtst x11-proto/xproto x11-proto/xextproto ) virtual/x11 )
				>=x11-libs/gtk+-2.2
				x11-libs/pango
			)
			>=media-libs/libart_lgpl-2.1
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
PDEPEND="|| ( sys-devel/gcc-config app-admin/eselect-compiler )"
if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.3.6 )"
fi

src_unpack() {
	gcc_src_unpack

	use vanilla && return 0

	if [[ $(tc-arch) == "sh" ]]; then
		# Apply ST patches
		epatch ${FILESDIR}/st_patches/gcc-4.1.1-st40r2-4.0.1.patch
        	epatch ${FILESDIR}/st_patches/gcc-4.1.1-st40r2-4.0.1-no-cbranchdi.patch
		epatch ${FILESDIR}/st_patches/gcc-4.1.1-cross_search_paths-sh4.patch
		epatch ${FILESDIR}/st_patches/gcc-4.1.1-recursive_inline_fix.patch
		#epatch ${FILESDIR}/st_patches/gcc-4.1.1-linux-multilib-fix.patch
        	epatch ${FILESDIR}/st_patches/gcc-4.1.1-PR27781-fix.patch
	fi

# Useless for Wyplay
#	[[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env.patch

	# Fix cross-compiling
	epatch "${FILESDIR}"/gcc-4.1.0-cross-compile.patch

# Useless for Wyplay
#	[[ ${CTARGET} == *-softfloat-* ]] && epatch "${FILESDIR}"/4.0.2/gcc-4.0.2-softfloat.patch

# Useless for Wyplay
#	epatch "${FILESDIR}"/4.1.0/gcc-4.1.0-fast-math-i386-Os-workaround.patch
}
