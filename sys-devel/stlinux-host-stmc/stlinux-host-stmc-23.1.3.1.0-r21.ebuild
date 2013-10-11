# Copyright 2007 Wyplay
# $Header: $

inherit rpm toolchain-funcs eutils

DESCRIPTION="ST Micro Connection Package"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-host-stmc-1.3.1.0-21.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND="!sys-devel/stlinux-host-havana-stmc"
DEPEND=""

S=${WORKDIR}/opt

src_install () {
	insinto /opt/STM
	cp -a ${S}/STM/* ${D}/opt/STM
}

