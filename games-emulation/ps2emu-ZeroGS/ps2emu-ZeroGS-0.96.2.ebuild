# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games autotools

DESCRIPTION="PSEmu2 ZeroGS OpenGL plugin"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="pcsx0.9.3_and_plugins_src.7z"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE="sse2 devbuild debug"

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}
	media-gfx/nvidia-cg-toolkit
	app-arch/p7zip
	>=x11-libs/gtk+-2"

S=${WORKDIR}/plugins/gs/zerogs/opengl

RESTRICT="fetch"

pkg_nofetch() {
	einfo "At the moment, there is no clean way to" 
	einfo "automatically download the ${P} sources."
	
	einfo "You can download them manually at http://www.pcsx2.net/files/8022 or"
	einfo "http://www.pcsx2.net/thel33tback3nd/attachment.php?aid=8022"
	einfo "and place them in ${DISTDIR} named pcsx${PV}_and_plugins_src.7z"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# There are a bunch of .svn folders from a svn checkout in the tarball
	# they need to be removed.
	find . -name .svn | xargs -r rm -rf

	# preserve custom cflags passed to configure
	epatch "${FILESDIR}"/${P}-custom-cflags.patch

	eautoreconf -v --install || die "Error: eautoreconf failed!"
	chmod +x configure
}

src_compile() {
	egamesconf $(use_enable sse2) \
		$(use_enable devbuild) \
		$(use_enable debug) \
		|| die "Error: econf failed!"
	emake || die "Error: emake failed!"
}

src_install() {
	exeinto "$(games_get_libdir)"/ps2emu/plugins
	doexe  libZeroGSogl*.so.${PV} || die "newexe failed"

	insinto "$(games_get_libdir)"/ps2emu/plugins
	doins "${S}"/Win32/ps2hw.dat || die "doins failed"
	prepgamesdirs
}
