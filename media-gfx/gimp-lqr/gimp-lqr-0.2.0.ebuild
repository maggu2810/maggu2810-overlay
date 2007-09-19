# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN}-plugin"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="This is a GIMP plugin for image targeting"
HOMEPAGE="http://stuporglue.org/gimp-lqr.php"
SRC_URI="http://web.tiscali.it/carlobaldassi/GimpLqrPlugin/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=media-gfx/gimp-2.2"

src_unpack() {
	unpack ${A}
}

src_compile() {
	cd ${MY_P}
	econf
	emake || die "emake failed"
}

src_install() {
	cd ${MY_P}
	emake install DESTDIR="${D}" || die "install failed"
}
