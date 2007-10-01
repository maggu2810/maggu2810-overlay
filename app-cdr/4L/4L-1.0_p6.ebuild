# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm

MY_PV="${PV/_p/-r}"

DESCRIPTION="Binary only GIU for LightScribe"
HOMEPAGE="http://www.lacie.com/products/product.htm?pid=10803"
SRC_URI="http://www.lacie.com/download/drivers/4L-${MY_PV}.i586.rpm"

LICENSE="Free"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

RDEPEND="virtual/libc
	virtual/x11
	>=app-cdr/liblightscribe-1.4.113.1
	>=media-libs/fontconfig-2.3.2
	>=media-libs/freetype-2.1.10
	>=sys-devel/gcc-3.4"

RESTRICT="nomirror nostrip"

src_unpack() {
	rpm_src_unpack
}

src_compile() { :; }

src_install() {
	dodir /opt/4L/bin
	insinto /opt/4L
	doins ${WORKDIR}/usr/4L/*
	fperms 0755 /opt/4L/lacie_website.sh
	fperms 0755 /opt/4L/4L-gui
	fperms 0755 /opt/4L/4L-cli
	insinto /opt/4L/templates
	doins ${WORKDIR}/usr/4L/templates/*
	insinto /opt/4L/translations
	doins ${WORKDIR}/usr/4L/translations/*
	dodoc ${WORKDIR}/usr/4L/doc/4L_User_Manual.pdf
	insinto /usr/share/applications
	doins ${FILESDIR}/LaCie-4L.desktop
	dosym ../4L-gui /opt/4L/bin/4L-gui
	dosym ../4L-cli /opt/4L/bin/4L-cli
	doenvd ${FILESDIR}/80LaCie-4L
}
