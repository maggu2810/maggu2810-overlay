# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator games

MY_PV=$(delete_all_version_separators)

DESCRIPTION="Open-source replacement content for Quake 3 Arena, effectively creating a free stand-alone game"
HOMEPAGE="http://openarena.ws/"
SRC_URI="oa${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated smp"
RESTRICT="fetch strip"

RDEPEND="virtual/opengl
	media-libs/openal
	media-libs/libsdl
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp"
DEPEND="app-arch/unzip"

S=${WORKDIR}/openarena-${PV}

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	echo
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	local arch="i386" ded_exe="ioq3ded" exe="ioquake3" smp
	if use smp ; then
		smp="-smp"
	fi
	if use amd64 ; then
		arch="x86_64"
	fi

	ded_exe="${ded_exe}.${arch}"
	exe="${exe}${smp}.${arch}"

	exeinto "${dir}"
	doexe "${exe}" || die
	if use dedicated ; then
		doexe "${ded_exe}" || die
		games_make_wrapper ${PN}-ded "./${ded_exe}" "${dir}"
	fi

	insinto "${dir}"
	doins -r baseoa || die
	doins CHANGES CREDITS LINUXNOTES README

	games_make_wrapper ${PN} "./${exe}" "${dir}"
	
	doicon "${FILESDIR}"/openarena.xpm
	make_desktop_entry ${PN} "Quake III - Open Arena" openarena.xpm

	prepgamesdirs
}
