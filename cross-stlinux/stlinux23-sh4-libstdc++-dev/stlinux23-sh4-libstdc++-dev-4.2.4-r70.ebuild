# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm stlinux

DESCRIPTION="STLinux 2.3 sh4 libstdc++ dev"
HOMEPAGE="http://stlinux.com"
SRC_URI="mirror://cross-stlinux/${PN}-${PVR/-r/-}.sh4.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/opt

src_unpack() {
	rpm_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-libtool.patch
}
