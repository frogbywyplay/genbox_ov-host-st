# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm stlinux

DESCRIPTION="ST Micro Connection Package"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux24-host-stmc-2012.2.1-83.i386.rpm"

LICENSE="ST"
SLOT="2.4"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND="!sys-devel/stlinux-host-havana-stmc"
DEPEND=""
