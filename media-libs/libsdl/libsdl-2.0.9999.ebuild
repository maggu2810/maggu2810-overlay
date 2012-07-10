# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit flag-o-matic multilib toolchain-funcs libtool autotools eutils mercurial
EHG_REPO_URI="http://hg.libsdl.org/SDL"

DESCRIPTION="Simple Direct Media Layer"

HOMEPAGE="http://www.libsdl.org/"

LICENSE="ZLIB"

SLOT="2.0"

KEYWORDS=""

# WARNING:
# If you turn on the custom-cflags use flag in USE and something breaks,
# you pick up the pieces.  Be prepared for bug reports to be marked INVALID.
IUSE="+audio +video +joystick
	  oss alsa pulseaudio nas
	  X xinerama xrandr xscreensaver cocoa directfb opengl opengles
	  tslib
	  sse sse2 mmx 3dnow altivec
	  custom-cflags static-libs"

REQUIRED_USE="xinerama? ( X )
			  xrandr? ( X )
			  xscreensaver? ( X )"

#
# TODO
#
RDEPEND="audio? ( >=media-libs/audiofile-0.1.9 )
		 alsa? ( media-libs/alsa-lib )
		 pulseaudio? ( media-sound/pulseaudio )
		 nas? (
				 media-libs/nas
				 x11-libs/libXt
				 x11-libs/libXext
				 x11-libs/libX11
			  )
		 X? (
				 x11-libs/libXt
				 x11-libs/libXext
				 x11-libs/libX11
			)
		 xrandr? ( x11-libs/libXrandr )
		 directfb? ( >=dev-libs/DirectFB-0.9.19 )
		 opengl? ( virtual/opengl virtual/glu )
		 tslib? ( x11-libs/tslib )"

#
# TODO
#
DEPEND="${RDEPEND}
		nas? (
				x11-proto/xextproto
				x11-proto/xproto
			 )
		X? (
				x11-proto/xextproto
				x11-proto/xproto
		   )
		x86? ( || ( >=dev-lang/yasm-0.6.0 >=dev-lang/nasm-0.98.39-r3 ) )"

ECONF_SOURCE="${S}"
BUILDDIR="${S}-build"

pkg_setup() {
	if use custom-cflags ; then
		ewarn "Since you've chosen to use possibly unsafe CFLAGS,"
		ewarn "don't bother filing libsdl-related bugs until trying to remerge"
		ewarn "libsdl without the custom-cflags use flag in USE."
		epause 10
	fi
}

#src_prepare() {
#	eautoreconf
#	elibtoolize
#}

src_configure() {
	mkdir -p "${BUILDDIR}"
	cd "${BUILDDIR}"

	local myconf=
	if [[ $(tc-arch) != "x86" ]] ; then
		myconf="${myconf} --disable-nasm"
	else
		myconf="${myconf} --enable-nasm"
	fi
	use custom-cflags || strip-flags
#use video \
#		&& myconf="--enable-video --enable-video-dummy"
#		|| myconf="--disable-video --disable-video-dummy"

	local directfbconf="--disable-video-directfb"
	if use directfb ; then
		# since DirectFB can link against SDL and trigger a
		# dependency loop, only link against DirectFB if it
		# isn't broken #61592
		echo 'int main(){}' > directfb-test.c
		$(tc-getCC) directfb-test.c -ldirectfb 2>/dev/null \
			&& directfbconf="--enable-video-directfb" \
			|| ewarn "Disabling DirectFB since libdirectfb.so is broken"
	fi

	myconf="${myconf} ${directfbconf}"

	#
	# - enable support for all subsystems
	# - disable dynamically loading support stuff
	# - ...


	econf \
		$(use_enable audio) \
		$(use_enable video) \
		--enable-render \
		--enable-events \
		$(use_enable joystick) \
		$(use_enable joystick haptic) \
		--enable-power \
		--enable-threads \
		--enable-timers \
		--enable-file \
		--enable-loadso \
		--enable-cpuinfo \
		\
		--disable-alsa-shared \
		--disable-esd-shared \
		--disable-pulseaudio-shared \
		--disable-arts-shared \
		--disable-nas-shared \
		--disable-x11-shared \
		--disable-directfb-shared \
		--disable-fusionsound-shared \
		\
		--disable-esd \
		--disable-arts \
		--disable-diskaudio \
		--disable-fusionsound \
		$(use_enable audio dummy-audio) \
		$(use_enable oss) \
		$(use_enable alsa) \
		$(use_enable pulseaudio) \
		$(use_enable nas) \
		\
		$(use_enable video video-dummy) \
		$(use_enable X video-x11) \
		$(use_enable X video-x11-xcursor) \
		$(use_enable X video-x11-xinput) \
		$(use_enable X video-x11-xshape) \
		$(use_with X x) \
		$(use_enable xinerama video-x11-xinerama) \
		$(use_enable xrandr video-x11-xrandr) \
		$(use_enable xscreensaver video-x11-scrnsaver) \
		--disable-video-x11-vm \
		$(use_enable cocoa video-cocoa) \
		$(use_enable opengl video-opengl) \
		$(use_enable opengles video-opengles) \
		--disable-directx \
		--disable-render-d3d \
		\
		$(use_enable tslib input-tslib) \
		\
		--enable-atomic \
		--enable-assembly \
		--disable-ssemath \
		$(use_enable sse) \
		$(use_enable sse2) \
		$(use_enable mmx) \
		$(use_enable 3dnow) \
		$(use_enable altivec) \
		\
		--disable-rpath \
		\
		$(use_enable static-libs static) \
		${myconf}
}

src_compile() {
	cd "${BUILDDIR}"

	emake || die
}

src_install() {
	cd "${BUILDDIR}"

	emake DESTDIR="${D}" install || die
}
