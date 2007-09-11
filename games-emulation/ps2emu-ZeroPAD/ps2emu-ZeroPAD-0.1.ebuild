# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games autotools

DESCRIPTION="PSEmu2 PAD plugin"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="pcsx0.9.3_and_plugins_src.7z"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND="app-arch/p7zip"

S=${WORKDIR}/plugins/pad/zeropad

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's/CFLAGS=/CFLAGS+=" "/' \
		-e 's/CXXFLAGS=/CXXLAGS+=" "/' \
		-e 's/CPPFLAGS=/CPPLAGS+=" "/' \
		-e 's/"-O2 -fomit-frame-pointer "/" -O2 -fomit-frame-pointer "/g' \
		-e 's/"-g "/" -g "/g' \
		configure.ac || die
	eautoreconf -v --install
}

src_compile() {
	econf $(use_enable debug) \
		|| die "Error: econf failed!"
	emake || die "Error: emake failed!"
}

src_install() {
	exeinto "$(games_get_libdir)"/ps2emu/plugins
	doexe libZeroPAD.so.${PV}.0 || die
	prepgamesdirs
}
