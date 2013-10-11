# Copyright 2007 Wyplay
# $Header: $

inherit rpm toolchain-funcs

DESCRIPTION="ST's cross-sh4 gdb"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-cross-sh4-gdb-6.5-33.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND=""
DEPEND=""

S=${WORKDIR}/opt


src_install () {
	insinto /opt/STM
	cp -a ${S}/STM/* ${D}/opt/STM
}

