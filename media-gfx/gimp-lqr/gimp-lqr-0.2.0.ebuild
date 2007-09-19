# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="This is a GIMP plugin for image targeting"
HOMEPAGE="http://stuporglue.org/gimp-lqr.php"
SRC_URI="http://web.tiscali.it/carlobaldassi/GimpLqrPlugin/${PN}-plugin-${PVR}.tar.gz"

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
	econf
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
}
