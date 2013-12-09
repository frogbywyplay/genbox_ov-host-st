# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm stlinux 

DESCRIPTION="STLinux 2.3 sh4 kernel headers"
HOMEPAGE="http://stlinux.com"
SRC_URI="mirror://cross-stlinux/${PN}-2.6.23.17_stm23_0123-41.noarch.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/opt

