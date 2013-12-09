# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit flag-o-matic eutils cross-libtool

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

PATCH_VER="1.5"
DESCRIPTION="GNU debugger"
HOMEPAGE="http://sources.redhat.com/gdb/"
SRC_URI="mirror://wyplay/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
[[ ${CTARGET} != ${CHOST} ]] \
	&& SLOT="${CTARGET}" \
	|| SLOT="0"
KEYWORDS="~sh ~x86"
IUSE="multitarget nls test vanilla"

RDEPEND=">=sys-libs/ncurses-5.2-r2
	sys-libs/readline"
DEPEND="${RDEPEND}
	app-arch/lzma-utils
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	#use vanilla || EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-gdbserver-tid-reuse.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-stsgdb.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-readline_configure.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-sh4_host.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-sh4_target.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-sh4_linux_abi.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-testsuite.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-gdbserver-ps_lgetregs.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-sh-context-switch-nat.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-target-overflow.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-target-solibs.patch
	epatch ${FILESDIR}/${PV}/gdb-${PV}-st40-4.4.0.patch

	## Wyplay Added
	epatch ${FILESDIR}/${PV}/gdb-${PV}-nogdb_info.patch

	strip-linguas -u bfd/po opcodes/po

	echo "STMicroelectronics/Wyplay/Linux Base 6.8" > gdb/version.in
}

src_compile() {
#	strip-unsupported-flags
	replace-flags -O? -O2
	# remove space since it failed with config.cache
	export CPPFLAGS=$(echo $CPPFLAGS | sed -e 's/ +/ /g')
	export LDFLAGS=$(echo $LDFLAGS | sed -e 's/ +/ /g')
	# Needed for doc/chew
	export CFLAGS_FOR_BUILD=""
	export CC_FOR_BUILD=${CBUILD}-gcc

	econf \
		--disable-werror \
		$(has_version '=sys-libs/readline-5*' && echo --with-system-readline) \
		$(use_enable nls) \
		$(use multitarget && echo --enable-targets=all) \
		|| die
	emake -j1 || die
}

src_test() {
	emake check || ewarn "tests failed"
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		libdir=/nukeme/pretty/pretty/please includedir=/nukeme/pretty/pretty/please \
		install || die
	rm -r "${D}"/nukeme || die

	# Don't install docs when building a cross-gdb
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		rm -r "${D}"/usr/share
		return 0
	fi

	dodoc README
	docinto gdb
	dodoc gdb/CONTRIBUTE gdb/README gdb/MAINTAINERS \
		gdb/NEWS gdb/ChangeLog gdb/PROBLEMS
	docinto sim
	dodoc sim/ChangeLog sim/MAINTAINERS sim/README-HACKING

	dodoc "${WORKDIR}"/extra/gdbinit.sample

	# Remove shared info pages
	rm -f "${D}"/usr/share/info/{annotate,bfd,configure,standards}.info*
}

pkg_postinst() {
	# portage sucks and doesnt unmerge files in /etc
	rm -vf "${ROOT}"/etc/skel/.gdbinit
}

