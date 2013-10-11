# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils rpm stlinux

DESCRIPTION="STLinux 2.4 armv7 cross toolchain"
HOMEPAGE="http://www.stlinux.com"
SRC_URI="mirror://cross-stlinux24/stlinux24-armv7-glibc-2.10.2-42.armv7.rpm
mirror://cross-stlinux24/stlinux24-armv7-glibc-debuginfo-2.10.2-42.armv7.rpm
mirror://cross-stlinux24/stlinux24-armv7-glibc-dev-2.10.2-42.armv7.rpm
mirror://cross-stlinux24/stlinux24-armv7-glibc-i18ndata-2.10.2-42.armv7.rpm
mirror://cross-stlinux24/stlinux24-armv7-glibc-locales-2.10.2-42.armv7.rpm
mirror://cross-stlinux24/stlinux24-armv7-glibc-nscd-2.10.2-42.armv7.rpm

mirror://cross-stlinux24/stlinux24-armv7-libgcc-4.7.2-125.armv7.rpm
mirror://cross-stlinux24/stlinux24-armv7-libstdc++-4.7.2-125.armv7.rpm
mirror://cross-stlinux24/stlinux24-armv7-libstdc++-dev-4.7.2-125.armv7.rpm
mirror://cross-stlinux24/stlinux24-armv7-linux-kernel-headers-2.6.32.46-46.noarch.rpm

mirror://cross-stlinux24/stlinux24-cross-armv7-cpp-4.7.2-120.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-armv7-g++-4.7.2-120.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-armv7-gcc-4.7.2-120.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-armv7-protoize-4.7.2-120.i386.rpm

mirror://cross-stlinux24/stlinux24-cross-armv7-armdebug-7.4-30.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-armv7-binutils-2.23.1-69.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-armv7-gmp-5.0.2-12.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-armv7-libelf-0.8.13-2.i386.rpm
mirror://cross-stlinux24/stlinux24-cross-armv7-mpfr-3.1.0-13.i386.rpm
"


LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86-host"
IUSE=""
RESTRICT="strip nomirror"

DEPEND=""
RDEPEND="dev-util/ccache"
PROVIDE="virtual/${CATEGORY}-gcc
virtual/${CATEGORY}-glibc"

COMPILER_DIR="/opt/STM/STLinux-2.4/devkit/armv7"
COMPILER_TOPDIR="${COMPILER_DIR}/bin"


SYSTEM_TUPLES="${CATEGORY/cross-}"
CT_PREFIX="arm-cortex-linux-gnueabi"
ORIG_SYSTEM_TUPLES="armv7-linux"

XGCC_VERSION="4.7.2"
XBINUTILS_VERSION="2.23"
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
	ccache-config --install-links ${SYSTEM_TUPLES}
}
