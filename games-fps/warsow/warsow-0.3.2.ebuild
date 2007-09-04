# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs versionator games

MY_P=${PN}_$(delete_version_separator 2)
DESCRIPTION="Multiplayer FPS based on the QFusion engine (evolved from Quake 2)"
HOMEPAGE="http://www.warsow.net/"
SRC_URI="http://www.warsow.net/release/${MY_P}_linux.tar.gz
	http://www.warsow.net/release/${MY_P}_sdk.zip
	mirror://gentoo/${PN}.png
	"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated irc openal opengl"

UIRDEPEND="media-libs/jpeg
	media-libs/libvorbis
	media-libs/libsdl
	net-misc/curl
	virtual/opengl
	x11-libs/libXinerama
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	openal? ( media-libs/openal )"
RDEPEND="opengl? ( ${UIRDEPEND} )
	!opengl? ( !dedicated? ( ${UIRDEPEND} ) )"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-misc/makedepend"

S=${WORKDIR}/${MY_P}/source

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -f "${WORKDIR}"/${PN}/docs/gnu.txt

	sed -i \
		-e '/fs_usehomedir =/ s:0:1:' \
		-e "/fs_basepath =/ s:\.:${GAMES_DATADIR}/${PN}:" \
		qcommon/files.c \
		|| die "sed files.c failed"

	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	yesno() { use ${1} && echo YES || echo NO ; }

	if use opengl || ! use dedicated ; then
		local client="YES"
	else
		local client="NO"
	fi

	emake \
		BUILD_CLIENT=${client} \
		BUILD_SERVER=$(yesno dedicated) \
		BUILD_IRC=$(yesno irc) \
		BUILD_SND_OPENAL=$(yesno openal) \
		DEBUG_BUILD=$(yesno debug) \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		|| die "emake failed"
}

src_install() {
	cd release

	if use opengl || ! use dedicated ; then
		newgamesbin ${PN}.* ${PN} || die "newgamesbin ${PN} failed"
		doicon "${DISTDIR}"/${PN}.png
		make_desktop_entry ${PN} Warsow
	fi

	if use dedicated ; then
		newgamesbin wsw_server.* ${PN}-ded || die "newgamesbin ${PN}-ded failed"
	fi

	exeinto "$(games_get_libdir)"/${PN}
	doexe */*.so || die "doexe failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${WORKDIR}"/${PN}/basewsw || die "doins failed"

	local so
	for so in basewsw/*.so ; do
		dosym "$(games_get_libdir)"/${PN}/${so##*/} \
			"${GAMES_DATADIR}"/${PN}/${so} || die "dosym ${so} failed"
	done

	dodir "${GAMES_DATADIR}"/${PN}/libs
	for so in libs/*.so ; do
		dosym "$(games_get_libdir)"/${PN}/${so##*/} \
			"${GAMES_DATADIR}"/${PN}/${so} || die "dosym ${so} failed"
	done

	exeinto "$(games_get_libdir)"/${PN}

	dodoc "${WORKDIR}"{/${PN},}/docs/*
	prepgamesdirs
}
