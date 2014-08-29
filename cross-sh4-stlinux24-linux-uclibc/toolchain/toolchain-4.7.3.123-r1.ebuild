# Copyright 2006-2013 Wyplay. All Rights Reserved.

EAPI=1

inherit rpm stlinux24 eutils

DESCRIPTION="STLinux 2.4 uClibc SH4 toolchain"
HOMEPAGE="http://www.stlinux.com"

SRC_URI="
mirror://cross-stlinux24/stlinux24-sh4_uclibc-uclibc-nptl-0.9.33-77.sh4_uclibc.rpm 
mirror://cross-stlinux24/stlinux24-sh4_uclibc-uclibc-nptl-dev-0.9.33-77.sh4_uclibc.rpm
mirror://cross-stlinux24/stlinux24-sh4_uclibc-linux-kernel-headers-2.6.32.10_stm24_0201-43.noarch.rpm

mirror://cross-stlinux24/stlinux24-sh4_uclibc-binutils-2.23.2-74.sh4_uclibc.rpm 
mirror://cross-stlinux24/stlinux24-sh4_uclibc-binutils-dev-2.23.2-74.sh4_uclibc.rpm 

mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-cpp-4.7.3-121.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-g++-4.7.3-121.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-gcc-4.7.3-121.i386.rpm   
mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-protoize-4.7.3-121.i386.rpm

mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-mpfr-3.1.2-13.i386.rpm 
mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-gmp-5.1.0-12.i386.rpm 
mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-mpc-1.0.1-6.i386.rpm

mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-shdebug-7.4-13.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-sh4_uclibc-libelf-0.8.13-1.i386.rpm

mirror://cross-stlinux24/stlinux24-sh4_uclibc-mpfr-3.1.2-9.sh4_uclibc.rpm 
mirror://cross-stlinux24/stlinux24-sh4_uclibc-gmp-5.0.1-5.sh4_uclibc.rpm 
mirror://cross-stlinux24/stlinux24-sh4_uclibc-mpc-1.0.1-5.sh4_uclibc.rpm

mirror://cross-stlinux24/stlinux24-sh4_uclibc-libgcc-4.7.3-128.sh4_uclibc.rpm  
mirror://cross-stlinux24/stlinux24-sh4_uclibc-libgcc-4.7.3-128.sh4_uclibc.rpm
mirror://cross-stlinux24/stlinux24-sh4_uclibc-libstdc++-dev-4.7.3-128.sh4_uclibc.rpm 
"

LICENSE="ST"
SLOT="0"
KEYWORDS="x86-host"
IUSE=""
RESTRICT="strip nomirror"

RDEPEND=""
DEPEND="${RDEPEND}"

PROVIDE="virtual/${CATEGORY}-gcc
virtual/${CATEGORY}-uclibc"

COMPILER_TOPDIR="/opt/STM/STLinux-2.4/devkit/sh4_uclibc/bin"
COMPILER_DIR="/opt/STM/STLinux-2.4/devkit/sh4_uclibc"
SYSTEM_TUPLES="sh4-stlinux24-linux-uclibc"
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
	dosym "${COMPILER_DIR}/lib/gcc/sh4-linux-uclibc/${XGCC_VERSION}" "${GCC_LIB_PATH}"
	# install binutils ldscripts
	dosym "${COMPILER_DIR}/target/usr/lib/ldscripts" "${BINUTILS_LIB_PATH}"

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
