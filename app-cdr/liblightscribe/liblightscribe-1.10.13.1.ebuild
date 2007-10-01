# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm

DESCRIPTION="Binary only Library for LightScribe"
HOMEPAGE="http://www.lightscribe.com/"
SRC_URI="http://download.lightscribe.com/ls/lightscribe-${PV}-linux-2.6-intel.rpm
         http://download.lightscribe.com/ls/lightscribePublicSDK-${PV}-linux-2.6-intel.rpm"

LICENSE="HP-LightScribe"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

RDEPEND="virtual/libc
	sys-libs/libstdc++-v3"

RESTRICT="nomirror nostrip"

src_unpack() {
	rpm_src_unpack
}

src_compile() { :; }

src_install() {
	dodoc ${WORKDIR}/usr/share/doc/*
	insinto /opt/liblightscribe/lib/lightscribe
	doins -r ${WORKDIR}/usr/lib/lightscribe/*
	insinto /opt/liblightscribe/lib
	doins ${WORKDIR}/usr/lib/liblightscribe.so.*
	dosym /opt/liblightscribe/lib/liblightscribe.so.1 /opt/liblightscribe/lib/liblightscribe.so
	insinto /usr/include/liblightsribe
	doins -r ${WORKDIR}/usr/include/*
	insinto /etc
	doins -r ${WORKDIR}/etc/*
	dosed "s%/usr/lib%/opt/liblightscribe/lib%" /etc/lightscribe.rc
	doenvd ${FILESDIR}/80liblightscribe
}
