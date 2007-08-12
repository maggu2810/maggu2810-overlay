# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvsd/root/portage/media-video/avidemux/avidemux-23000-r1.ebuild,v 1.1 2006/11/07 23:51:35 root Exp $

inherit eutils flag-o-matic subversion

DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
ESVN_REPO_URI="svn://svn.berlios.de/avidemux/branches/avidemux_2.3_branch"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="a52 aac alsa altivec arts esd mp3 nls nopo vorbis sdl truetype x264 xvid xv oss"

RDEPEND="
	>=x11-libs/gtk+-2.6
	>=dev-libs/libxml2-2.6.7
	>=dev-lang/spidermonkey-1.5-r2
	a52? ( >=media-libs/a52dec-0.7.4 )
	aac? ( >=media-libs/faac-1.23.5
	       >=media-libs/faad2-2.0-r7 )
	esd? ( media-sound/esound )
	mp3? ( media-libs/libmad
	       >=media-sound/lame-3.93 )
	xvid? ( >=media-libs/xvid-1.0.0 )
	x264? ( >=media-libs/x264-svn-20061014 )
	nls? ( >=sys-devel/gettext-0.12.1 )
	vorbis? ( >=media-libs/libvorbis-1.0.1 )
	arts? ( >=kde-base/arts-1.2.3 )
	truetype? ( >=media-libs/freetype-2.1.5 )
	alsa? ( >=media-libs/alsa-lib-1.0.9 )
	sdl? ( media-libs/libsdl )
	|| ( (
			xv? ( x11-libs/libXv )
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXrender
		) virtual/x11 )"

DEPEND="$RDEPEND
	|| ( (
			x11-base/xorg-server
			x11-libs/libXt
			x11-proto/xextproto
		) virtual/x11 )
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.58
	>=sys-devel/automake-1.8.3"

pkg_setup() {
	filter-flags "-fno-default-inline"
	filter-flags "-funroll-loops"
	filter-flags "-funroll-all-loops"
	filter-flags "-fforce-addr"

	if ! built_with_use dev-lang/spidermonkey threadsafe ; then
		eerror "dev-lang/spidermonkey is missing threadsafe support, please"
		eerror "make sure you enable the threadsafe USE flag and re-emerge"
		eerror "dev-lang/spidermonkey - this Avidemux subversion build"
		eerror "will not compile nor work without it!"
		die "dev-lang/spidermonkey needs threadsafe support"
	fi

	if ! ( use oss || use arts || use alsa ); then
		die "You must select at least one between oss, arts and alsa audio output."
	fi
}

src_unpack() {
	subversion_src_unpack
	cd ${S} || die

	epatch ${FILESDIR}/dts-internal.patch
	sed -i -e 's/x264=no,-lm/x264=no,-lm -lX11/' configure.in.in || die "sed failed."

	# svn build sometimes borks on translation files
	if useq nopo ; then
		sed -i -e 's/po//' subdirs || die "sed failed."
		sed -i -e 's/po m4/m4/' Makefile.am || die "sed failed."
	else
		ewarn ""
		ewarn "If this build borks with an error while in the avidemux-23000/po"
		ewarn "directory, then try emerging with the nopo USE flag. This will"
		ewarn "disable the translations, but let the compile continue."
		ewarn ""
		ebeep 5
	fi

	gmake -f Makefile.dist || die "autotools failed."
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_enable altivec) \
		$(use_enable xv) \
		$(use_with arts) \
		$(use_with alsa) \
		$(use_with esd) \
		$(use_with oss) \
		$(use_with vorbis) \
		$(use_with a52 a52dec) \
		$(use_with sdl libsdl) \
		$(use_with truetype freetype2) \
		$(use_with aac faac) $(use_with aac faad2) \
		$(use_with xvid) \
		$(use_with x264) \
		$(use_with mp3 lame) $(use_with mp3 libmad) \
		--with-newfaad --with-jsapi-include=/usr/include/js \
		--disable-warnings --disable-dependency-tracking \
		${myconf} || die "configure failed"
	emake || die "emake failed"
}

src_install() {
# removed until we figure out why it's broke
#	make DESTDIR=${D} install || die "make install failed"
	dobin avidemux/avidemux2
	dodoc AUTHORS ChangeLog History README TODO
	insinto /usr/share/pixmaps
	newins ${S}/avidemux_icon.png avidemux.png
	make_desktop_entry avidemux2 "Avidemux2" avidemux.png
}

pkg_postinst() {
	if use ppc && use oss; then
		echo
		einfo "OSS sound output may not work on ppc"
		einfo "If your hear only static noise, try"
		einfo "changing the sound device to ALSA or arts"
	fi
	einfo "Big Fat Warning: This is a live SVN ebuild."
	einfo "Use at your own risk."
}
