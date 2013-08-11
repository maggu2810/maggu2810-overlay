# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

MY_PREV=646

# remove the -svn for the package name
MY_PN="${PN/-svn/}"

# remove _pre, _beta, etc. for the package version
MY_DELIM="_"
MY_PV="${PV%%${MY_DELIM}*}"

ESVN_REPO_URI="https://${MY_PN}.svn.sourceforge.net/svnroot/${MY_PN}/trunk/@${MY_PREV}"

inherit eutils games subversion

DESCRIPTION="A first person Western style shooter engine (based on the Quake 3 engine)"
HOMEPAGE="http://www.smokin-guns.net/"
#SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl
	media-libs/openal
	virtual/opengl"
RDEPEND="${DEPEND}
	games-fps/${MY_PN}-data"

S="${WORKDIR}/${P}/${MY_PV}"
MY_DEST="${GAMES_DATADIR}/${MY_PN}"

src_install() {
	# COPYDIR should be set, stated by the makefile.
	# But this message appears regardless we use COPYDIR=.. make
	# or make COPYDIR="${D}/${MY_DEST}".
	COPYDIR="${D}/${MY_DEST}" emake copyfiles

	# common section
	games_make_wrapper "${MY_PN}"           "${MY_DEST}"/"${MY_PN}"."${ARCH}"           "${MY_DEST}" "${MY_DEST}"
	games_make_wrapper "${MY_PN}"_dedicated "${MY_DEST}"/"${MY_PN}"_dedicated."${ARCH}" "${MY_DEST}" "${MY_DEST}"
	prepgamesdirs
}
