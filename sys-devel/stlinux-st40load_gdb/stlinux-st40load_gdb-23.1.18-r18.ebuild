# Copyright 2007 Wyplay
# $Header: $

inherit rpm toolchain-funcs

DESCRIPTION="ST's ST40 Loader for STLinux23"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-cross-sh4-st40load_gdb-1.18-18.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND="=sys-devel/stlinux-cross-sh4-binutils-23*"
DEPEND=""

S=${WORKDIR}/opt


src_install () {
	insinto /opt/STM
	cp -a ${S}/STM/* ${D}/opt/STM
}

