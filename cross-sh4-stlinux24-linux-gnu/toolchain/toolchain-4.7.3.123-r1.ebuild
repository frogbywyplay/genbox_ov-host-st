# Copyright SFR
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit rpm stlinux24 eutils

DESCRIPTION="STLinux 2.4 SH4 toolchain"
HOMEPAGE="http://www.stlinux.com"

SRC_URI="
mirror://cross-stlinux24/stlinux24-sh4-glibc-2.10.2-43.sh4.rpm
mirror://cross-stlinux24/stlinux24-sh4-glibc-dev-2.10.2-43.sh4.rpm
mirror://cross-stlinux24/stlinux24-sh4-linux-kernel-headers-2.6.32.10_stm24_0201-42.noarch.rpm

mirror://cross-stlinux24/stlinux24-cross-sh4-binutils-2.23.2-71.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4-binutils-dev-2.23.2-71.i386.rpm

mirror://cross-stlinux24/stlinux24-cross-sh4-cpp-4.7.3-123.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4-g++-4.7.3-123.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4-gcc-4.7.3-123.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4-protoize-4.7.3-123.i386.rpm

mirror://cross-stlinux24/stlinux24-cross-sh4-mpfr-3.1.2-13.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4-gmp-5.1.0-12.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4-mpc-1.0.1-6.i386.rpm

mirror://cross-stlinux24/stlinux24-cross-sh4-shdebug-7.4-13.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4-libelf-0.8.13-1.i386.rpm

mirror://cross-stlinux24/stlinux24-sh4-mpfr-3.1.2-9.sh4.rpm
mirror://cross-stlinux24/stlinux24-sh4-gmp-5.1.0-8.sh4.rpm
mirror://cross-stlinux24/stlinux24-sh4-mpc-1.0.1-5.sh4.rpm

mirror://cross-stlinux24/stlinux24-sh4-libgcc-4.7.3-128.sh4.rpm
mirror://cross-stlinux24/stlinux24-sh4-libstdc++-4.7.3-128.sh4.rpm
mirror://cross-stlinux24/stlinux24-sh4-libstdc++-dev-4.7.3-128.sh4.rpm
"

LICENSE="ST"
SLOT="0"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip nomirror"

RDEPEND=""
DEPEND="${RDEPEND}"

PROVIDE="virtual/${CATEGORY}-gcc
virtual/${CATEGORY}-glibc"

COMPILER_TOPDIR="/opt/STM/STLinux-2.4/devkit/sh4/bin"
COMPILER_DIR=/opt/STM/STLinux-2.4/devkit/sh4
SYSTEM_TUPLES="sh4-stlinux24-linux-gnu"
CT_PREFIX="${SYSTEM_TUPLES}"

XGCC_VERSION="4.7.3"
XBINUTILS_VERSION="2.23.73"
BINUTILS_BIN_PATH="/usr/${CHOST}/${SYSTEM_TUPLES}/binutils-bin/${XBINUTILS_VERSION}"
BINUTILS_LIB_PATH="/usr/lib/binutils/${SYSTEM_TUPLES}/${XBINUTILS_VERSION}"
GCC_BIN_PATH="/usr/${CHOST}/${SYSTEM_TUPLES}/gcc-bin/${XGCC_VERSION}"
GCC_LIB_PATH="/usr/lib/gcc/${SYSTEM_TUPLES}/${XGCC_VERSION}"

src_install() {
	stlinux24_src_install

	# another setup
	dosym "${COMPILER_DIR}/lib/gcc/sh4-linux/${XGCC_VERSION}" "${GCC_LIB_PATH}"
	# install binutils ldscripts
	dosym "${COMPILER_DIR}/sh4-linux/lib/ldscripts" "${BINUTILS_LIB_PATH}"

	sed "s|@COMPILER_DIR@|${COMPILER_DIR}|g" "${FILESDIR}"/"${SYSTEM_TUPLES}"-GCC-BIN > "${T}"/"${SYSTEM_TUPLES}"-GCC-BIN
	# install a directory used by gcc/binutils-config
	dodir "${GCC_BIN_PATH}"
	exeinto "${GCC_BIN_PATH}"
	for ii in c++ cpp gcov g++ gcc gcc-${XGCC_VERSION}; do #ar as ld nm objcopy objdump ranlib strip addr2line c++filt gprof readelf size strings; do
		newexe "${T}"/"${SYSTEM_TUPLES}"-GCC-BIN "${SYSTEM_TUPLES}"-$ii
	done

	sed "s|@COMPILER_DIR@|${COMPILER_DIR}|g" "${FILESDIR}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN > "${T}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN
	# install a directory used by gcc/binutils-config
	dodir "${BINUTILS_BIN_PATH}"
	exeinto "${BINUTILS_BIN_PATH}"
	for ii in ar as ld nm objcopy objdump ranlib strip addr2line c++filt gprof readelf size strings; do
		newexe "${T}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN "${SYSTEM_TUPLES}"-$ii
	done

	for ii in ar as ld nm objcopy objdump ranlib strip addr2line c++filt gprof readelf size strings; do
	    newexe "${T}"/"${SYSTEM_TUPLES}"-BINUTILS-BIN $ii
	done

	# create required file for gcc-config
	cat > ${T}/gcc-config.env.d << EOF
LDPATH="${GCC_LIB_PATH}"
STDCXX_INCDIR="g++-v4"
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
