# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.17.50.0.12.ebuild,v 1.1 2007/01/28 22:53:36 vapier Exp $

PATCHVER=""
#PATCHVER="1.0"
UCLIBC_PATCHVER=""
#UCLIBC_PATCHVER="1.0"
ELF2FLT_VER=""
inherit toolchain-binutils

# ARCH - packages to test before marking
KEYWORDS="~sh"

src_unpack () {
	toolchain-binutils_src_unpack
	# apply STLinux patch
	epatch ${FILESDIR}/st_patches/binutils-2.18.50.0.8-st40r2-sh4-300.patch
}
