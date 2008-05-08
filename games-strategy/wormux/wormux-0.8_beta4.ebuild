# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="A free Worms clone"
HOMEPAGE="http://www.wormux.org/"
MY_P="${PN}-0.8beta4"
SRC_URI="http://download.gna.org/wormux/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug nls"

RDEPEND=">=dev-cpp/libxmlpp-2.6
	>=media-libs/libsdl-1.2
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-ttf-2.0
	>=media-libs/sdl-gfx-2.0.13
	>=media-libs/sdl-net-1.2.6
	nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if ! built_with_use media-libs/sdl-mixer vorbis; then
                eerror "sdl-mixer is missing vorbis support. Please add"
                eerror "'vorbis' to your USE flags, and re-emerge media-libs/sdl-mixer."
                die "sdl-mixer needs vorbis support"
	fi
	if ! built_with_use  media-libs/sdl-image jpeg; then
                eerror "sdl-image is missing jpeg support. Please add"
                eerror "'jpeg' to your USE flags, and re-emerge media-libs/sdl-image."
                die "sdl-image needs jpeg support"
	fi
	if ! built_with_use  media-libs/sdl-image png; then
                eerror "sdl-image is missing png support. Please add"
                eerror "'png' to your USE flags, and re-emerge media-libs/sdl-image."
                die "sdl-image needs png support"
	fi
	if use nls && ! built_with_use sys-devel/gettext nls; then
                eerror "gettext is missing nls support. Please add"
                eerror "'nls' to your USE flags, and re-emerge sys-devel/gettext."
                die "gettext needs nls support"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# avoid the strip on install
	sed -i \
		-e "s/@INSTALL_STRIP_PROGRAM@/@INSTALL_PROGRAM@/" \
		src/Makefile.in \
		|| die "sed failed"
}

src_compile() {
	egamesconf \
		--with-datadir-name="${GAMES_DATADIR}/${PN}" \
		--with-localedir-name="/usr/share/locale" \
		$(use_enable debug) \
		$(use_enable nls) \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
	newicon data/wormux_32x32.xpm wormux.xpm
	make_desktop_entry wormux Wormux wormux.xpm
	prepgamesdirs
}
