# Copyright 2015 Wyplay/ST

inherit rpm stlinux

DESCRIPTION="ST Cross-GDB for ARMv7"
HOMEPAGE="www.stlinux.com"
SRC_URI="mirror://cross-stlinux24/armv7/stlinux24-cross-armv7-gdb-7.6-78.i386.rpm"

LICENSE=""
SLOT="0"
KEYWORDS="x86-host"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	stlinux_src_install
	dosym /opt/STM/STLinux-2.4/devkit/armv7/bin/armv7-linux-unwrapped-gdb /usr/bin/
	dosym /opt/STM/STLinux-2.4/devkit/armv7/man/man1/armv7-linux-gdb.1 /usr/man/man1/
}
