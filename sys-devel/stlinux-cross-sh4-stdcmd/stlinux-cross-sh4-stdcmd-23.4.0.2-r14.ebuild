# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit eutils rpm 

DESCRIPTION="JTAG Init commands"
HOMEPAGE="http://www.wyplay.com/"
SRC_URI="mirror://stlinux/stlinux23-cross-sh4-stdcmd-4.0.2-14.i386.rpm"

LICENSE="Wyplay"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/opt

src_install () {
	insinto /opt/STM
	cp -a ${S}/STM/* ${D}/opt/STM
}

