# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# To-Do
# * Add amd64 capabilites (emul-libs)
# * Initscript for the dedicated server

inherit games

DESCRIPTION="Modified version of Icculus Quake 3 for Urban Terror 4.0"
HOMEPAGE="http://www.urbanterror.net"
FILE="ioUrbanTerror_1.0.zip"
SRC_URI="
	ftp://ftp.vectranet.pl/pub/gry/UrbanTerror/${FILE}
	http://media.digitalamusement.com/urt4/${FILE}
	http://unfoog.de/mirror/${FILE}
	"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="dedicated opengl"

DEPEND="
	>=games-fps/quake3-urbanterror-4.0
	app-arch/unzip
"

# this list was compiled according to "ldd ioUrbanTerror.i386"
RDEPEND="
	>=games-fps/quake3-urbanterror-4.0
	sys-libs/glibc
	opengl? (
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		sys-libs/gpm
		sys-libs/ncurses
		media-libs/libsdl
		media-libs/aalib
	)
	"

S="${WORKDIR}"
optdir="${GAMES_PREFIX_OPT}/${P}"

# do we want to install the gui part of ioUrbanTerror?
default_client() {
	if use opengl || ! use dedicated
	then
		# Use opengl by default
		return 0
	else
		return 1
	fi
}

src_install() {
	# binaries
	dodir "${optdir}"
	exeinto "${optdir}"

	if default_client
	then
		# game binary
		doexe Linux-i386/ioUrbanTerror.i386
		games_make_wrapper ${PN} ./ioUrbanTerror.i386 "${optdir}" "${optdir}"

		# icon and desktop entry
		newicon Linux-i386/iourbanterror.png ${PN}.png
		make_desktop_entry ${PN} "ioUrbanTerror" ${PN}.png

		# BattlEye
		dodir "${optdir}/BattlEye"
		insinto "${optdir}/BattlEye"
		doins Linux-i386/BattlEye/*
	fi
	if use dedicated
	then
		doexe Linux-i386/ioUrTded.i386
		# insert nice initscript here
	fi

	# docs
	dodir "${optdir}/docs"
	insinto "${optdir}/docs"
	doins *.txt

	# symlink the mod
	dosym ${GAMES_DATADIR}/quake3/q3ut4 ${optdir}/ || die 

	# ensure proper permissions
	prepgamesdirs
}


