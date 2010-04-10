# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Postal 2: Share the Pain (Multiplayer)"
HOMEPAGE="http://www.gopostal.com/"
SRC_URI="http://cyberstalker.dk/sponsored-by-dkchan.org/Postal2STP-FreeMP-linux.tar.bz2
	http://0day.icculus.org/postal2/Postal2STP-FreeMP-linux.tar.bz2
	http://treefort.icculus.org/postal2/Postal2STP-FreeMP-linux.tar.bz2"

LICENSE="postal2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="sys-libs/glibc
	virtual/opengl
	amd64? ( app-emulation/emul-linux-x86-xlibs )"

S=${WORKDIR}/Postal2STP-FreeMP-linux

GAMES_CHECK_LICENSE="yes"

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins -r * || die "doins failed"

	games_make_wrapper ${PN} ./postal2-bin "${dir}"/System .

	newicon postal2.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Postal 2: Share the Pain (Multiplayer)"

	fperms 750 "${dir}"/System/postal2-bin || die "fperms failed"
	prepgamesdirs
}
