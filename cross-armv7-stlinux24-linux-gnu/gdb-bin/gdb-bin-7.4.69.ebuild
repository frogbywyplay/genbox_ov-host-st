# Copyright 2006-2013 Wyplay. All Rights Reserved.

inherit rpm

DESCRIPTION="Cross-GDB for ARMv7"
HOMEPAGE="www.stlinux.com"
SRC_URI="mirror://cross-stlinux24/stlinux24-cross-armv7-gdb-7.4-69.i386.rpm"

LICENSE=""
SLOT="0"
KEYWORDS="x86-host"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/opt/STM/STLinux-2.4/devkit/armv7


src_install() {

	exeinto /usr/bin
	newexe ${S}/bin/armv7-linux-unwrapped-gdb armv7-stlinux24-linux-unwrapped-gdb

	insinto /usr/man/man1
	newins ${S}/man/man1/armv7-linux-gdb.1 armv7-stlinux24-linux-unwrapped-gdb.1


}
