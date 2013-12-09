# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm stlinux 

DESCRIPTION="STLinux 2.3 sh4 glibc"
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

