# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm toolchain-funcs

DESCRIPTION="ST's cross-sh4 binutils"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-cross-sh4-binutils-2.18.50.0.8-24.i386.rpm"

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

