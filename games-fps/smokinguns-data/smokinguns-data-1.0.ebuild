# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="A first person Western style shooter - data portion"
HOMEPAGE="http://www.smokin-guns.net/"
SRC_URI="Smokin_Guns_${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch"

DEPEND=""
RDEPEND="${DEPEND}"

MY_PN="${PN/-data/}"
MY_DEST="${GAMES_DATADIR}"/"${MY_PN}"

MY_S="${WORKDIR}"/"Smokin' Guns"
S="${WORKDIR}"

src_install() {
	cd "${MY_S}"
	dodir "${MY_DEST}"
	cp -R smokinguns "${D}"/"${MY_DEST}" || die "Install failed!"
	prepgamesdirs
}
