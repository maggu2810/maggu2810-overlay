# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm

MY_PV="${PV/_p/-r}"

DESCRIPTION="Binary only GUI for LightScribe"
HOMEPAGE="http://www.lacie.com/products/product.htm?pid=10803"
SRC_URI="http://www.lacie.com/download/drivers/4L-${MY_PV}.i586.rpm
	http://eventi.vnunet.it/images/lacie.png"

LICENSE="Free"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""

RDEPEND="virtual/libc
	>=sys-devel/gcc-3.4
	>=app-cdr/liblightscribe-1.4.113.1
	x86? ( >=media-libs/fontconfig-2.3.2
		 >=media-libs/freetype-2.1.10
		 x11-libs/libX11
		 x11-libs/libXcursor
		 x11-libs/libXext
		 x11-libs/libXi
		 x11-libs/libXinerama
		 x11-libs/libXrandr
		 x11-libs/libXrender )
	
	amd64? ( app-emulation/emul-linux-x86-xlibs 
		 app-emulation/emul-linux-x86-compat )"

RESTRICT="mirror strip"

src_unpack() {
	rpm_src_unpack
}

src_compile() { :; }

src_install() {
	into /opt/lightscribe/4L
	dobin ${WORKDIR}/usr/4L/4L-*
	dobin ${WORKDIR}/usr/4L/lacie*
	insinto /opt/lightscribe/4L/bin/translations
	doins -r ${WORKDIR}/usr/4L/translations/*
	dodoc ${WORKDIR}/usr/4L/doc/*
	docinto templates
	dodoc ${WORKDIR}/usr/4L/templates/*
	dosym /opt/lightscribe/4L/bin/4L-cli /usr/bin/4L-cli
	
	newicon ${DISTDIR}/lacie.png ${PN}.png
        make_desktop_entry /opt/lightscribe/4L/bin/4L-gui "Lacie LightScribe Labeler" ${PN}.png AudioVideo /opt/lightscribe/4L/bin

}
