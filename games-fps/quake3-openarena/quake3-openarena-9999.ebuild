# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=144705
# Small modifications by Ycarus (http://gentoo.zugaina.org/)
# Small modifications by maggu2810

inherit subversion versionator games

ESVN_REPO_URI="http://openarena.ws/svn/"

DESCRIPTION="Open-source replacement content for Quake 3 Arena, effectively creating a free stand-alone game"
HOMEPAGE="http://cheapy.deathmask.net/
	http://scratchpad.wikia.com/wiki/OpenArena"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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

src_compile() {
	#S: /var/tmp/portage/games-fps/quake3-openarena-9999/work/quake3-openarena-9999
	#WORKDIR: /var/tmp/portage/games-fps/quake3-openarena-9999/work
	#SOURCEDIR:
	#PN: quake3-openarena
	#GAMES_PREFIX_OPT: /opt
	cd ${S}
	sh buildpk3nix.sh
	mkdir baseoa
	mv *.pk3 baseoa
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	local ded_exe="ioq3ded" exe="ioquake3" fold ext
	if use smp ; then
		ext="-smp"
		ded_exe="${ded_exe}${ext}"
		exe="${exe}${ext}"
	fi
	if use amd64 ; then
		fold="bin/release-linux-x86_64"
		ext=".x86_64"
	else
		fold="bin/release-linux-i386"
		ext=".i386"
	fi
	mv ${S}/${fold}/* ${S}
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
	
	doicon "${FILESDIR}"/openarena.xpm
	make_desktop_entry ${PN} "Quake III - Open Arena" openarena.xpm

	prepgamesdirs
}
