# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic subversion

RESTRICT="nostrip"
IUSE="X 3dfx 3dnow 3dnowext a52 aac aalib alsa altivec amrnb amrwb arts ass
	bidi bindist bl cddb cdparanoia color-console cpudetection custom-cflags
	debug dga doc dvb directfb dvd dv dvdnav dvdread enca encode esd
	fbcon fpm ftp gif ggi gtk i8x0 ipv6 ivtv jack joystick jpeg
	ladspa libcaca lirc live livecd lzo matrox mga mmx mmxext mp2 mp3 mpeg
	musepack nas nls nut nvidia openal opengl oss png pnm pulseaudio quicktime
	radio rar real rtc samba sdl sortsub speex sse sse2 svga tga theora tivo
	truetype unicode v4l v4l2 vorbis win32codecs x264 xanim xinerama xmga xv
	xvid xvmc zoran darknrg"

LANGS="bg cs de da el en es fr hu ja ko mk nl no pl pt_BR ro ru sk tr uk zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

S="${WORKDIR}/${PN}"
SRC_URI="mirror://mplayer/releases/fonts/font-arial-iso-8859-1.tar.bz2
	mirror://mplayer/releases/fonts/font-arial-iso-8859-2.tar.bz2
	mirror://mplayer/releases/fonts/font-arial-cp1250.tar.bz2
	svga? ( mirror://mplayer/contrib/svgalib/svgalib_helper-1.9.17-mplayer.tar.bz2 )
	gtk? ( mirror://mplayer/Skin/productive-1.0.tar.bz2 )"
	# Only install Skin if GUI should be build (gtk as USE flag)

ESVN_REPO_URI="svn://svn.mplayerhq.hu/mplayer/trunk"
ESVN_PROJECT="mplayer"

DESCRIPTION="A very versatile media player"
HOMEPAGE="http://www.mplayerhq.hu/"

# 'encode' in USE for MEncoder.
RDEPEND="sys-libs/ncurses
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	amrnb? ( media-libs/amrnb )
	amrwb? ( media-libs/amrwb )
	arts? ( kde-base/arts )
	bidi? ( dev-libs/fribidi )
	cdparanoia? ( media-sound/cdparanoia )
	dga? ( x11-libs/libXxf86dga )
	directfb? ( dev-libs/DirectFB )
	dvb? ( media-tv/linuxtv-dvb-headers )
	dvdnav? ( media-libs/libdvdnav )
	dvdread? ( media-libs/libdvdread )
	enca? ( app-i18n/enca )
	encode? (
		aac? ( media-libs/faac )
		dv? ( >=media-libs/libdv-0.9.5 )
		mp3? ( media-sound/lame )
		x264? ( >=media-libs/x264-svn-20061014 )
		)
	esd? ( media-sound/esound )
	fontconfig? ( media-libs/fontconfig )
	gif? ( media-libs/giflib )
	ggi? ( media-libs/libggi )
	gtk? ( media-libs/libpng
		   x11-libs/libXxf86vm
		   x11-libs/libXext
		   x11-libs/libXi
		   =x11-libs/gtk+-2*
		   =dev-libs/glib-2* )
	jpeg? ( media-libs/jpeg )
	ladspa? ( media-libs/ladspa-sdk )
	libcaca? ( media-libs/libcaca )
	lirc? ( app-misc/lirc )
	live? ( >=media-plugins/live-2007.02.20 )
	lzo? ( =dev-libs/lzo-1* )
	mp2? ( media-sound/twolame )
	mp3? ( media-libs/libmad )
	musepack? ( >=media-libs/libmpcdec-1.2.2 )
	nas? ( media-libs/nas )
	nls? ( virtual/libintl )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )
	pulseaudio? ( media-sound/pulseaudio )
	quicktime? ( media-libs/libquicktime )
	real? ( x86? ( >=media-video/realplayer-10.0.3 )
			amd64? ( media-libs/amd64codecs ) )
	samba? ( >=net-fs/samba-2.2.8a )
	sdl? ( media-libs/libsdl )
	speex? ( media-libs/speex )
	svga? ( media-libs/svgalib )
	theora? ( media-libs/libtheora )
	vorbis? ( media-libs/libvorbis )
	truetype? ( >=media-libs/freetype-2.1
				media-libs/fontconfig )
	win32codecs? ( >=media-libs/win32codecs-20040916 )
	xanim? ( >=media-video/xanim-2.80.1-r4 )
	xinerama? ( x11-libs/libXinerama
				x11-libs/libXxf86vm
				x11-libs/libXext )
	xvid? ( >=media-libs/xvid-1.0 )
	xv? ( x11-libs/libXv
		  x11-libs/libXxf86vm
		  x11-libs/libXext
		  xvmc? ( x11-libs/libXvMC ) )
	X? ( x11-libs/libXxf86vm
		 x11-libs/libXext
		 joystick? ( x11-drivers/xf86-input-joystick ) )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( >=app-text/docbook-sgml-dtd-4.1.2
		   app-text/docbook-xml-dtd
		   >=app-text/docbook-xml-simple-dtd-1.50.0
		   dev-libs/libxslt
		   )
	jack? ( >=media-libs/bio2jack-0.4 )
	nls? ( sys-devel/gettext )
	dga? ( x11-proto/xf86dgaproto )
	xinerama? ( x11-proto/xineramaproto )
	xv? ( x11-proto/videoproto
		  x11-proto/xf86vidmodeproto )
	gtk? ( x11-proto/xextproto
		   x11-proto/xf86vidmodeproto )
	X? ( x11-proto/xextproto
		 x11-proto/xf86vidmodeproto )
	unicode? ( virtual/libiconv )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""

pkg_setup() {
	if use real && use x86 ; then
		REALLIBDIR="/opt/RealPlayer/codecs"
	elif use real && use amd64 && ! use bindist ; then
		REALLIBDIR="/usr/$(get_libdir)/codecs"
	fi

	if use truetype && ! use unicode ; then
		echo
		ewarn "You enabled the 'truetype' USE flag, but support will be"
		ewarn "disabled unless you also use 'unicode'!"
		echo
	fi
}

src_unpack() {

	subversion_src_unpack

	cd ${WORKDIR}
	if ! use truetype || ! use unicode ; then
		unpack font-arial-iso-8859-1.tar.bz2 \
			   font-arial-iso-8859-2.tar.bz2 \
			   font-arial-cp1250.tar.bz2
	fi

	use svga && unpack svgalib_helper-1.9.17-mplayer.tar.bz2

	use gtk && unpack productive-1.0.tar.bz2

	# For Version Branding
	cd "${ESVN_STORE_DIR}/${ESVN_CO_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}"
	./version.sh
	mv version.h ${S}

	cd ${S}

	epatch "${FILESDIR}/disable-version-rebranding.patch"
	#epatch "${FILESDIR}/eac3v2.patch"

	# Fix hppa compilation
	[ "${ARCH}" = "hppa" ] && sed -i -e "s/-O4/-O1/" "${S}/configure"

	if use svga
	then
		echo
		einfo "Enabling vidix non-root mode."
		einfo "(You need a proper svgalib_helper.o module for your kernel"
		einfo " to actually use this)"
		echo

		mv ${WORKDIR}/svgalib_helper ${S}/libdha
	fi

	# Remove kernel-2.6 workaround as the problem it works around is
	# fixed, and the workaround breaks sparc
	use sparc && sed -i 's:#define __KERNEL__::' osdep/kerneltwosix.h

	# minor fix
	sed -i -e "s:-O4:-O4 -D__STDC_LIMIT_MACROS:" configure

	use darknrg && epatch ${FILESDIR}/darknrg.patch
}

src_compile() {

	local myconf=" --disable-tv-bsdbt848 \
		--disable-vidix-external \
		--disable-faad-external \
		--disable-libcdio"

	# have fun with LINGUAS variable
	[[ -n $LINGUAS ]] && LINGUAS=${LINGUAS//da/dk}
	local myconf_linguas="--language=en"
	for x in ${LANGS}; do
		if use linguas_${x}; then
			myconf_linguas="${myconf_linguas} --language=${x}"
		fi
	done
	myconf="${myconf} ${myconf_linguas}"

	#####################
	# Optional features #
	#####################
	if use cpudetection || use livecd || use bindist
	then
		myconf="${myconf} --enable-runtime-cpudetection"
	fi

	if use unicode
	then
		myconf="${myconf} --charset=UTF-8"
	else
		myconf="${myconf} --disable-iconv"
		myconf="${myconf} --charset=noconv"
	fi

	use ass || myconf="${myconf} --disable-ass"
	use bidi || myconf="${myconf} --disable-fribidi"
	use bl && myconf="${myconf} --enable-bl"
	use cddb || myconf="${myconf} --disable-cddb"
	use cdparanoia || myconf="${myconf} --disable-cdparanoia"
	use enca || myconf="${myconf} --disable-enca"
	use ftp || myconf="${myconf} --disable-ftp"
	use nut || myconf="${myconf} --disable-libnut"
	use sortsub || myconf="${myconf} --disable-sortsub"
	use tivo || myconf="${myconf} --disable-vstream"

	if use dvd
	then
		use dvdread || myconf="${myconf} --disable-dvdread"
		use dvdnav || myconf="${myconf} --disable-dvdnav"
	else
		myconf="${myconf} --disable-dvdnav --disable-dvdread"
	fi

	if use encode ; then
		myconf="${myconf} --enable-mencoder"
		use aac || myconf="${myconf} --disable-faac"
		use dv || myconf="${myconf} --disable-libdv"
		use x264 || myconf="${myconf} --disable-x264"
	else
		myconf="${myconf} --disable-mencoder --disable-faac --disable-libdv --disable-x264"
	fi

	if use !gtk && use !X && use !xv && use !xinerama; then
		myconf="${myconf} --disable-gui --disable-x11 --disable-xv \
			--disable-xmga --disable-xinerama --disable-vm --disable-xvmc"
	else
		#note we ain't touching --enable-vm.  That should be locked down in the future.
		myconf="${myconf} $(use_enable gtk gui) $(use_enable gtk xshape) \
			$(use_enable X x11) $(use_enable xinerama) $(use_enable xv)"
	fi

	# disable PVR support
	# The build will break if you have media-tv/ivtv installed and
	# linux-headers != 2.6.18, which is currently not keyworded
	myconf="${myconf} --disable-pvr"

	myconf="${myconf} $(use_enable color-console)"
	myconf="${myconf} $(use_enable ipv6 inet6)"
	myconf="${myconf} $(use_enable joystick)"
	myconf="${myconf} $(use_enable lirc)"
	use live || myconf="${myconf} --disable-live"
	myconf="${myconf} $(use_enable radio) $(use_enable radio radio-capture)"
	use radio && use v4l2 || myconf="${myconf} --disable-radio-v4l2"
	myconf="${myconf} $(use_enable rar unrarlib)"
	myconf="${myconf} $(use_enable rtc)"
	myconf="${myconf} $(use_enable samba smb)"
	myconf="${myconf} $(use_enable truetype freetype)"
	use truetype || myconf="${myconf} --disable-fontconfig"

	# Video4Linux / Radio support
	if ( use v4l || use v4l2 || use radio ); then
		use v4l	|| myconf="${myconf} --disable-tv-v4l1"
		use v4l2 || myconf="${myconf} --disable-tv-v4l2"
		if use radio; then
			myconf="${myconf} --enable-radio $(use_enable encode radio-capture)"
		else
			myconf="${myconf} --disable-radio-v4l2 --disable-radio-bsdbt848"
		fi
	else
		myconf="${myconf} --disable-tv --disable-tv-v4l1 --disable-tv-v4l2 \
			--disable-radio --disable-radio-v4l2 --disable-radio-bsdbt848"
	fi

	##########
	# Codecs #
	##########
	for x in gif jpeg ladspa live musepack pnm speex theora xanim xvid; do
		use ${x} || myconf="${myconf} --disable-${x}"
	done
	use aac || myconf="${myconf} --disable-faad-internal"
	use aac && use fpm && myconf="${myconf} --enable-faad-fixed"
	use a52 || myconf="${myconf} --disable-liba52"
	use amrnb || myconf="${myconf} --disable-libamr_nb"
	use amrwb || myconf="${myconf} --disable-libamr_wb"
	! use png && ! use gtk && myconf="${myconf} --disable-png"
	use lzo || myconf="${myconf} --disable-liblzo"
	use mpeg || myconf="${myconf} --disable-libmpeg2"
	use mp2 || myconf="${myconf} --disable-twolame --disable-toolame"
	use mp3 || myconf="${myconf} --disable-mp3lib --disable-mad"
	use quicktime || myconf="${myconf} --disable-qtx"
	use vorbis || myconf="${myconf} --disable-libvorbis"
	use xanim && myconf="${myconf} --xanimcodecsdir=/usr/lib/xanim/mods"
	if use x86 || use amd64; then
		# Real codec support, only available on x86, amd64
		if use real ; then
			myconf="${myconf} --enable-real --realcodecsdir=${REALLIBDIR}"
		else
			myconf="${myconf} --disable-real"
		fi
		! use livecd && ! use bindist && \
			myconf="${myconf} $(use_enable win32codecs win32dll)"
	fi

	################
	# Video Output #
	################
	myconf="${myconf} $(use_enable 3dfx)"
	if use 3dfx; then
		myconf="${myconf} --enable-tdfxvid"
	else
		myconf="${myconf} --disable-tdfxvid"
	fi
	if use fbcon && use 3dfx; then
		myconf="${myconf} --enable-tdfxfb"
	else
		myconf="${myconf} --disable-tdfxfb"
	fi

	if use dvb ; then
		myconf="${myconf} --enable-dvbhead"
	else
		myconf="${myconf} --disable-dvbhead"
	fi

	use aalib || myconf="${myconf} --disable-aa"
	myconf="${myconf} $(use_enable directfb)"
	myconf="${myconf} $(use_enable fbcon fbdev)"
	myconf="${myconf} $(use_enable ggi)"
	use ivtv || myconf="${myconf} --disable-ivtv"
	myconf="${myconf} $(use_enable libcaca caca)"
	if use matrox && use X; then
		myconf="${myconf} $(use_enable matrox xmga)"
	fi
	myconf="${myconf} $(use_enable matrox mga)"
	myconf="${myconf} $(use_enable opengl gl)"
	myconf="${myconf} $(use_enable sdl)"
	if use svga
	then
		myconf="${myconf} --enable-svga"
	else
		myconf="${myconf} --disable-svga --disable-vidix-internal"
	fi

	myconf="${myconf} $(use_enable tga)"
	use zoran || myconf="${myconf} --disable-zr"

	( use xvmc && use nvidia ) \
		&& myconf="${myconf} --enable-xvmc --with-xvmclib=XvMCNVIDIA"

	( use xvmc && use i8x0 ) \
		&& myconf="${myconf} --enable-xvmc --with-xvmclib=I810XvMC"

	( use xvmc && use nvidia && use i8x0 ) \
		&& {
			eerror "Invalid combination of USE flags"
			eerror "When building support for xvmc, you may only"
			eerror "include support for one video card:"
			eerror "   nvidia or i8x0"
			eerror
			eerror "Emerge again with different USE flags"
			exit 1
		}

	( use xvmc && ! use nvidia && ! use i8x0 ) && {
		ewarn "You tried to build with xvmc support."
		ewarn "No supported graphics hardware was specified."
		ewarn
		ewarn "No xvmc support will be included."
		ewarn "Please one appropriate USE flag and re-emerge:"
		ewarn "   nvidia or i8x0"

		myconf="${myconf} --disable-xvmc"
	}

	if use xv && ! use xvmc
	then
		myconf="${myconf} --disable-xvmc"
	fi

	################
	# Audio Output #
	################
	use alsa || myconf="${myconf} --disable-alsa"
	use arts || myconf="${myconf} --disable-arts"
	use esd  || myconf="${myconf} --disable-esd"
	use jack || myconf="${myconf} --disable-jack"
	use mp3  || myconf="${myconf} --disable-mad"
	use nas  || myconf="${myconf} --disable-nas"
	use openal || myconf="${myconf} --disable-openal"
	use oss  || myconf="${myconf} --disable-ossaudio"
	use pulseaudio  || myconf="${myconf} --disable-pulse"

	####################
	# Advanced Options #
	####################
	# Platform specific flags, hardcoded on amd64 (see below)
	use x86 && myconf="${myconf} $(use_enable sse)"
	use x86 && myconf="${myconf} $(use_enable sse2)"
	use x86 && myconf="${myconf} $(use_enable mmx)"
	myconf="${myconf} $(use_enable mmxext)"
	myconf="${myconf} $(use_enable 3dnow)"
	myconf="${myconf} $(use_enable 3dnowext)"
	use debug && myconf="${myconf} --enable-debug=3"

	# mplayer now contains SIMD assembler code for amd64
	# AMD64 Team decided to hardenable SIMD assembler for all users
	if use amd64; then
		myconf="${myconf} --enable-sse --enable-sse2 --enable-mmx"
	fi

	if use ppc64
	then
		myconf="${myconf} --disable-altivec"
	else
		myconf="${myconf} $(use_enable altivec)"
		use altivec && append-flags -maltivec -mabi=altivec
	fi

	if use xanim
	then
		myconf="${myconf} --xanimcodecsdir=/usr/lib/xanim/mods"
	fi

	if [ -e /dev/.devfsd ]
	then
		myconf="${myconf} --enable-linux-devfs"
	fi

	echo "${myconf}" > ${T}/configure-options

	if use custom-cflags; then
		# let's play the filtration game!  MPlayer hates on all!
		strip-flags
		# ugly optimizations cause MPlayer to cry on x86 systems!
			if use x86 ; then
				replace-flags -O* -O2
				filter-flags -fPIC -fPIE
				use debug || append-flags -fomit-frame-pointer
			fi
		append-flags -D__STDC_LIMIT_MACROS
	else
		unset CFLAGS CXXFLAGS
	fi

	CFLAGS="$CFLAGS" ./configure \
		"--cc=$(tc-getCC)" "--host-cc=$(tc-getBUILD_CC)" \
		--prefix=/usr \
		--confdir=/usr/share/mplayer \
		--datadir=/usr/share/mplayer \
		--libdir=/usr/$(get_libdir) \
		--enable-largefiles \
		--enable-menu \
		--enable-network \
		${myconf} || die

	# we run into problems if -jN > -j1
	# see #86245
	MAKEOPTS="${MAKEOPTS} -j1"

	einfo "Make"
	emake || die "Failed to build MPlayer!"
	use doc && make -C DOCS/xml html-chunked
	einfo "Make completed"

}

src_install() {

	einfo "Make install"
	make prefix=${D}/usr \
		 BINDIR=${D}/usr/bin \
		 LIBDIR=${D}/usr/$(get_libdir) \
		 CONFDIR=${D}/usr/share/mplayer \
		 DATADIR=${D}/usr/share/mplayer \
		 MANDIR=${D}/usr/share/man \
		 install || die "Failed to install MPlayer!"
	einfo "Make install completed"

	dodoc AUTHORS ChangeLog README
	# Install the documentation; DOCS is all mixed up not just html
	if use doc ; then
		find "${S}/DOCS" -type d | xargs -- chmod 0755
		find "${S}/DOCS" -type f | xargs -- chmod 0644
		cp -r "${S}/DOCS" "${D}/usr/share/doc/${PF}/" || die
	fi

	# Copy misc tools to documentation path, as they're not installed directly
	# and yes, we are nuking the +x bit.
	find "${S}/TOOLS" -type d | xargs -- chmod 0755
	find "${S}/TOOLS" -type f | xargs -- chmod 0644
	cp -r "${S}/TOOLS" "${D}/usr/share/doc/${PF}/" || die

	# Install the default Skin and Gnome menu entry
	if use gtk; then
		dodir /usr/share/mplayer/skins
		cp -r ${WORKDIR}/productive ${D}/usr/share/mplayer/skins/default || die

		# Fix the symlink
		rm -rf ${D}/usr/bin/gmplayer
		dosym mplayer /usr/bin/gmplayer

		insinto /usr/share/pixmaps
		newins ${S}/Gui/mplayer/pixmaps/logo.xpm mplayer.xpm
		insinto /usr/share/applications
		doins ${FILESDIR}/mplayer.desktop
	fi

	if ! use truetype || ! use unicode; then
		dodir /usr/share/mplayer/fonts
		local x=
		# Do this generic, as the mplayer people like to change the structure
		# of their zips ...
		for x in $(find ${WORKDIR}/ -type d -name 'font-arial-*')
		do
			cp -pPR ${x} ${D}/usr/share/mplayer/fonts
		done
		# Fix the font symlink ...
		rm -rf ${D}/usr/share/mplayer/font
		dosym fonts/font-arial-14-iso-8859-1 /usr/share/mplayer/font
	fi

	insinto /etc
	newins ${S}/etc/example.conf mplayer.conf
	dosed -e 's/include =/#include =/' /etc/mplayer.conf
	dosed -e 's/fs=yes/fs=no/' /etc/mplayer.conf
	if use truetype && use unicode ; then
		cat >> "${D}"/etc/mplayer.conf << EOT
fontconfig=1
subfont-osd-scale=4
subfont-text-scale=3
EOT
	fi
	dosym ../../../etc/mplayer.conf /usr/share/mplayer/mplayer.conf

	#mv the midentify script to /usr/bin
	cp ${D}/usr/share/doc/${PF}/TOOLS/midentify ${D}/usr/bin
	chmod a+x ${D}/usr/bin/midentify

	insinto /usr/share/mplayer
	doins ${S}/etc/codecs.conf
	doins ${S}/etc/input.conf
	doins ${S}/etc/menu.conf
}

pkg_preinst() {

	if [ -d "${ROOT}/usr/share/mplayer/skins/default" ]
	then
		rm -rf ${ROOT}/usr/share/mplayer/skins/default
	fi
}

pkg_postinst() {

	if use matrox; then
		depmod -a &>/dev/null || :
	fi

	if use alsa ; then
		einfo "For those using alsa, please note the ao driver name is no longer"
		einfo "alsa9x or alsa1x.  It is now just 'alsa' (omit quotes)."
		einfo "The syntax for optional drivers has also changed.  For example"
		einfo "if you use a dmix driver called 'dmixer,' use"
		einfo "ao=alsa:device=dmixer instead of ao=alsa:dmixer"
		einfo "Some users may not need to specify the extra driver with the ao="
		einfo "command."
	fi

	if use dvdnav && use dvd; then
		ewarn "'dvdnav' support in MPlayer is known to be buggy, and will"
		ewarn "break if you are using it in GUI mode.  It is only"
		ewarn "included because some DVDs will only play with this feature."
		ewarn "If using it for playback only (and not menu navigation),"
		ewarn "specify the track # with your options."
		ewarn "mplayer dvdnav://1"
	fi
}

pkg_postrm() {

	# Cleanup stale symlinks
	if [ -L ${ROOT}/usr/share/mplayer/font -a \
	     ! -e ${ROOT}/usr/share/mplayer/font ]
	then
		rm -f ${ROOT}/usr/share/mplayer/font
	fi

	if [ -L ${ROOT}/usr/share/mplayer/subfont.ttf -a \
	     ! -e ${ROOT}/usr/share/mplayer/subfont.ttf ]
	then
		rm -f ${ROOT}/usr/share/mplayer/subfont.ttf
	fi
}
