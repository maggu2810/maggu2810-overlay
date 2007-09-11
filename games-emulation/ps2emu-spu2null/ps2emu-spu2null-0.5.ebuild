# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="PSEmu2 SPU2 null plugin"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="pcsx0.9.3_and_plugins_src.7z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/p7zip"

S=${WORKDIR}/plugins/spu2/SPU2null/Src

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/strip --strip-unneeded --strip-debug ${PLUGIN}/d' \
		Makefile || die
}

src_install() {
	dodoc "${S}"/../ReadMe.txt
	exeinto "$(games_get_libdir)"/ps2emu/plugins
	newexe libSPU2null.so libSPU2null-${PV}.so || die
	prepgamesdirs
}
