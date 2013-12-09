# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm stlinux

DESCRIPTION="ST's cross-sh4 gdb"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-cross-sh4-shdebug-6.8-8.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND=">=sys-devel/stlinux-cross-sh4-gdb-23.6.8"
DEPEND=""

