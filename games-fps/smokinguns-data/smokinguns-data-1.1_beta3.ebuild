# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="A first person Western style shooter - data portion"
HOMEPAGE="http://www.smokin-guns.net/"
SRC_URI="Smokin_Guns_1.0.zip
	 SmokinGuns-1.1b3-update.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch"

DEPEND=""
RDEPEND="${DEPEND}"

MY_PN="${PN/-data/}"
MY_DEST="${GAMES_DATADIR}"/"${MY_PN}"

MY_S1="${WORKDIR}"/"Smokin' Guns"
MY_S2="${WORKDIR}"
S="${WORKDIR}"

src_install() {
	cd "${S}"
	dodir "${MY_DEST}"
	cd "${MY_S1}" && cp -R smokinguns "${D}"/"${MY_DEST}" || die "Install failed!"
	cd "${MY_S2}" && cp -R smokinguns "${D}"/"${MY_DEST}" || die "Install failed!"
	prepgamesdirs
}
