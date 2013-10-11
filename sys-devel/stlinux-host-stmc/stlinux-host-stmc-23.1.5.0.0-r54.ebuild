# Copyright 2007 Wyplay
# $Header: $

inherit rpm stlinux

DESCRIPTION="ST Micro Connection Package"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-host-stmc-1.5.0.0-54.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND="!sys-devel/stlinux-host-havana-stmc"
DEPEND=""
