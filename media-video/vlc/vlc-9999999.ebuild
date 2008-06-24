# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="svn://svn.videolan.org/vlc/trunk"

inherit libtool toolchain-funcs eutils wxwidgets subversion

PATCHLEVEL="4"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="a52 3dfx nls unicode debug altivec httpd vlm gnutls live v4l cdda ogg\
	matroska dvb dvd vcd ffmpeg aac flac mpeg vorbis theora X opengl freetype\
	svg fbcon svga oss aalib ggi libcaca esd arts alsa wxwindows ncurses xosd lirc\
	joystick hal stream mp3 xv bidi gtk2 sdl png xml2 samba daap corba screen mod\
	speex audioscrobbler debug dirac ffmpeg fribidi java libcddb libcdio live555\
	madmusipac python qt4 qt_embedded quicktime real screen skins2 svg tarkin\
	tremor twolame dvb dvbpsi vlm upnp debug vorbis mpc "

RDEPEND="hal? ( sys-apps/hal )
		3dfx? ( media-libs/glide-v3 )
		qt4? ( >=x11-libs/qt-4 )
		a52? ( media-libs/a52dec )
		aac? ( >=media-libs/faad2-2.0-r2 )
		aalib? ( media-libs/aalib )
		alsa? ( virtual/alsa )
		arts? ( kde-base/arts )
		bidi? ( >=dev-libs/fribidi-0.10.4 )
		cdda? ( >=dev-libs/libcdio-0.71		>=media-libs/libcddb-0.9.5 )
		corba? ( >=gnome-base/orbit-2.8.0  			>=dev-libs/glib-2.3.2 )
		daap? ( >=media-libs/libopendaap-0.3.0 )
        dirac? ( =media-video/dirac-0.5* )
		dvb? ( sys-kernel/linux-headers )
		dvd? (  media-libs/libdvdread media-libs/libdvdcss >=media-libs/libdvdnav-0.1.9 media-libs/libdvdplay )
		esd? ( media-sound/esound )
		ffmpeg? ( >=media-video/ffmpeg-99999999999 )
		flac? ( media-libs/flac )
		freetype? ( >=media-libs/freetype-2.2.1 media-fonts/ttf-bitstream-vera )
		ggi? ( media-libs/libggi )
		gnutls? ( >=net-libs/gnutls-1.0.17 )
		joystick? ( sys-kernel/linux-headers )
		libcaca? ( media-libs/libcaca )
		lirc? ( app-misc/lirc )
		live? ( >=media-plugins/live-2005.01.29 )
		matroska? ( >=media-libs/libmatroska-0.8.0 )
		media-libs/libdvbpsi
		mod? ( media-libs/libmodplug )
		mp3? ( media-libs/libmad )
		mpeg? ( >=media-libs/libmpeg2-0.3.2 )
		ncurses? ( sys-libs/ncurses )
		ogg? ( media-libs/libogg )
		opengl? ( virtual/opengl )
		png? ( media-libs/libpng )
		samba? ( net-fs/samba )
		sdl? ( >=media-libs/libsdl-1.2.8 )
		speex? ( media-libs/speex )
		svga? ( media-libs/svgalib )
		sys-libs/zlib
		theora? ( media-libs/libtheora )
		v4l? ( sys-kernel/linux-headers )
		vcd? ( >=dev-libs/libcdio-0.72			>=media-video/vcdimager-0.7.21 )
		vorbis? ( media-libs/libvorbis )
		wxwindows? ( =x11-libs/wxGTK-2.6* )
		xml2? ( dev-libs/libxml2 )
		xosd? ( x11-libs/xosd )
		svg? ( >=gnome-base/librsvg-2.5.0 )"

DEPEND="${RDEPEND}
		dev-util/subversion
		>=sys-devel/gettext-0.11.5
		=sys-devel/automake-1.6*
		sys-devel/autoconf
		dev-util/pkgconfig"

pkg_setup() {
	if use wxwindows; then
		WX_GTK_VER="2.6"
		if use gtk2; then
			if use unicode; then
				need-wxwidgets unicode || die "You need to install wxGTK with unicode support."
			else
				need-wxwidgets gtk2 || die "You need to install wxGTK with gtk2 support."
			fi
		else
			need-wxwidgets gtk || die "You need to install wxGTK with gtk support."
		fi
	fi
}

src_compile () {
	local myconf="${myconf} "

	./bootstrap || die "bootstrap failed"
	sed -i -e \
		"s:/usr/include/glide:/usr/include/glide3:;s:glide2x:glide3:" \
		configure || die "sed glide failed."

	# Fix the default font
	sed -i -e \
		"s:/usr/share/fonts/truetype/freefont/FreeSerifBold.ttf:/usr/share/fonts/ttf-bitstream-vera/VeraBd.ttf:" \
		modules/misc/freetype.c || die "sed failed"

	# Avoid timestamp skews with autotools
	touch configure.ac aclocal.m4 configure config.h.in \
		|| die "touch my trallala failed"
	find . -name Makefile.in | xargs touch || die "xargs failed"

	if use wxwindows; then
		myconf="${myconf} \
				--enable-wxwidgets \
				--with-wx-config=$(basename ${WX_CONFIG}) \
				--with-wx-config-path=$(dirname ${WX_CONFIG})"
	fi

	if use ffmpeg; then
		if ! built_with_use media-video/ffmpeg pp;then
			eerror "FFMpeg must be build with GPLed postprocessing support (use 'pp')"
			die "config failed"
		fi
		if ! built_with_use media-video/ffmpeg swscaler;then
			eerror "FFMpeg must	be build with swcale support (use 'swscaler')"
			die "config failed"
		fi;
		myconf="${myconf} --enable-ffmpeg"

		built_with_use media-video/ffmpeg aac \
			&& myconf="${myconf} --with-ffmpeg-aac"

		built_with_use media-video/ffmpeg dts \
			&& myconf="${myconf} --with-ffmpeg-dts"

		built_with_use media-video/ffmpeg zlib \
			&& myconf="${myconf} --with-ffmpeg-zlib"

		built_with_use media-video/ffmpeg encode \
			&& myconf="${myconf} --with-ffmpeg-mp3lame"
	else
		myconf="${myconf} --disable-ffmpeg"
	fi

	# Portaudio support needs at least v19
	# pth (threads) support is quite unstable with latest ffmpeg/libmatroska.
		./configure --prefix=/usr \
		--mandir=/usr/share/man --infodir=/usr/share/info --datadir=/usr/share \
		--sysconfdir=/etc --localstatedir=/var/lib \
		--disable-mozilla \
		--disable-portaudio \
		--disable-pth \
		--disable-slp --enable-debug \
		$(use_enable 3dfx glide) \
		$(use_enable 3dfx glide) \
		$(use_enable a52)        \
		$(use_enable aalib aa) 	 \
		$(use_enable alsa)       \
		$(use_enable altivec) 	 \
		$(use_enable arts) 		 \
		$(use_enable bidi fribidi) \
		$(use_enable cdda)       \
		$(use_enable cdda cddax) \
		$(use_enable corba)      \
		$(use_enable daap)       \
		$(use_enable debug)      \
		$(use_enable dirac)      \
		$(use_enable dvb)  	     \
		$(use_enable dvbpsi)     \
		$(use_enable dvb pvr)    \
		$(use_enable dvd dvdread) \
		$(use_enable dvd dvdplay) \
		$(use_enable dvd dvdnav)  \
		$(use_enable esd) 		 \
		$(use_enable fbcon fb)   \
		$(use_enable flac)       \
		$(use_enable freetype)   \
		$(use_enable fribidi)    \
		$(use_enable ggi)        \
		$(use_enable gnutls)     \
		$(use_enable hal)        \
		$(use_enable httpd)      \
		$(use_enable java java-bindings ) \
		$(use_enable joystick)   \
		$(use_enable libcaca caca) \
		$(use_enable libcddb)    \
		$(use_enable libcdio)    \
		$(use_enable lirc)       \
		$(use_enable live555)    \
		$(use_enable live livedotcom) \
		$(use_with live livedotcom-tree /usr/lib/live) \
		$(use_enable mad)        \
		$(use_enable matroska mkv) \
		$(use_enable mod)        \
		$(use_enable mp3 mad)    \
		$(use_enable mpeg libmpeg2) \
		$(use_enable ncurses)    \
		$(use_enable ogg)        \
		$(use_enable opengl glx) \
		$(use_enable opengl)     \
		$(use_enable oss)        \
		$(use_enable png)        \
		$(use_enable qt4 qt4)    \
		$(use_enable qt_embedded qte) \
		$(use_enable real real realrtsp) \
		$(use_enable samba smb)  \
	    $(use_enable screen)     \
		$(use_enable sdl)        \
		$(use_enable speex)      \
		$(use_enable stream sout) \
		$(use_enable svg )       \
		$(use_enable svga svgalib) \
		$(use_enable tarkin)     \
		$(use_enable theora)     \
		$(use_enable tremor)     \
		$(use_enable twolame)    \
		$(use_enable upnp)       \
		$(use_enable unicode utf8) \
		$(use_enable v4l)        \
		$(use_enable vcd)        \
		$(use_enable vcd vcdx)   \
		$(use_enable vlm)        \
		$(use_enable vorbis)     \
		$(use_enable wxwindows)  \
		$(use_enable xml2 libxml2) \
		$(use_enable xosd)       \
		$(use_enable xv xvideo)  \
		${myconf} || die "configuration failed"

	if [[ $(gcc-major-version) == 2 ]]; then
		sed -i -e \
			s:"-fomit-frame-pointer":: \
			vlc-config || die "-fomit-frame-pointer patching failed"
	fi

	emake -j1 || die "make of VLC failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed!"

	dodoc ABOUT-NLS AUTHORS MAINTAINERS HACKING THANKS TODO NEWS README \
		doc/fortunes.txt doc/intf-cdda.txt doc/intf-vcd.txt

	for res in 16 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins ${S}/share/vlc${res}x${res}.png vlc.png
	done

	make_desktop_entry vlc "VLC Media Player" vlc "AudioVideo;Player"
}
