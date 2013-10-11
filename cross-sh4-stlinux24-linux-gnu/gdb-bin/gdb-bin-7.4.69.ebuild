# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm

DESCRIPTION="Cross-GDB for SH4"
HOMEPAGE="www.stlinux.com"
SRC_URI="mirror://cross-stlinux24/stlinux24-cross-sh4-gdb-7.4-69.i386.rpm"

LICENSE=""
SLOT="0"
KEYWORDS="x86-host"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/opt/STM/STLinux-2.4/devkit/sh4


src_install() {

	exeinto /usr/bin
	newexe ${S}/bin/sh4-linux-unwrapped-gdb sh4-stlinux24-linux-unwrapped-gdb

	insinto /usr/man/man1
	newins ${S}/man/man1/sh4-linux-gdb.1 sh4-stlinux24-linux-unwrapped-gdb.1


}
