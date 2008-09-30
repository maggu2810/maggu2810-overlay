# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/toycars/toycars-0.3.5.ebuild,v 1.1 2008/01/01 20:08:38 nyhm Exp $

inherit autotools eutils games

DESCRIPTION="a physics based 2-D racer inspired by Micro Machines"
HOMEPAGE="http://sourceforge.net/projects/toycars"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	>=media-libs/fmod-4
	virtual/glu
	virtual/opengl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch	${FILESDIR}/${P}-fmod.patch \
		${FILESDIR}/${P}-gcc4.3.patch
	AT_M4DIR=m4 eautoreconf
}

src_install() {
	dogamesbin src/${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data || die "doins failed"
	newicon celica-render.png ${PN}.png
	make_desktop_entry ${PN} "Toy Cars"
	dodoc AUTHORS ChangeLog README TODO
	prepgamesdirs
}
