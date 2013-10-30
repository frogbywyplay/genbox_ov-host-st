# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb/gdb-6.4-r5.ebuild,v 1.2 2006/11/13 06:10:31 vapier Exp $

inherit flag-o-matic eutils autotools

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

#DEB_VER=1
DESCRIPTION="GNU debugger"
HOMEPAGE="http://sources.redhat.com/gdb/"
MY_PV=${PV%.*}
MY_P=${P%.*}
SRC_URI="http://ftp.gnu.org/gnu/gdb/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
[[ ${CTARGET} != ${CHOST} ]] \
	&& SLOT="${CTARGET}" \
	|| SLOT="0"
KEYWORDS="x86-host"
IUSE="nls test vanilla"

RDEPEND=">=sys-libs/ncurses-5.2-r2"
DEPEND=" test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )"
CFLAGS_FOR_BUILD="-I/usr/targets/current/root/usr/include"

src_unpack() {
	unpack ${A}
	cd "${MY_P}"
	
	# check if we are cross-compiling for sh4 
	
	####################
	# sh4 dependant patch
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-stsgdb-1.0.patch # 100
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}_ST_1.0-st40-4.0.2.patch #101
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-sh4-linux-awareness.patch #102
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-sh4_linux_abi.patch #103
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-testsuite.patch # 104
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-sh4-cross-build.patch # 107

	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-robustify-module-search.patch # 109
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-optimize-module-and-thread-list-access.patch # 110
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-share-objfiles-for-threads.patch # 111
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-abi-backtracing.patch # 112
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-objdir.patch # 113
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-frame-id-print.patch # 114
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-lib-modules.patch # 115

	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-kgdb_module.patch # 0
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-${MY_PV}-dont-repeat-top-level.patch # 1

	strip-linguas -u bfd/po opcodes/po
}

src_compile() {
	replace-flags -O? -O2

	# Needed for doc/chew
	export CFLAGS_FOR_BUILD=""
	export CC_FOR_BUILD=${CBUILD}-gcc
	
	cd ${WORKDIR}/${MY_P}
	# autoheader
	autoconf
	# these patch need to be applied after autoconf stuff 
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-6.4-sh-context-switch.patch # 105
	epatch "${FILESDIR}"/${PV}/st_patches/gdb-6.4-sh-core.patch # 106
	econf \
		--disable-werror \
		--disable-gdbtk \
		$(use_enable nls) \
		|| die

	
	emake -j1 || die
}

src_test() {
	make check || ewarn "tests failed"
}

src_install() {
	cd ${WORKDIR}/${MY_P}
	make \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		libdir="${D}"/nukeme includedir="${D}"/nukeme \
		install || die "install"

	# The includes and libs are in binutils already
	rm -r "${D}"/nukeme

	# Don't install docs when building a cross-gdb
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		rm -r "${D}"/usr/share
		return 0
	fi

	dodoc README
	docinto gdb
	dodoc gdb/CONTRIBUTE gdb/README gdb/MAINTAINERS \
		gdb/NEWS gdb/ChangeLog* gdb/TODO
	docinto sim
	dodoc sim/ChangeLog sim/MAINTAINERS sim/README-HACKING
	docinto mmalloc
	dodoc mmalloc/MAINTAINERS mmalloc/ChangeLog mmalloc/TODO

	if use x86 ; then
		dodir /etc/skel/
		cp "${S}"/gdb_init.txt "${D}"/etc/skel/.gdbinit \
			|| die "install ${D}/etc/skel/.gdbinit"
	fi

	if ! has noinfo ${FEATURES} ; then
		make \
			infodir="${D}"/usr/share/info \
			install-info \
			|| die "install doc info"
		# Remove shared info pages
		rm -f "${D}"/usr/share/info/{annotate,bfd,configure,standards}.info*
	fi
}
