# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm stlinux stlinux-toolchain

DESCRIPTION="STLinux 2.3 cross-sh4 gcc"
HOMEPAGE="http://stlinux.com"
SRC_URI="mirror://cross-stlinux/${PN}-${PVR/-r/-}.i386.rpm
	mirror://cross-stlinux/${PN/gcc/g++}-${PVR/-r/-}.i386.rpm
	mirror://cross-stlinux/${PN/gcc/cpp}-${PVR/-r/-}.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/opt
COMPILER_DIR="/opt/STM/STLinux-2.3/devkit/sh4_uclibc/"
SYSTEM_TUPLES="sh4-stlinux23-linux-uclibc"
CT_PREFIX="sh4-linux-uclibc"

XGCC_VERSION="4.2.4"

src_install() {
	stlinux_src_install
	stlinux-toolchain-gcc_install
}
