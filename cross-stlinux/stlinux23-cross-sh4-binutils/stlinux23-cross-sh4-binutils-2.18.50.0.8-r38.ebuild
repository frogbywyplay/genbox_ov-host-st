# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm stlinux stlinux-toolchain

DESCRIPTION="ST's cross-sh4 binutils"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://cross-stlinux/${PN}-${PVR/-r/-}.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND=""
DEPEND=""

S="${WORKDIR}"/opt
XBINUTILS_VERSION="2.18.50.0.8"

src_install() {
	stlinux_src_install
	stlinux-toolchain-binutils_install
}


