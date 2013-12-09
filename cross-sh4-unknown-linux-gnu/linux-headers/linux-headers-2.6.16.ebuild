# Copyright 2006-2013 Wyplay. All Rights Reserved.

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arm hppa m68k ia64 ppc ppc64 s390 sh sparc x86"
inherit eutils multilib kernel-2
detect_version

PATCHES_V='4'

SRC_URI="${KERNEL_URI} mirror://gentoo/linux-2.6.11-m68k-headers.patch.bz2
	http://dev.gentoo.org/~plasmaroo/patches/kernel/gentoo-headers/gentoo-headers-${PV}-${PATCHES_V}.tar.bz2"

KEYWORDS=" x86-host"
IUSE="gcc64"

DEPEND="ppc? ( gcc64? ( sys-devel/kgcc64 ) )
	sparc? ( gcc64? ( sys-devel/kgcc64 ) )"

UNIPATCH_LIST="${DISTDIR}/gentoo-headers-${PV}-${PATCHES_V}.tar.bz2"

wrap_headers_fix() {
	for i in $*
	do
		echo -n " $1/"
		cd ${S}/include/$1
		headers___fix $(find . -type f -print)
		shift
	done
	echo
}

src_unpack() {
	ABI=${KERNEL_ABI}
	kernel-2_src_unpack

	if [[ $(tc-arch) == "sh" ]]; then
		# ALL ST-200 PATCHES DO NOT WORK
		epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.11.2-st200.patch
		epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.11.2-coproc.patch
		#epatch ${FILESDIR}/st-patches/st200-kernel-2.6.11-syscall_asm.patch
		#epatch linux-libc-headers-2.6.11.2-fbsplash.patch      # commented out by ST
		epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.11.2-stpio.patch
		#epatch ${FILESDIR}/st-patches/st200-kernel-2.6.11-syscall_rejig_header.patch
		#epatch ${FILESDIR}/st-patches/st200-kernel-2.6.11-ptrace_header.patch
		#epatch ${FILESDIR}/st-patches/st200-kernel-2.6.11-system_call_renumber_header.patch
		epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.16.16-eabi.patch
		epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.16.16-loop.patch
		epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.16.16-errqueue-icmpv6-qic117.patch
		epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.16.16-audit.patch
		#epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.16.16-if_fddi-if_tunnel.patch # NOT NEEDED
		epatch ${FILESDIR}/st-patches/linux-libc-headers-2.6.16.16-in_h.patch
		epatch ${FILESDIR}/st-patches/linux-libc-headers-adb_hiddev_pmu.patch
		epatch ${FILESDIR}/st-patches/linux-libc-headers-pmu-fix.patch
	
		#   We comment this as now we pick these files from stmfb package
		#cp ${FILESDIR}/st-patches/{stmfb.h,stmvout.h} ${S}/include/linux
	fi

	# This should always be used but it has a bunch of hunks which
	# apply to include/linux/ which i'm unsure of so only use with
	# m68k for now (dont want to break other arches)
	[[ $(tc-arch) == "m68k" ]] && epatch "${DISTDIR}"/linux-2.6.11-m68k-headers.patch.bz2

	# Fixes ... all the wrapper magic is to keep sed from dumping
	# ugly warnings about how it can't work on a directory.
	cd "${S}"/include
	einfo "Applying automated fixes:"
	wrap_headers_fix asm-* linux
	einfo "... done"

	if [[ $(tc-arch) == "sh" ]]; then	
		# EXTRACTED FROM ST SRC RPM SPEC FILE
		#  ptisserand: I removed the patch in order to allow building
		#  Link cpu
		if [ -d asm/cpu-sh4 ]; then
        		cd asm
        		ln -s cpu-sh4 cpu
        		cp cpu/ubc.h ubc.h
		fi
	fi
}

src_install () {
	kernel-2_src_install
}
