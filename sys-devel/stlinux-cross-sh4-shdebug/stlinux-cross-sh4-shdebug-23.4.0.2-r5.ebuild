# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm toolchain-funcs

DESCRIPTION="ST's cross-sh4 gdb"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-cross-sh4-shdebug-4.0.2-5.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND="=sys-devel/stlinux-cross-sh4-gdb-23*
		 =sys-devel/stlinux-cross-sh4-stdcmd-23*"
DEPEND=""

S=${WORKDIR}/opt


src_install () {
	insinto /opt/STM
	cp -a ${S}/STM/* ${D}/opt/STM
}

