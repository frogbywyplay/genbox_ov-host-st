# Copyright 2008 Wyplay S.A.S.
# $Header: $

ETYPE="headers"
H_SUPPORTEDARCH="sh"

KREV="0"
IUSE="custom"

inherit kernel-2 git
detect_version

if use custom && [ ! -z ${GIT_CUSTOMDIR} ]; then
        EGIT_CUSTOM=${GIT_CUSTOMDIR}
        echo "CUSTOM"
else
        EGIT_TREE=HEAD
fi

EGIT_REPO_URI="git://git.wyplay.int/kernel-wyplay/kernel-wyplay-2.6.23.y.git"


DESCRIPTION="Wybox Linux kernel sources"
HOMEPAGE="http://www.wyplay.com"
SRC_URI=""

KEYWORDS="x86"
LICENSE="GPL-2"


DEPEND="dev-util/unifdef"

S=${WORKDIR}/${P}


src_install () {
        kernel-2_src_install
        cd "${D}"
#       egrep -r \
#               -e '[[:space:]](asm|volatile|inline)[[:space:](]' \
#               -e '\<([us](8|16|32|64))\>' \
                .
        headers___fix $(find -type f)
		insinto /usr/${CTARGET}/usr/include/linux/
		# XXX installed media-gfx/stgfb-modules
		#doins ${FILESDIR}/${PV}/stmfb.h
		#doins ${FILESDIR}/${PV}/stmvout.h
		doins ${FILESDIR}/${PV}/st-coprocessor.h
		doins ${FILESDIR}/${PV}/console_splash.h

		insinto /usr/${CTARGET}/usr/include/asm
		doins ${FILESDIR}/${PV}/cachectl.h
		doins ${FILESDIR}/${PV}/posix_types.h

		# XXX installed by media-gfx/stgfb-modules
		#insinto /usr/${CTARGET}/usr/include/stm
		#doins ${FILESDIR}/${PV}/hdmi.h
}

src_test() {
        emake -j1 ARCH=$(tc-arch-kernel) headers_check || die
}
