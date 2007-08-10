# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils games

DESCRIPTION="Blobby Volley 2 - 1-on-1 volleyball"
HOMEPAGE="http://blobby.redio.de"
SRC_URI="mirror://sourceforge/blobby/${PN}-linux-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-games/physfs
	virtual/opengl
	media-libs/libsdl"
DEPEND="${RDEPEND}"

dir=${GAMES_DATADIR}/${PN}

src_unpack() {
	unpack ${A}

	# Standardize the directory name
	mv blobby* ${P} || die
	cd "${S}"

	# Look in shared directory for server.xml
	sed -i \
		-e "s:PHYSFS_addToSearchPath(\"data\":PHYSFS_addToSearchPath(\"${dir}\":" \
		src/DedicatedServer.cpp || die "sed DedicatedServer.cpp failed"
}

src_compile() {
	eautoreconf || die

	# Fix broken opengl recognition.
	# There's probably a better way of doing this.
	sed -i \
		-e "s:HAVE_LIBGL = @HAVE_LIBGL@:HAVE_LIBGL = 1:" \
		Makefile.in || die "sed Makefile.in failed"

	sed -i \
		-e "s:-lSDL:-lSDL -lGL:" \
		configure || die "sed configure failed"

	egamesconf \
		HAVE_LIBGL=1 \
		|| die "egamesconf failed"

	emake \
		GAMEDATADIR="${dir}" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dogamesbin src/blobby{,-server} || die
	make_desktop_entry blobby "Blobby Volley"

	insinto "${dir}"
	doins -r data/* || die
	rm -f "${D}/${dir}"/Makefile*

	dodoc AUTHORS ChangeLog NEWS README TODO
}
