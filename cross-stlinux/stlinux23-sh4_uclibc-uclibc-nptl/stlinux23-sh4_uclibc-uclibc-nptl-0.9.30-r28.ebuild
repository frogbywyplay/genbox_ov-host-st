# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm stlinux

DESCRIPTION="STLinux 2.3 sh4 glibc"
HOMEPAGE="http://stlinux.com"
MYPVR="${PVR/_rc/rc}"
SRC_URI="mirror://cross-stlinux/${PN}-${MYPVR/-r/-}.sh4_uclibc.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/opt

