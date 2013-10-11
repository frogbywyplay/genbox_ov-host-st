# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm stlinux

DESCRIPTION="STLinux 2.3 sh4 kernel headers"
HOMEPAGE="http://stlinux.com"
SRC_URI="mirror://cross-stlinux/${PN}-2.6.23.17_stm23_0125-41.noarch.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/opt

