# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/ps2emu-usbnull/ps2emu-usbnull-0.4.ebuild,v 1.4 2007/04/09 15:54:33 nyhm Exp $

inherit games

DESCRIPTION="PSEmu2 NULL FireWire plugin"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="pcsx0.9.3_and_plugins_src.7z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="=x11-libs/gtk+-1.2*"
DEPEND="${RDEPEND}
	app-arch/p7zip"

S=${WORKDIR}/plugins/fw/FWnull/Linux

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/strip ${CFG}/d' \
		-e '/strip --strip-unneeded --strip-debug ${PLUGIN}/d' \
		Makefile || die
}

src_install() {
	dodoc "${S}"/../ReadMe.txt
	exeinto "$(games_get_libdir)"/ps2emu/plugins
	newexe libFWnull.so libFWnull-${PV//.}.so || die
	exeinto "$(games_get_libdir)"/ps2emu/plugins/cfg
	doexe cfgFWnull || die
	prepgamesdirs
}
