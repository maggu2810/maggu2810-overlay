# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_P="${PN}-${PV:0:4}-${PV:4:2}-${PV:6}"
MY_SRC="${MY_P}-src.tar.bz2"
MY_DATA="${MY_P}-data-full.tar.bz2"

DESCRIPTION="A driving simulation made with drift racing in mind"
HOMEPAGE="http://vdrift.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_SRC}
	mirror://sourceforge/${PN}/${MY_DATA}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls"

RDEPEND="media-libs/freealut
	media-libs/libsdl
	media-libs/mesa
	media-libs/openal
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-net"

DEPEND="${RDEPEND}
	dev-util/scons"
	
RESTRICT="nomirror"

S=${WORKDIR}/build/${MY_P}-src

pkg_setup() {
	if ! built_with_use -a media-libs/libsdl X opengl; then
		eerror "vdrift needs libsdl emerged with:"
		eerror "USE='X opengl'"
		die "libsdl rebuild needed"
	fi
}

src_unpack() {
	unpack ${MY_SRC}
	cd build
	unpack ${MY_DATA}
}

src_compile() {
	local myconf
	use debug || myconf="release=1"
	use nls && myconf="${myconf} NLS=1"

	scons \
		${MAKEOPTS/j/j } \
		${myconf} \
		prefix='' \
		destdir="${D}" \
		bindir="${GAMES_BINDIR}" \
		localedir=/usr/share/locale \
		datadir="${GAMES_DATADIR}/${PN}" \
		use_binreloc=0 \
		os_cxxflags=1 \
		|| die "scons failed"
}

src_install() {
	scons install || die "scons install failed"

	newicon data/textures/icons/vdrift-64x64.png ${PN}.png
	make_desktop_entry ${PN} "VDrift"

	dodoc docs/*

	prepgamesdirs
}
