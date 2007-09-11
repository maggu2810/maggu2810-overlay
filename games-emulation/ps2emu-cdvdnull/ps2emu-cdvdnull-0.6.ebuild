# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="PSEmu2 CD/DVD null plugin"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="pcsx0.9.3_and_plugins_src.7z"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/p7zip"

S=${WORKDIR}/plugins/cdvd/CDVDnull/Src

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's:-O2 -fomit-frame-pointer:$(OPTFLAGS):' \
		-e '/strip/d' \
		-e '/${STRIP} ${PLUGIN}/d' \
		Makefile || die
}

src_compile() {
	cd "${S}"
	emake OPTFLAGS="${CFLAGS}" || die
}

src_install() {
	dodoc "${S}"/../ReadMe.txt
	exeinto "$(games_get_libdir)"/ps2emu/plugins
	newexe libCDVDnull.so libCDVDiso-${PV}.so || die
	prepgamesdirs
}
