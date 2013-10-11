# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb/gdb-6.8-r2.ebuild,v 1.1 2009/03/12 03:16:50 vapier Exp $

inherit rpm flag-o-matic autotools eutils cross-libtool

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

PATCH_VER="1.5"
DESCRIPTION="GNU debugger"
HOMEPAGE="http://sources.redhat.com/gdb/"

MY_P=${P/_p*/}
SRC_URI="mirror://wyplay/${MY_P}.tar.gz"
SRC_URI="ftp://ftp.stlinux.com/pub/stlinux/2.3/updates/SRPMS/stlinux23-cross-gdb-6.8-45.src.rpm"

COMPILER_DIR=/opt/STM/STLinux-2.3/devkit/sh4/

LICENSE="GPL-2 LGPL-2"
[[ ${CTARGET} != ${CHOST} ]] \
	&& SLOT="${CTARGET}" \
	|| SLOT="0"
KEYWORDS="x86-host"
IUSE="multitarget nls test vanilla"

RDEPEND=">=sys-libs/ncurses-5.2-r2
	sys-libs/readline"
DEPEND="${RDEPEND}
	app-arch/lzma-utils
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )"

MY_PV=${PV/_p*/}
S=${WORKDIR}/${MY_P}
src_unpack() {
	rpm_src_unpack ${A}
	cd "${S}"


# The bulk of the patches are for both sh4 and arm
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-stsgdb.patch #101
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-sh4_linux_abi.patch #102
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-testsuite.patch #103
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-sh4-cross-build.patch #104
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-sh-context-switch.patch #107
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-sh-core.patch #108
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-fix-debug-target-remove-watchpoint.patch #109
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-frame-sniffer.patch #110
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-pending-breaks-mi.patch #111
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-sh-config-h.patch #112
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-linux-awareness.patch #115
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-fix-module-relocation-bug.patch #116
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-remove-bad-xfree.patch #117
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-improve-module-handling.patch #118
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-statically-link-libexpat.patch #119
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-tlb-reprogramming.patch #120
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-fix-dmesg.patch #121
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-sh-default-arch.patch #122
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-st40-4.4.0.patch #123
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-add-support-for-new-kernels.patch #124
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-2.6.30_support.patch #125
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-pending-break-segfault.patch #126
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-various-fixes-and-improvements.patch #127
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-support-separate-debuginfo-files.patch #128
	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-fix-hw-singlestep-vs-tlbmiss.patch #129

# The st231 sources are seperate to the other architectures
	# EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-st200.patch #200

# A few arm-only patches
#	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/sts-arm${MY_P}.patch #300
#	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-armgdb-fixes.patch #301


	EPATCH_LEVEL=1 epatch "${FILESDIR}"/${PV}/${MY_P}-kgdb_module.patch #0

# cortex
	# epatch "${FILESDIR}"/${PV}/gdb6.8-va_list.patch #1

	# epatch "${FILESDIR}"/${PV}/gdb6.8-configure-tgt-cortex.patch #100

# arm only
#	Epatch_LEVEL=1 epatch "${FILESDIR}"/${PV}/gdb-6.8-64-bit-support.patch #400

	epatch "${FILESDIR}"/${PV}/${MY_P}-wyplay-fix-compilation.patch
	
	epatch "${FILESDIR}"/${PV}/${MY_P}-wyplay-fix-debug-file-directory.patch

	epatch "${FILESDIR}"/${PV}/${MY_P}-wyplay-test-debug-file-directory.patch

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

	# need to regenerate config.in and configure.ac since target detection is modified
	cd gdb
	AT_NO_RECURSIVE=1 eautoreconf || die "autoreconf failed"
	cd ..
	echo "STMicroelectronics/Wyplay/Linux Base 6.8" > gdb/version.in

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
	# create a gdbinit file template in workdir tmp
	cat > ${T}/dot-shgdbinit <<-EOF
# Cross GDB SH4 init file for setting Genbox target paths

set target-path /usr/targets/current/root
set solib-absolute-prefix /usr/targets/current/root
set debug-file-directory /usr/targets/current/root/usr/lib/debug

# Helper for debugging Python (gets the function line number)

define pyframe
x/s ((PyStringObject*)f->f_code->co_filename)->ob_sval
x/s ((PyStringObject*)f->f_code->co_name)->ob_sval
p f->f_lineno
end

EOF

	# install it into /root
	insinto /root
	for f in shgdbinit; do
		newins ${T}/dot-${f} .${f}
	done
	einfo "/root/.shgdbinit template created."

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

