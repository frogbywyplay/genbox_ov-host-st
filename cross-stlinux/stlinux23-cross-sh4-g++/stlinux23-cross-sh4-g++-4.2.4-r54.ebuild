# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm toolchain-funcs

DESCRIPTION="STLinux 2.3 cross-sh4 gcc"
HOMEPAGE="http://stlinux.com"
SRC_URI="mirror://cross-stlinux/${PN}-${PVR/-r/-}.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/opt

src_install() {
	insinto /opt/STM
	cp -a "${S}"/STM/* "${D}"/opt/STM
}

