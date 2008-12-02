# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde
inherit eutils subversion

DESCRIPTION="Kdenlive! (pronounced Kay-den-live) is a Non Linear Video Editing Suite for KDE."
HOMEPAGE="http://kdenlive.sourceforge.net/"

ESVN_REPO_URI="https://kdenlive.svn.sourceforge.net/svnroot/kdenlive/trunk/kdenlive"
# SRC_URI="mirror://sourceforge/kdenlive/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="theora quicktime"

RDEPEND=">=media-libs/libsdl-1.2.8-r1
	>=media-libs/sdl-image-1.2.3-r1
	>=media-libs/libsamplerate-0.1.1-r1
	>=media-libs/libogg-1.1.2
	>=media-libs/libvorbis-1.1.0
	>=media-sound/lame-3.96.1
	>=media-libs/libdv-0.104-r1
	theora? ( >=media-libs/libtheora-1.0_alpha6 )
	quicktime? ( >=media-libs/libquicktime-0.9.7-r1 )
	>=media-video/ffmpeg-0.4.9_p20060302
	>=media-libs/mlt-0.2.2
	>=media-libs/mlt++-20060601"

DEPEND="${RDEPEND}
	|| ( (
			x11-base/xorg-server
			x11-libs/libXt
			x11-proto/xextproto
		) virtual/x11 )
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.58
	>=sys-devel/automake-1.8.3"

need-kde 3

S="${WORKDIR}/${P/.0/}"

pkg_setup() {
	if ! built_with_use media-libs/mlt sdl; then
		eerror "You need to build media-libs/mlt with USE=sdl enabled."
		die "mlt w/o sdl detected"
	fi
}
