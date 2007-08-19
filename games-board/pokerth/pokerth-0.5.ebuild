# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games qt4

MY_PN="PokerTH"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Texas Hold'em poker game."
HOMEPAGE="http://www.pokerth.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(qt4_min_version 4.2.3)
	>=dev-libs/boost-1.33
	>=dev-libs/openssl-0.9.7
	media-libs/libsdl
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use "x11-libs/qt" qt3support ; then
		eerror "x11-libs/qt has to be compiled with 'qt3support'"
		eerror "USE-flag enabled."
		die "Needed USE-flag for x11-libs/qt not found."
	fi

	if has_version "<dev-libs/boost-1.34" && \
		! built_with_use "dev-libs/boost" threads
	then
		eerror "dev-libs/boost has to be compiled with 'threads'"
		eerror "USE-flag enabled."
		die "Needed USE-flag for dev-libs/boost not found."
	fi

	# Qt bug #171858, fixed in 4.3.2 and 4.4.0
	if has_version "~x11-libs/qt-4.3.0" || \
		has_version "~x11-libs/qt-4.3.1"
	then
		ewarn "x11-libs/qt versions 4.3.0 and 4.3.1 are known to break"
		ewarn "stylesheet support for buttons (game is still playable)."
	fi

	games_pkg_setup
}

src_compile() {
	qmake || die "qmake failed."
	emake || die "emake failed."
}

src_install() {
	dogamesbin bin/pokerth
	newicon pokerth.png "${PN}.png"
	make_desktop_entry "${PN}" "PokerTH" "${PN}.png"

	prepgamesdirs
}

