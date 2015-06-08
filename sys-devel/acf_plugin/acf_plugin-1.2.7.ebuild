# Copyright 2006-2015 Wyplay. All Rights Reserved

inherit rpm

DESCRIPTION="Auto-Tuning Optimization System (ATOS) provides tools for automatic
tuning of applications"
HOMEPAGE="http://www.st.com"
SRC_URI="mirror://cross-stlinux24/stlinux24-cross-gcc-plugins-1.2-7.src.rpm"

LICENSE="STMicroelectronics"
SLOT="0"
KEYWORDS="x86-host"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/gcc-plugins

src_compile() {

	einfo "Building for Armv7"
	#emake clean all check -C acf-plugin PLUGGED_ON_KIND=cross PLUGGED_ON=armv7-linaro-linux-gnu-gcc || die "emake Armv7"

	einfo "Building for SH4"
	emake clean all check -C acf-plugin PLUGGED_ON_KIND=cross PLUGGED_ON=sh4-stlinux24-linux-gnu-gcc || die "emake SH4"



}
