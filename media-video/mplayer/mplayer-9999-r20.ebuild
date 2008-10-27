# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils flag-o-matic multilib subversion

RESTRICT="strip"
IUSE="X 3dfx 3dnow 3dnowext +a52 +aac -aalib +alsa altivec amrnb amrwb -arts
	bidi bindist bl cddb cdio cdparanoia -cpudetection -custom-cflags debug
	dga dirac doc dvb directfb +dts +dvd dv dvdnav +enca encode -esd
	fbcon fpm ftp gif ggi -gtk i8x0 -icc ipv6 ivtv jack joystick jpeg ladspa
	libcaca lirc live livecd lzo matrox mga mmx mmxext +mp2 +mp3 +mpeg musepack
	nas nemesi nls nut openal opengl oss +png pnm pulseaudio pvr quicktime
	radio rar -real rtc samba schroedinger sdl speex +srt sse sse2 ssse3 svga
	tga	+theora tivo +truetype +unicode v4l v4l2 vidix +volume +vorbis
	-win32codecs +x264 xanim xinerama +xscreensaver +xv +xvid xvmc zoran"

VIDEO_CARDS="s3virge mga tdfx vesa"

for x in ${VIDEO_CARDS} ; do
	IUSE="${IUSE} video_cards_${x}"
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
	!bindist? (
		x86? (
			win32codecs? ( media-libs/win32codecs )
			real? ( media-libs/win32codecs
				media-video/realplayer )
			)
		amd64? ( real? ( media-libs/amd64codecs ) )
		amrnb? ( media-libs/amrnb )
		amrwb? ( media-libs/amrwb )
	)
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	bidi? ( dev-libs/fribidi )
	cdio? ( dev-libs/libcdio )
	cdparanoia? ( media-sound/cdparanoia )
	dga? ( x11-libs/libXxf86dga )
	dirac? ( media-video/dirac )
	directfb? ( dev-libs/DirectFB )
	dts? ( media-libs/libdca )
	dvb? ( media-tv/linuxtv-dvb-headers )
	dvdnav? ( >=media-libs/libdvdnav-9999
			 media-libs/libdvdread )
	enca? ( app-i18n/enca )
	encode? (
		aac? ( media-libs/faac )
		dv? ( media-libs/libdv )
		mp2? ( media-sound/twolame )
		mp3? ( media-sound/lame )
		x264? ( >=media-libs/x264-0.0.20081006 )
		)
	esd? ( media-sound/esound )
	fontconfig? ( media-libs/fontconfig )
	gif? ( media-libs/giflib )
	ggi? ( media-libs/libggi
		media-libs/libggiwmh )
	gtk? ( media-libs/libpng
		   x11-libs/libXxf86vm
		   x11-libs/libXext
		   x11-libs/libXi
		   x11-libs/gtk+:2 )
	jpeg? ( media-libs/jpeg )
	ladspa? ( media-libs/ladspa-sdk )
	libcaca? ( media-libs/libcaca )
	lirc? ( app-misc/lirc )
	live? ( >=media-plugins/live-2007.02.20 )
	lzo? ( dev-libs/lzo:2 )
	mp3? ( media-libs/libmad )
	musepack? ( >=media-libs/libmpcdec-1.2.2 )
	nas? ( media-libs/nas )
	nls? ( virtual/libintl )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )
	pulseaudio? ( media-sound/pulseaudio )
	quicktime? ( media-libs/libquicktime )
	samba? ( net-fs/samba )
	schroedinger? ( media-libs/schroedinger )
	sdl? ( media-libs/libsdl )
	speex? ( media-libs/speex )
	svga? ( media-libs/svgalib )
	theora? ( media-libs/libtheora )
	vidix? ( x11-libs/libXxf86vm
			 x11-libs/libXext )
	vorbis? ( media-libs/libvorbis )
	xscreensaver? ( x11-libs/libXScrnSaver )
	truetype? ( >=media-libs/freetype-2.1
				media-libs/fontconfig )
	xanim? ( media-video/xanim )
	xinerama? ( x11-libs/libXinerama
				x11-libs/libXxf86vm
				x11-libs/libXext )
	xvid? ( media-libs/xvid )
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
	>=sys-apps/portage-2.1.2
	doc? ( >=app-text/docbook-sgml-dtd-4.1.2
		   app-text/docbook-xml-dtd
		   >=app-text/docbook-xml-simple-dtd-1.50.0
		   dev-libs/libxslt )
	jack? ( >=media-libs/bio2jack-0.4 )
	nls? ( sys-devel/gettext )
	dga? ( x11-proto/xf86dgaproto )
	xinerama? ( x11-proto/xineramaproto )
	xscreensaver? ( x11-proto/scrnsaverproto )
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
	elif use real && use amd64 ; then
		REALLIBDIR="/usr/$(get_libdir)/codecs"
	fi

	if use srt && ! use truetype ; then
		echo
		ewarn "You enabled the 'srt' USE flag, but text subtitle support will be"
		ewarn "disabled unless you also use 'truetype'!"
		echo
	fi

	if use truetype && ! use unicode ; then
		echo
		ewarn "You enabled the 'truetype' USE flag, but support will be"
		ewarn "disabled unless you also use 'unicode'!"
		echo
	fi

	if use gtk ; then
		echo
		ewarn "The gtk useflag enables mplayer's gui (gmplayer), which is"
		ewarn "unmaintained upstream. You are encouraged to use a modern"
		ewarn "frontend, such as gnome-mplayer, kmplayer or smplayer instead."
		echo
	fi


	if [[ -n ${LINGUAS} ]]; then
		echo
		elog "For MPlayer's language support, the configuration will"
		elog "use your LINGUAS variable from /etc/make.conf.  If you have more"
		elog "than one language enabled, then the first one in the list will"
		elog "be used to output the messages, if a translation is available."
		elog "man pages will be created for all languages where translations"
		elog "are also available."
		echo
	fi

	if use x86 || use amd64; then
		if ! use mmx && use custom-cflags; then
		echo
		ewarn "You have the 'mmx' use flag disabled for this package, which"
		ewarn "means that no CPU optimizations will be used at all."
		ewarn "The build will either break or encode very slowly.  Check your"
		ewarn "/proc/cpuinfo for possible CPU optimization flags that"
		ewarn "apply to this ebuild (mmx, mmxext, 3dnow, 3dnowext, sse, sse2, ssse3)."
		echo
		fi
	fi
}

src_unpack() {

	subversion_src_unpack

	cd "${WORKDIR}"
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
	mv version.h "${S}"

	cd "${S}"

	epatch "${FILESDIR}"/disable-version-rebranding.patch
	use volume && epatch "${FILESDIR}"/startupvol.patch
	use icc && epatch "${FILESDIR}"/ffmpeg-icc.patch
	# Fix hppa compilation
	use hppa && sed -i -e "s/-O4/-O1/" "${S}/configure"

	if use svga
	then
		echo
		elog "Enabling vidix non-root mode."
		elog "(You need a proper svgalib_helper.o module for your kernel"
		elog " to actually use this)"
		echo
		mv "${WORKDIR}/svgalib_helper" "${S}/libdha"
	fi

	# Fix polish spelling errors
	[[ -n ${LINGUAS} ]] && sed -e 's:Zarządano:Zażądano:' -i help/help_mp-pl.h

	use darknrg && epatch ${FILESDIR}/darknrg.patch
}
IUSE="${IUSE} darknrg"

src_compile() {

	local myconf=" --disable-tv-bsdbt848"

	# broken upstream, won't work with recent kernels
	myconf="${myconf} --disable-ivtv"

	# MPlayer reads in the LINGUAS variable from make.conf, and sets
	# the languages accordingly.  Some will have to be altered to match
	# upstream's naming scheme.
	[[ -n $LINGUAS ]] && LINGUAS=${LINGUAS/da/dk}

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

	# libcdio support: prefer libcdio over cdparanoia
	# don't check for cddb w/cdio
	if use cdio; then
		myconf="${myconf} --disable-cdparanoia"
	else
		myconf="${myconf} --disable-libcdio"
		use cdparanoia || myconf="${myconf} --disable-cdparanoia"
		use cddb || myconf="${myconf} --disable-cddb"
	fi

	use srt  || myconf="${myconf} --disable-ass"
	use bidi || myconf="${myconf} --disable-fribidi"
	use bl   && myconf="${myconf} --enable-bl"
	use enca || myconf="${myconf} --disable-enca"
	use ftp  || myconf="${myconf} --disable-ftp"
	use nemesi || myconf="${myconf} --disable-nemesi"
	use nut  || myconf="${myconf} --disable-libnut"
	use tivo || myconf="${myconf} --disable-vstream"
	use xscreensaver || myconf="${myconf} --disable-xss"

	# DVD support
	# dvdread and libdvdcss are internal libs
	# http://www.mplayerhq.hu/DOCS/HTML/en/dvd.html
	# You can optionally use external dvdread support, but against
	# upstream's suggestion. Normally, we don't, but we're using
	# external dvdread for dvdnav.
	# For this overlay ebuild, we're compiling both libdvdnav
	# and this mplayer against external dvdread.
	if ! use dvd; then
		myconf="${myconf} --disable-dvdnav --disable-dvdread"
	fi
	if use dvd && use dvdnav; then
		myconf="${myconf} --disable-dvdread-internal \
			--with-dvdread-config=/usr/bin/dvdread-config \
			--with-dvdnav-config=/usr/bin/dvdnav-config"
	fi

	if use encode ; then
		myconf="${myconf} --enable-mencoder"
		use aac  || myconf="${myconf} --disable-faac"
		use dv   || myconf="${myconf} --disable-libdv"
		use mp2  || myconf="${myconf} --disable-twolame --disable-toolame"
		use mp3  || myconf="${myconf} --disable-mp3lame --disable-mp3lame-lavc"
		use x264 || myconf="${myconf} --disable-x264"
		use xvid || myconf="${myconf} --disable-xvid --disable-xvid-lavc"
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

	myconf="${myconf} $(use_enable joystick)"
	use lirc || myconf="${myconf} --disable-lirc --disable-lircc"
	use live || myconf="${myconf} --disable-live"
	myconf="${myconf} $(use_enable radio) $(use_enable radio radio-capture)"
	use ipv6 || myconf="${myconf} --disable-inet6"
	use rar || myconf="${myconf} --disable-unrarexec"
	use rtc || myconf="${myconf} --disable-rtc"
	use samba || myconf="${myconf} --disable-smb"
	myconf="${myconf} $(use_enable truetype freetype)"
	use truetype || myconf="${myconf} --disable-fontconfig"

	# DVB / Video4Linux / Radio support
	if { use dvb || use pvr || use v4l || use v4l2 || use radio; }; then
		use dvb || myconf="${myconf} --disable-dvb --disable-dvbhead"
		use v4l || myconf="${myconf} --disable-tv-v4l1"
		use v4l2 || myconf="${myconf} --disable-tv-v4l2"
		use teletext || myconf="${myconf} --disable-tv-teletext"
		if use radio && { use dvb || use v4l || use v4l2; }; then
			myconf="${myconf} --enable-radio $(use_enable encode radio-capture)"
		else
			myconf="${myconf} --disable-radio-v4l2 --disable-radio-bsdbt848"
		fi
	else
		myconf="${myconf} --disable-tv --disable-tv-v4l1 --disable-tv-v4l2 \
			--disable-radio --disable-radio-v4l2 --disable-radio-bsdbt848 \
			--disable-dvb --disable-dvbhead --disable-tv-teletext \
			--disable-pvr"
	fi

	##########
	# Codecs #
	##########
	for x in gif jpeg ladspa live musepack pnm speex theora xanim; do
		use ${x} || myconf="${myconf} --disable-${x}"
	done
	use aac || myconf="${myconf} --disable-faad-internal"
	use aac && use fpm && myconf="${myconf} --enable-faad-fixed"
	use a52 || myconf="${myconf} --disable-liba52"
	use dirac || myconf="${myconf} --disable-libdirac-lavc"
	use schroedinger || myconf="${myconf} --disable-libschroedinger-lavc"
	use dts || myconf="${myconf} --disable-libdca"
	! use png && ! use gtk && myconf="${myconf} --disable-png"
	use lzo || myconf="${myconf} --disable-liblzo"
	use mpeg || myconf="${myconf} --disable-libmpeg2"
	use mp3 || myconf="${myconf} --disable-mp3lib --disable-mad"
	use vorbis || myconf="${myconf} --disable-libvorbis"
	use xanim && myconf="${myconf} --xanimcodecsdir=/usr/lib/xanim/mods"
	if use x86 || use amd64; then
		# Real codec support, only available on x86, amd64
		if use real ; then
			myconf="${myconf} --enable-real --realcodecsdir=${REALLIBDIR}"
		else
			myconf="${myconf} --disable-real"
		fi
		if ! use livecd && ! use bindist ; then
			myconf="${myconf} $(use_enable win32codecs win32dll)"
			use amrnb || myconf="${myconf} --disable-libamr_nb"
			use amrwb || myconf="${myconf} --disable-libamr_wb"
		fi
	fi
	# bug 213836
	if ! use x86 || ! use win32codecs; then
		use quicktime || myconf="${myconf} --disable-qtx"
	fi


	################
	# Video Output #
	################
	use aalib || myconf="${myconf} --disable-aa"
	use dga || myconf="${myconf} --disable-dga1 --disable-dga2"
	use fbcon || myconf="${myconf} --disable-fbdev"
	use fbcon && use video_cards_s3virge && myconf="${myconf} --enable-s3fb"
	myconf="${myconf} $(use_enable directfb)"
	myconf="${myconf} $(use_enable ggi)"
	myconf="${myconf} $(use_enable libcaca caca)"
	myconf="${myconf} $(use_enable matrox mga)"
	myconf="${myconf} $(use_enable opengl gl)"
	myconf="${myconf} $(use_enable sdl)"
	use video_cards_vesa || myconf="${myconf} --disable-vesa"
	use vidix || myconf="${myconf} --disable-vidix --disable-vidix-pcidb"
	use zoran || myconf="${myconf} --disable-zr"

	if use xv; then
		if use xvmc; then
			myconf="${myconf} --enable-xvmc --with-xvmclib=XvMCW"
		else
			myconf="${myconf} --disable-xvmc"
		fi
	else
		myconf="${myconf} --disable-xv --disable-xvmc"
	fi

	if ! use kernel_linux && ! use video_cards_mga; then
		myconf="${myconf} --disable-mga --disable-xmga"
	fi

	if use video_cards_tdfx; then
		myconf="${myconf} $(use_enable video_cards_tdfx tdfxvid) \
			$(use_enable fbcon tdfxfb)"
	else
		myconf="${myconf} --disable-3dfx --disable-tdfxvid --disable-tdfxfb"
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
	if use x86 || use amd64 || use ppc; then
		if use cpudetection || use bindist; then
			myconf="${myconf} --enable-runtime-cpudetection"
		fi
	fi
	# Letting users turn off optimizations results in epic build fail
	# across the board.  MPlayer's build system by default will
	# detect them and use them just fine, so don't let them change
	# them unless they really know what they are doing anyway.
	if use custom-cflags; then
		if use mmx; then
			for x in 3dnow 3dnowext mmxext sse sse2 ssse3; do
				use ${x} || myconf="${myconf} --disable-${x}"
			done
		else
			myconf="${myconf} --disable-mmx --disable-mmxext --disable-sse \
			--disable-sse2 --disable-ssse3 --disable-3dnow \
			--disable-3dnowext"
		fi
	fi

	use debug && myconf="${myconf} --enable-debug=3"
	myconf="${myconf} $(use_enable altivec)"

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

	myconf="--cc=$(tc-getCC) \
		--host-cc=$(tc-getBUILD_CC) \
		--prefix=/usr \
		--confdir=/etc/mplayer \
		--datadir=/usr/share/mplayer \
		--libdir=/usr/$(get_libdir) \
		--enable-menu \
		--enable-network \
		${myconf}"
	CFLAGS="${CFLAGS}" ./configure ${myconf} || die "configure died"

	emake || die "Failed to build MPlayer!"
	use doc && make -C DOCS/xml html-chunked
}

src_install() {
	make prefix=${D}/usr \
		 BINDIR=${D}/usr/bin \
		 LIBDIR=${D}/usr/$(get_libdir) \
		 CONFDIR=${D}/usr/share/mplayer \
		 DATADIR=${D}/usr/share/mplayer \
		 MANDIR=${D}/usr/share/man \
		 install || die "Failed to install MPlayer!"

	dodoc AUTHORS Changelog README etc/codecs.conf
	# Install the documentation; DOCS is all mixed up not just html
	if use doc ; then
		find "${S}/DOCS" -type d | xargs -- chmod 0755
		find "${S}/DOCS" -type f | xargs -- chmod 0644
		cp -r "${S}/DOCS" "${D}/usr/share/doc/${PF}/" || die "cp docs died"
	fi

	# Copy misc tools to documentation path, as they're not installed directly
	# and yes, we are nuking the +x bit.
	find "${S}/TOOLS" -type d | xargs -- chmod 0755
	find "${S}/TOOLS" -type f | xargs -- chmod 0644
	cp -r "${S}/TOOLS" "${D}/usr/share/doc/${PF}/" || die "cp tools died"

	# Install the default Skin and Gnome menu entry
	if use gtk; then
		dodir /usr/share/mplayer/skins
		cp -r "${WORKDIR}/productive" "${D}"/usr/share/mplayer/skins/default || die "cp skin died"

		# Fix the symlink
		rm -rf "${D}"/usr/bin/gmplayer
		dosym mplayer /usr/bin/gmplayer

		insinto /usr/share/pixmaps
		newins "${S}"/gui/mplayer/pixmaps/logo.xpm mplayer.xpm
		insinto /usr/share/applications
		doins "${FILESDIR}/mplayer.desktop"
	fi

	if ! use truetype || ! use unicode; then
		dodir /usr/share/mplayer/fonts
		local x=
		# Do this generic, as the mplayer people like to change the structure
		# of their zips ...
		for x in $(find ${WORKDIR}/ -type d -name 'font-arial-*')
		do
			cp -pPR ${x} "${D}"/usr/share/mplayer/fonts
		done
		# Fix the font symlink ...
		rm -rf "${D}"/usr/share/mplayer/font
		dosym fonts/font-arial-14-iso-8859-1 /usr/share/mplayer/font
	fi

	insinto /etc/mplayer
	newins "${S}"/etc/example.conf mplayer.conf
	dosed -e 's/fs=yes/fs=no/' /etc/mplayer.conf
	if use truetype && use unicode ; then
		cat >> "${D}"/etc/mplayer/mplayer.conf << EOT
fontconfig=1
subfont-osd-scale=4
subfont-text-scale=3
EOT
	fi
	dosym ../../../etc/mplayer/mplayer.conf /usr/share/mplayer/mplayer.conf

	# copy the midentify script to /usr/bin
	cp "${D}"/usr/share/doc/${PF}/TOOLS/midentify.sh "${D}"/usr/bin/midentify
	chmod a+x "${D}"/usr/bin/midentify

	insinto /usr/share/mplayer
	doins "${S}"/etc/input.conf
	doins "${S}"/etc/menu.conf

	# add codec configuration for eac3
	use eac3 && cat "${FILESDIR}/eac3-id.conf" >> "${D}"/usr/share/mplayer/codecs.conf
}

pkg_preinst() {

	if [ -d "${ROOT}/usr/share/mplayer/Skin/default" ]
	then
		rm -rf "${ROOT}"/usr/share/mplayer/Skin/default
	fi
}

pkg_postrm() {

	# Cleanup stale symlinks
	if [ -L "${ROOT}"/usr/share/mplayer/font -a \
	     ! -e "${ROOT}"/usr/share/mplayer/font ]
	then
		rm -f "${ROOT}"/usr/share/mplayer/font
	fi

	if [ -L "${ROOT}"/usr/share/mplayer/subfont.ttf -a \
	     ! -e "${ROOT}"/usr/share/mplayer/subfont.ttf ]
	then
		rm -f "${ROOT}"/usr/share/mplayer/subfont.ttf
	fi
}
