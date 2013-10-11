# Copyright 2007 Wyplay
# $Header: $

inherit rpm stlinux

DESCRIPTION="ST's ST40 Loader for STLinux23"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-cross-sh4-st40load_gdb-1.21-23.i386.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

RDEPEND="=sys-devel/stlinux-cross-sh4-shdebug-23.6*
		 =sys-devel/stlinux-cross-sh4-binutils-23*
		  sys-devel/stlinux-host-stmc"
DEPEND=""

