# Copyright 2006-2013 Wyplay. All Rights Reserved.

PATCHVER=""
#PATCHVER="1.0"
UCLIBC_PATCHVER=""
#UCLIBC_PATCHVER="1.0"
ELF2FLT_VER=""
inherit toolchain-binutils

# ARCH - packages to test before marking
KEYWORDS="sh"

src_unpack () {
	toolchain-binutils_src_unpack
	# apply STLinux patch
	epatch ${FILESDIR}/st_patches/binutils-2.18-unaligned-mova.patch	
}
