# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs games

MY_P=wopengine_src-${PV}
DESCRIPTION="A cartoon style multiplayer first-person shooter"
HOMEPAGE="http://worldofpadman.com/"
SRC_URI="http://thilo.kickchat.com/download/${MY_P}.tar.bz2
	http://thilo.kickchat.com/download/${PN}.run
	maps? ( http://thilo.kickchat.com/download/wop_padpack.zip )"

LICENSE="GPL-2 worldofpadman"
SLOT="0"
KEYWORDS="~x86"
IUSE="dedicated maps opengl"

UIDEPEND="virtual/opengl
	media-libs/openal
	media-libs/libsdl
	media-libs/libogg
	media-libs/libvorbis
	net-misc/curl"
RDEPEND="opengl? ( ${UIDEPEND} )
	!dedicated? ( ${UIDEPEND} )"
DEPEND="${RDEPEND}
	maps? ( app-arch/unzip )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.bz2
	unpack_makeself ${PN}.run
	unpack ./readme.tar
	mkdir wop
	cd wop
	unpack ./../wop-data.tar
	use maps && unpack wop_padpack.zip
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc42.patch	
}

src_compile() {
	emake \
		BUILD_CLIENT=$(use opengl || ! use dedicated && echo 1 || echo 0) \
		BUILD_SERVER=$(use dedicated && echo 1 || echo 0) \
		CC="$(tc-getCC)" \
		ARCH=$(tc-arch-kernel) \
		OPTIMIZE= \
		DEFAULT_BASEDIR="${GAMES_DATADIR}"/${PN} \
		|| die "emake failed"
}

src_install() {
	cd build/release-*
	if use opengl || ! use dedicated ; then
		newgamesbin wop-engine.* ${PN} || die "newgamesbin ${PN} failed"
		newicon "${WORKDIR}"/wop.png ${PN}.png
		make_desktop_entry ${PN} "World of Padman"
	fi
	if use dedicated ; then
		newgamesbin wopded.* ${PN}-ded || die "newgamesbin ${PN}-ded failed"
	fi
	cd "${WORKDIR}"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r wop || die "doins failed"
	dohtml -r readme readme.html
	prepgamesdirs
}
