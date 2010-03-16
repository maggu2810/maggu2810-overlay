# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools subversion eutils games

DESCRIPTION="Blobby Volley 2 - 1-on-1 volleyball"
HOMEPAGE="http://blobby.sourceforge.net"
SRC_URI=""

ESVN_REPO_URI="https://blobby.svn.sourceforge.net/svnroot/blobby/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-games/physfs
	virtual/opengl
	media-libs/libsdl"
# Some of the data files are zipped
DEPEND="${RDEPEND}
	app-arch/zip
	dev-libs/boost
	dev-util/cmake"

dir=${GAMES_DATADIR}/${PN}

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	cmake . || die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	exeinto "${dir}"
	doexe src/blobby{,-server} || die

	insinto "${dir}/data"
	doins -r data/* || die
	rm -rf "${D}/${dir}/data"/{CMakeFiles,cmake_install.cmake,Makefile}

	dodoc AUTHORS ChangeLog NEWS README TODO

	games_make_wrapper ${PN} ./blobby "${dir}"
	games_make_wrapper ${PN}-server ./blobby-server "${dir}"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "To host a network game, run:  blobby-server"
	elog
	elog "Your configuration may need to be reset:"
	elog "   rm -r ~/.blobby"
	echo
}
