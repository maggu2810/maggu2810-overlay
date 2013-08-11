# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games

DESCRIPTION="A first person Western style shooter - data portion"
HOMEPAGE="http://www.smokin-guns.org"
SRC_URI="Smokin_Guns_1.1.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch"

DEPEND=""
RDEPEND="${DEPEND}"

MY_PN="${PN/-data/}"
MY_DEST="${GAMES_DATADIR}/${MY_PN}"

S="${WORKDIR}/Smokin' Guns ${PV}"

src_install() {
	cd "${S}"
	dodir "${MY_DEST}"
	cp -R smokinguns "${D}/${MY_DEST}" || die "Install failed!"
	prepgamesdirs
}
