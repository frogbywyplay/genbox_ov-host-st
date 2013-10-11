# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm toolchain-funcs eutils

DESCRIPTION="ST Micro Connection Package"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://stlinux/stlinux23-host-stmc-1.3.1.0-21.i386.rpm
	mirror://stlinux/stlinux23-host-havana-stmc-1-6.noarch.rpm"

LICENSE="ST"
SLOT="2.3"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip binchecks"

PROVIDE="sys-devel/stlinux-host-stmc"

DEPEND=""
RDEPEND="!sys-devel/stlinux-host-stmc"

S=${WORKDIR}/opt

src_compile() {
	cd "${S}/STM/STLinux-2.3/host/stmc"

	einfo "Patching with havana.stmc.patch"
	patch -R -p1 < havana.stmc.patch
	rm havana.stmc.patch

	einfo "Patching with 7105_v7_tp.patch"
	patch -p1 < 7105_v7_tp.patch
	rm 7105_v7_tp.patch

	einfo "Patching with sttpadd.patch"
	patch -p1 < sttpadd.patch
	rm sttpadd.patch
}

src_install() {
	insinto /opt/STM
	cp -a ${S}/STM/* ${D}/opt/STM
}

