# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libmems/libmems-9999.ebuild,v 1.1 2009/04/03 16:36:24 weaver Exp $

EAPI="2"

MY_DELIM="_pre"
MY_PN="${PN/-svn/}"
MY_PREV="${PV##*${MY_DELIM}}"
MY_PV="${PV/${MY_DELIM}${MY_PREV}/}"

ESVN_REPO_URI="https://${MY_PN}.svn.sourceforge.net/svnroot/${MY_PN}/branches/@${MY_PREV}"

inherit eutils games subversion

DESCRIPTION="A first person Western style shooter engine (based on the Quake 3 engine)"
HOMEPAGE="http://www.smokin-guns.net/"
#SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/opengl
        media-libs/openal
        media-libs/libsdl"
RDEPEND="${DEPEND}
	games-fps/${MY_PN}-data"

MY_S="${WORKDIR}"/"${P}"/"${MY_PV}"
MY_DEST="${GAMES_DATADIR}"/"${MY_PN}"

src_compile() {
	cd "${MY_S}"
	emake
}

src_install() {
	cd "${MY_S}"
	COPYDIR="${D}"/"${MY_DEST}" make copyfiles
	games_make_wrapper "${MY_PN}" "${MY_DEST}"/"${MY_PN}"."${ARCH}" "${MY_DEST}" "${MY_DEST}"
	games_make_wrapper "${MY_PN}"_dedicated "${MY_DEST}"/"${MY_PN}"_dedicated."${ARCH}" "${MY_DEST}" "${MY_DEST}"
	prepgamesdirs
}
