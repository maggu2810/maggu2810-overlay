# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit games

MY_PV="061209"
DESCRIPTION="A realtime strategy game engine"
HOMEPAGE="http://www.stratagus.org/"
SRC_URI="mirror://sourceforge/stratagus/${PN}-${MY_PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc flac mp3 mikmod ogg opengl vorbis"

RDEPEND="app-arch/bzip2
	dev-lang/lua
	dev-util/scons
	media-libs/libpng
	media-libs/libsdl
	sys-libs/zlib
	flac? ( ~media-libs/flac-1.1.2 )
	mp3? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod )
	ogg? ( vorbis? ( media-libs/libogg media-libs/libvorbis ) )"

DEPEND="${RDEPEND}
	|| ( x11-libs/libXt virtual/x11 )
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/stratagus-${MY_PV}

src_compile() {
	scons || die
}

src_install() {
	dogamesbin stratagus || die "dogamesbin failed"
	dodoc README
	dohtml -r doc/*
	use doc && dohtml -r srcdoc/html/*
	prepgamesdirs
}
