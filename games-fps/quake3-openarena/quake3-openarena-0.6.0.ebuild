# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=144705 - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

inherit versionator games

MY_PV=$(delete_all_version_separators)

DESCRIPTION="Open-source replacement content for Quake 3 Arena, effectively creating a free stand-alone game"
HOMEPAGE="http://cheapy.deathmask.net/
	http://scratchpad.wikia.com/wiki/OpenArena"
SRC_URI="http://openarena.ws/rel/${MY_PV}/oa${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="dedicated smp"
RESTRICT="strip"

RDEPEND="virtual/opengl
	media-libs/openal
	media-libs/libsdl
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	local ded_exe="ioq3ded" exe="ioquake3" ext
	if use smp ; then
		ext="-smp"
		ded_exe="${ded_exe}${ext}"
		exe="${exe}${ext}"
	fi
	if use amd64 ; then
		ext=".x86_64"
	else
		ext=".i386"
	fi
	ded_exe="${ded_exe}${ext}"
	exe="${exe}${ext}"

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
	# No icon is supplied, so use Quake 3's icon if available
	make_desktop_entry ${PN} "Quake III - Open Arena" quake3.png

	prepgamesdirs
}
