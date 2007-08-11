# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.8.6c.ebuild,v 1.7 2007/07/22 08:35:38 dberkholz Exp $

WANT_AUTOMAKE=latest
WANT_AUTOCONF=latest

inherit eutils wxwidgets multilib autotools toolchain-funcs gnome2 nsplugins

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-beta/-test}"
MY_P="${PN}-${MY_PV}"

PATCHLEVEL="41"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"

if [[ "${P}" == *_p* ]]; then # Snapshots
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	MY_P="${P}"
elif [[ "${MY_P}" == "${P}" ]]; then
	SRC_URI="http://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"
else
	SRC_URI="http://download.videolan.org/pub/videolan/testing/${MY_P}/${MY_P}.tar.bz2"
fi

SRC_URI="${SRC_URI}
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="alpha amd64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="a52 3dfx debug altivec httpd vlm gnutls live v4l cdda ogg matroska
dvb dvd vcd dts flac mpeg vorbis theora X opengl truetype svg fbcon svga
oss aalib ggi libcaca esd arts alsa wxwindows ncurses xosd lirc stream
mp3 xv bidi sdl sdl-image png xml samba daap corba mod speex shout rtsp
win32codecs skins hal avahi xinerama cddb directfb upnp nsplugin seamonkey
optimisememory libnotify jack musepack x264 dc1394"

RDEPEND="
		>=media-video/ffmpeg-0.4.9_p20050226-r1
		cdda? ( >=dev-libs/libcdio-0.71
			cddb? ( >=media-libs/libcddb-1.2.0 ) )
		live? ( >=media-plugins/live-2005.01.29 )
		dvd? (	media-libs/libdvdread
				media-libs/libdvdcss
				>=media-libs/libdvdnav-0.1.9
				media-libs/libdvdplay )
		esd? ( media-sound/esound )
		ogg? ( media-libs/libogg )
		matroska? (
			>=dev-libs/libebml-0.7.6
			>=media-libs/libmatroska-0.8.0 )
		mp3? ( media-libs/libmad )
		a52? ( >=media-libs/a52dec-0.7.4-r3 )
		dts? ( || (  >=media-libs/libdts-0.0.2-r3 media-libs/libdca ) )
		flac? ( media-libs/libogg
			>=media-libs/flac-1.1.2 )
		mpeg? ( >=media-libs/libmpeg2-0.3.2 )
		vorbis? ( media-libs/libvorbis )
		theora? ( media-libs/libtheora )
		truetype? ( media-libs/freetype
			media-fonts/ttf-bitstream-vera )
		svga? ( media-libs/svgalib )
		ggi? ( media-libs/libggi )
		aalib? ( media-libs/aalib )
		libcaca? ( media-libs/libcaca )
		arts? ( kde-base/arts )
		alsa? ( media-libs/alsa-lib )
		wxwindows? ( >=x11-libs/wxGTK-2.8.0 )
		skins? ( >=x11-libs/wxGTK-2.8.0
			media-libs/freetype
			media-fonts/ttf-bitstream-vera )
		ncurses? ( sys-libs/ncurses )
		xosd? ( x11-libs/xosd )
		lirc? ( app-misc/lirc )
		3dfx? ( media-libs/glide-v3 )
		bidi? ( >=dev-libs/fribidi-0.10.4 )
		gnutls? ( >=net-libs/gnutls-1.2.9 )
		sys-libs/zlib
		png? ( media-libs/libpng )
		media-libs/libdvbpsi
		sdl? ( >=media-libs/libsdl-1.2.8
			sdl-image? ( media-libs/sdl-image ) )
		xml? ( dev-libs/libxml2 )
		samba? ( net-fs/samba )
		vcd? ( >=dev-libs/libcdio-0.72
			>=media-video/vcdimager-0.7.21 )
		daap? ( >=media-libs/libopendaap-0.3.0 )
		corba? ( >=gnome-base/orbit-2.8.0
			>=dev-libs/glib-2.3.2 )
		v4l? ( sys-kernel/linux-headers )
		dvb? ( sys-kernel/linux-headers )
		mod? ( media-libs/libmodplug )
		speex? ( media-libs/speex )
		svg? ( >=gnome-base/librsvg-2.5.0 )
		shout? ( media-libs/libshout )
		win32codecs? ( media-libs/win32codecs )
		hal? ( sys-apps/hal )
		avahi? ( >=net-dns/avahi-0.6 )
		X? (
			x11-libs/libX11
			x11-libs/libXext
			xv? ( x11-libs/libXv )
			xinerama? ( x11-libs/libXinerama )
			opengl? ( virtual/opengl )
		)
		directfb? ( dev-libs/DirectFB )
		upnp? ( net-libs/libupnp )
		nsplugin? (
			!seamonkey? ( www-client/mozilla-firefox )
			seamonkey? ( www-client/seamonkey )
		)
		libnotify? ( x11-libs/libnotify )
		musepack? ( media-libs/libmpcdec )
		x264? ( >=media-libs/x264-svn-20061014 )
		jack? ( >=media-sound/jack-audio-connection-kit-0.99.0-r1 )
		dc1394? ( sys-libs/libraw1394
			<media-libs/libdc1394-1.9.99 )"

DEPEND="${RDEPEND}
	X? ( xinerama? ( x11-proto/xineramaproto ) )
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use wxwindows || use skins; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode || die "You need to install wxGTK with unicode support."
	fi

	if use skins && ! use truetype; then
		ewarn "Trying to build with skins support but without truetype."
		ewarn "Enabling truetype."
	fi
	if use skins && ! use wxwindows; then
		ewarn "Trying to build with skins support but without wxwindows."
		ewarn "Enabling wxwindows."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	has_version '>=dev-libs/libcdio-0.78' || \
		export EPATCH_EXCLUDE="230_all_libcdio-0.78.2.patch"

	# Drop patches that have been merged
	EPATCH_EXCLUDE="${EPATCH_EXCLUDE} 260_all_format-string-sa23592.patch
	270_all_libtar-automagic.patch 280_all_sdl-image-automagic.patch
	300_all_fullscreen_amd64.patch 240_all_flac-1.1.3.patch"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	AT_M4DIR="m4" eautoreconf

	# Replace install-sh with libtool's copy
	cp /usr/share/libtool/install-sh "${S}/autotools"
}

src_compile () {
	local XPIDL=""
	local MOZILLA_CONFIG=""

	use vlm && \
		myconf="${myconf} --enable-vlm --enable-sout" || \
		myconf="${myconf} --disable-vlm"

	if use directfb; then
		myconf="${myconf} --enable-directfb --with-directfb=/usr"
		append-flags "-I /usr/include/directfb"
	else
		myconf="${myconf} --disable-directfb"
	fi

	if use nsplugin; then
		if use seamonkey; then
			XPIDL=/usr/lib/seamonkey
			MOZILLA_CONFIG=/usr/lib/seamonkey/seamonkey-config
		else
			XPIDL=/usr/lib/mozilla-firefox
			MOZILLA_CONFIG=/usr/lib/mozilla-firefox/firefox-config
		fi
	fi

	if use live && ! has_version '>=media-plugins/live-2006.12.08'; then
		myconf="${myconf} --enable-live555 --with-live555-tree=/usr/$(get_libdir)/live"
	else
		myconf="${myconf} $(use_enable live live555)"
	fi

	if use truetype || use skins; then
		myconf="${myconf} --enable-freetype"
	else
		myconf="${myconf} --disable-freetype"
	fi

	if use wxwindows || use skins; then
		myconf="${myconf} --enable-wxwidgets"
	else
		myconf="${myconf} --disable-wxwidgets"
	fi

	econf \
		$(use_enable altivec) \
		$(use_enable stream sout) \
		$(use_enable httpd) \
		$(use_enable gnutls) \
		$(use_enable v4l) \
		$(use_enable cdda) $(use_enable cdda cddax)\
		$(use_enable cddb libcddb) \
		$(use_enable vcd) $(use_enable vcd vcdx) \
		$(use_enable dvb) $(use_enable dvb pvr) \
		$(use_enable ogg) \
		$(use_enable matroska mkv) \
		$(use_enable flac) \
		$(use_enable vorbis) \
		$(use_enable theora) \
		$(use_enable X x11) \
		$(use_enable xv xvideo) \
		$(use_enable xinerama) \
		$(use_enable opengl glx) $(use_enable opengl) \
		$(use_enable bidi fribidi) \
		$(use_enable dvd dvdread) $(use_enable dvd dvdplay) $(use_enable dvd dvdnav) \
		$(use_enable fbcon fb) \
		$(use_enable svga svgalib) \
		$(use_enable 3dfx glide) \
		$(use_enable aalib aa) \
		$(use_enable libcaca caca) \
		$(use_enable oss) \
		$(use_enable esd) \
		$(use_enable arts) \
		$(use_enable alsa) \
		$(use_enable ncurses) \
		$(use_enable xosd) \
		$(use_enable lirc) \
		$(use_enable mp3 mad) \
		$(use_enable a52) \
		$(use_enable dts) \
		$(use_enable mpeg libmpeg2) \
		$(use_enable ggi) \
		$(use_enable 3dfx glide) \
		$(use_enable sdl) \
		$(use_enable sdl-image) \
		$(use_enable png) \
		$(use_enable xml libxml2) \
		$(use_enable samba smb) \
		$(use_enable daap) \
		$(use_enable corba) \
		$(use_enable mod) \
		$(use_enable speex) \
		$(use_enable shout) \
		$(use_enable rtsp) $(use_enable rtsp realrtsp) \
		$(use_enable win32codecs loader) \
		$(use_enable skins skins2) \
		$(use_enable hal) \
		$(use_enable avahi bonjour) \
		$(use_enable upnp) \
		$(use_enable optimisememory optimize-memory) \
		$(use_enable libnotify notify) \
		$(use_enable jack) \
		$(use_enable musepack mpc) \
		$(use_enable x264) \
		$(use_enable dc1394) \
		--enable-ffmpeg \
		--disable-faad \
		--disable-dv \
		--disable-libvc1 \
		--disable-snapshot \
		--disable-growl \
		--disable-pth \
		--disable-portaudio \
		--disable-libtar \
		--disable-optimizations \
		--enable-utf8 \
		--enable-libtool \
		$(use_enable nsplugin mozilla) \
		XPIDL="${XPIDL}" MOZILLA_CONFIG="${MOZILLA_CONFIG}" \
		WX_CONFIG="${WX_CONFIG}" \
		${myconf} || die "configuration failed"

	if [[ $(gcc-major-version) == 2 ]]; then
		sed -i -e s:"-fomit-frame-pointer":: vlc-config || die "-fomit-frame-pointer patching failed"
	fi

	emake || die "make of VLC failed"
}

src_install() {
	# First install the library, to avoid screwups during relinking.select
	emake -j1 DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS MAINTAINERS HACKING THANKS NEWS README \
		doc/fortunes.txt doc/intf-cdda.txt doc/intf-vcd.txt

	if use nsplugin; then
		dodir "/usr/$(get_libdir)/${PLUGINS_DIR}"
		mv "${D}"/usr/$(get_libdir)/mozilla/{components,plugins}/* \
			"${D}/usr/$(get_libdir)/${PLUGINS_DIR}/"
	fi

	rm -rf "${D}/usr/share/doc/vlc" \
		"${D}"/usr/share/vlc/vlc{16x16,32x32,48x48,128x128}.{png,xpm,ico}

	use skins || rm -rf "${D}/usr/share/vlc/skins2"

	for res in 16 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins "${S}"/share/vlc${res}x${res}.png vlc.png
	done

	use wxwindows || use skins || rm "${D}/usr/share/applications/vlc.desktop"
}
