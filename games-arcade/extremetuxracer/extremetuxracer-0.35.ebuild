# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games autotools

DESCRIPTION="Extreme Tux Racer is an open source racing game featuring Tux the
Linux Penguin. ETRacer continues in the tracks of Tux Racer and its forks."
HOMEPAGE="http://www.extremetuxracer.com"
SRC_URI="http://planetpenguinracer.com/cpicon92/files/extreme-tuxracer-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2
	>=dev-lang/tcl-8.4
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXi
	virtual/opengl
	>=media-libs/libpng-1.2
	dev-util/pkgconfig
	>=media-libs/freetype-2
	virtual/libstdc++"
RDEPEND=""

S="${WORKDIR}/extreme-tuxracer-${PV}"

src_compile() {
	cd "${S}"
	eautoreconf || die 'eautoreconf failed'
	egamesconf || die 'egamesconf failed'
	emake || die 'emake failed'
}

src_install() {
	emake install DESTDIR="${D}" || die 'emake install failed'
	insinto /usr/share/applications
	doins "${FILESDIR}/etracer.desktop"
	insinto /usr/share/pixmaps
	doins "${FILESDIR}/etracericon.svg"
}
