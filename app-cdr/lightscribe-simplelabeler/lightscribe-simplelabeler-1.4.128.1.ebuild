# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm multilib

DESCRIPTION="Binary only GIU for LightScribe"
HOMEPAGE="http://www.lightscribe.com/"
SRC_URI="http://download.lightscribe.com/ls/lightScribeSimpleLabeler-${PV}-linux-2.6-intel.rpm"

LICENSE="HP-LightScribe"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="multilib"

DEPEND=""

RDEPEND="virtual/libc
	sys-libs/libstdc++-v3
	>=app-cdr/liblightscribe-1.4.113.1
	x86?  ( >=media-libs/fontconfig-2.3.2
		>=media-libs/freetype-2.1.10
		>=media-libs/libpng-1.2.8
		>=x11-libs/qt-4.2.2
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext )
	amd64? ( app-emulation/emul-linux-x86-xlibs
		 app-emulation/emul-linux-x86-compat )
	sys-devel/gcc
	sys-libs/zlib"

RESTRICT="mirror strip"

pkg_setup() {
    	if use x86; then
	    if has_version ">=x11-libs/qt-4.2.2" && ! built_with_use x11-libs/qt qt3support; then
            	    eerror
            	    eerror "You need to rebuild x11-libs/qt with USE=qt3support enabled"
            	    eerror
            	    die "please rebuild x11-libs/qt with USE=qt3support"
    	    fi
	fi
}


src_unpack() {
	rpm_src_unpack
}

src_compile() { :; }

src_install() {
	has_multilib_profile && ABI="x86"
	
	into /opt/lightscribe/SimpleLabeler
	dobin ${WORKDIR}/opt/lightscribeApplications/SimpleLabeler/SimpleLabeler
	dobin ${WORKDIR}/opt/lightscribeApplications/SimpleLabeler/*.*
	exeinto /opt/lightscribe/SimpleLabeler/bin/plugins/accessible
	doexe ${WORKDIR}/opt/lightscribeApplications/SimpleLabeler/plugins/accessible/*.so
	insinto /opt/lightscribe/SimpleLabeler/bin/content
	doins -r ${WORKDIR}/opt/lightscribeApplications/SimpleLabeler/content/*
	use amd64 && dolib.so ${WORKDIR}/opt/lightscribeApplications/common/Qt/*
	dodoc ${WORKDIR}/opt/lightscribeApplications/*.*
	
	# cope with libraries being in /opt/lightscribe/SimpleLabeler/lib
        use amd64 && dodir /etc/env.d
        use amd64 && echo "LDPATH=/opt/lightscribe/SimpleLabeler/$(get_libdir)" > ${D}/etc/env.d/80lightscribe-simplelabeler

	
	newicon ${WORKDIR}/opt/lightscribeApplications/SimpleLabeler/content/images/LabelWizardIcon.png ${PN}.png
	make_desktop_entry /opt/lightscribe/SimpleLabeler/bin/SimpleLabeler "LightScribe Simple Labeler" ${PN}.png AudioVideo /opt/lightscribe/SimpleLabeler/bin
}