# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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
XGCC_VERSION="4.2.4"

src_install() {
	stlinux_src_install
	stlinux-toolchain-gcc_install
}
