# Copyright SFR
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit rpm stlinux24 eutils

DESCRIPTION="STLinux 2.4 SH4 STMC"
HOMEPAGE="http://www.stlinux.com"

SRC_URI="mirror://cross-stlinux24/stlinux24-host-stmc-2012.1.1-82.i386.rpm"

LICENSE="ST"
SLOT="0"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip nomirror"

RDEPEND=""
DEPEND="${RDEPEND}"
