# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils rpm stlinux

DESCRIPTION="STLinux 2.3 SH4 uClibc cross toolchain"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://cross-stlinux/stlinux23-sh4_uclibc-uclibc-nptl-0.9.30-34.sh4_uclibc.rpm
mirror://cross-stlinux/stlinux23-sh4_uclibc-uclibc-nptl-debuginfo-0.9.30-34.sh4_uclibc.rpm
mirror://cross-stlinux/stlinux23-sh4_uclibc-uclibc-nptl-dev-0.9.30-34.sh4_uclibc.rpm
mirror://cross-stlinux/stlinux23-sh4_uclibc-libgcc-4.2.4-76.sh4_uclibc.rpm
mirror://cross-stlinux/stlinux23-sh4_uclibc-libstdc++-4.2.4-76.sh4_uclibc.rpm
mirror://cross-stlinux/stlinux23-sh4_uclibc-libstdc++-dev-4.2.4-76.sh4_uclibc.rpm
mirror://cross-stlinux/stlinux23-sh4_uclibc-linux-kernel-headers-2.6.23.17_stm23_0118-41.noarch.rpm
mirror://cross-stlinux/stlinux23-cross-sh4_uclibc-binutils-2.18.50.0.8-43.i386.rpm
mirror://cross-stlinux/stlinux23-cross-sh4_uclibc-cpp-4.2.4-73.i386.rpm
mirror://cross-stlinux/stlinux23-cross-sh4_uclibc-g++-4.2.4-73.i386.rpm
mirror://cross-stlinux/stlinux23-cross-sh4_uclibc-gcc-4.2.4-73.i386.rpm
mirror://cross-stlinux/stlinux23-sh4_uclibc-elfutils-libelf-0.123-3.sh4_uclibc.rpm
mirror://cross-stlinux/stlinux23-cross-sh4_uclibc-protoize-4.2.4-73.i386.rpm"


LICENSE="GPL"
SLOT="0"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip nomirror"

DEPEND=""
RDEPEND=""
PROVIDE="virtual/${CATEGORY}-gcc
virtual/${CATEGORY}-glibc"

COMPILER_DIR="/opt/STM/STLinux-2.3/devkit/sh4_uclibc"
COMPILER_TOPDIR="${COMPILER_DIR}/bin"


SYSTEM_TUPLES="${CATEGORY/cross-}"
CT_PREFIX="sh4-linux-uclibc"
ORIG_SYSTEM_TUPLES="sh4-linux-uclibc"

XGCC_VERSION="4.2.4"
XBINUTILS_VERSION="2.18"
BINUTILS_BIN_PATH="/usr/${CHOST}/${SYSTEM_TUPLES}/binutils-bin/${XBINUTILS_VERSION}"
BINUTILS_LIB_PATH="/usr/lib/binutils/${SYSTEM_TUPLES}/${XBINUTILS_VERSION}"
GCC_BIN_PATH="/usr/${CHOST}/${SYSTEM_TUPLES}/gcc-bin/${XGCC_VERSION}"
GCC_LIB_PATH="/usr/lib/gcc/${SYSTEM_TUPLES}/${XGCC_VERSION}"

src_install() {
	stlinux_src_install

	# another setup
	dosym "${COMPILER_DIR}/lib/gcc/${CT_PREFIX}/${XGCC_VERSION}" "${GCC_LIB_PATH}"

	# install binutils ldscripts
	dosym "${COMPILER_DIR}/${CT_PREFIX}/lib/ldscripts" "${BINUTILS_LIB_PATH}"


	sed -e "s|@COMPILER_DIR@|${COMPILER_DIR}|g" \
		-e "s|@TUPLES@|${SYSTEM_TUPLES}|g" \
		-e "s|@CT_PREFIX@|${ORIG_SYSTEM_TUPLES}|g" "${FILESDIR}"/"${SYSTEM_TUPLES}"-GCC-BIN > "${T}"/"${SYSTEM_TUPLES}"-GCC-BIN

	# install a directory used by gcc/binutils-config
	dodir "${GCC_BIN_PATH}"
	exeinto "${GCC_BIN_PATH}"
	for ii in c++ cpp g++ gcc gcc-${XGCC_VERSION}; do
		newexe "${T}"/"${SYSTEM_TUPLES}"-GCC-BIN "${SYSTEM_TUPLES}"-$ii
	done

	sed -e "s|@COMPILER_DIR@|${COMPILER_DIR}|g" -e "s|@TUPLES@|${SYSTEM_TUPLES}|g" -e "s|@CT_PREFIX@|${CT_PREFIX}|g" "${FILESDIR}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN > "${T}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN
	dodir "${BINUTILS_BIN_PATH}"
	exeinto "${BINUTILS_BIN_PATH}"
	for ii in ar as ld nm objcopy objdump ranlib strip; do
		newexe "${T}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN $ii
	done

	sed -e "s|@COMPILER_DIR@|${COMPILER_DIR}|g" \
		-e "s|@TUPLES@|${SYSTEM_TUPLES}|g" \
		-e "s|@CT_PREFIX@|${ORIG_SYSTEM_TUPLES}|g" "${FILESDIR}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN-2 > "${T}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN-2
	for ii in addr2line c++filt gprof readelf size strings; do
		newexe "${T}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN-2 $ii
	done

	# create required file for gcc-config
	cat > ${T}/gcc-config.env.d << EOF
LDPATH="${GCC_LIB_PATH}"
CTARGET=${SYSTEM_TUPLES}
GCC_PATH="${GCC_BIN_PATH}"
EOF
	insinto /etc/env.d/gcc
	newins ${T}/gcc-config.env.d ${SYSTEM_TUPLES}-${XGCC_VERSION}

	cat > ${T}/binutils-config.env.d << EOF
TARGET="${SYSTEM_TUPLES}"
VER="${XBINUTILS_VERSION}"
LIBPATH="${BINUTILS_LIB_PATH}"
FAKE_TARGETS="${SYSTEM_TUPLES}"
EOF
	insinto /etc/env.d/binutils
	newins ${T}/binutils-config.env.d "${SYSTEM_TUPLES}-${XBINUTILS_VERSION}"
}

pkg_postinst() {
	gcc-config "${SYSTEM_TUPLES}-${XGCC_VERSION}"
	binutils-config "${SYSTEM_TUPLES}-${XBINUTILS_VERSION}"
}
