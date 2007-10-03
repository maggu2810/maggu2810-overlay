# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils flag-o-matic subversion autotools

DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
ESVN_REPO_URI="svn://svn.berlios.de/avidemux/branches/avidemux_2.4_branch"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="a52 aac aften alsa altivec amrnb arts debug dts esd extrafilters
	fontconfig gtk mp2 mp3 nls oss qt4 sdl truetype vorbis X x264 xv xvid"

RDEPEND=">=dev-libs/libxml2-2.6.7
	>=dev-lang/spidermonkey-1.5-r2
	a52? ( >=media-libs/a52dec-0.7.4 )
	aac? ( >=media-libs/faac-1.23.5
	       >=media-libs/faad2-2.0-r7 )
	aften? ( media-libs/aften )
	alsa? ( >=media-libs/alsa-lib-1.0.9 )
	amrnb? ( media-libs/amrnb )
	arts? ( >=kde-base/arts-1.2.3 )
	dts? ( media-libs/libdts )
	esd? ( media-sound/esound )
	fontconfig? ( media-libs/fontconfig )
	mp2? ( >=media-sound/twolame-0.3.6 )
	mp3? ( media-libs/libmad
	       >=media-sound/lame-3.93 )
	nls? ( >=sys-devel/gettext-0.12.1 )
	sdl? ( media-libs/libsdl )
	truetype? ( >=media-libs/freetype-2.1.5 )
	vorbis? ( >=media-libs/libvorbis-1.0.1 )
	x264? ( >=media-libs/x264-svn-20061014 )
	xvid? ( >=media-libs/xvid-1.0.0 )
	X? (
		gtk? ( >=x11-libs/gtk+-2.6 )
		qt4? ( >=x11-libs/qt-4.0 )
		xv? ( x11-libs/libXv )
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrender
		)
	"

DEPEND="$RDEPEND
	dev-util/cmake
	X? (
		x11-base/xorg-server
		x11-libs/libXt
		x11-proto/xextproto
		)
	dev-util/pkgconfig"

pkg_setup() {
	if ! ( built_with_use dev-lang/spidermonkey threadsafe ) ; then
		eerror "dev-lang/spidermonkey is missing threadsafe support, please"
		eerror "make sure you enable the threadsafe USE flag and re-emerge"
		eerror "dev-lang/spidermonkey - this Avidemux subversion build"
		eerror "will not compile nor work without it!"
		die "dev-lang/spidermonkey needs threadsafe support"
	fi

	if ! ( use oss || use arts || use alsa ) ; then
		eerror "You must select at least one from alsa, arts and oss audio output."
		die "Fix USE flags"
	fi

	if ( !( use X ) && ( use gtk || use qt4 ) ) ; then
		eerror "If you use gtk and/or qt4, you should also set X."
		die "Fix USE flags"
	fi
}

src_unpack() {
	subversion_src_unpack
	cd ${S}
	# svn info needs original working copy
	sed -i -e "s:\${PROJECT_SOURCE_DIR}:${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}:" cmake/FindSubversion.cmake
	sed -i -e "s:\${dir}:${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}:" cmake/FindSubversion.cmake

	epatch ${FILESDIR}/define-fpm.patch
	epatch ${FILESDIR}/define-MM.patch

}

src_compile() {
	# let's autodetect for now...
	cmake . || die "cmake failed"
	emake -j1 || die "emake failed"

	if ( use extrafilters ); then
		cd ${WORKDIR}/${P}/avidemux/ADM_filter
		sh buildummy.sh
	fi
}

src_install() {
	dobin avidemux/avidemux2_cli || die "CLI could not be installed"
	if use gtk; then
		dobin avidemux/avidemux2_gtk || die "GTK GUI could not be installed"
		make_desktop_entry avidemux2_gtk "Avidemux2 GTK" avidemux.png
	fi
	if use qt4; then
		dobin avidemux/avidemux2_qt4 || die "QT4 GUI could not be installed"
		make_desktop_entry avidemux2_qt4 "Avidemux2 QT4" avidemux.png
	fi
	if use extrafilters; then
		dodir /usr/share/avidemux/
		dodir /usr/share/avidemux/filters
		exeinto /usr/share/avidemux/filters
		doexe ${WORKDIR}/avidemux-24000/avidemux/ADM_filter/dummy.so
		fi
	dodoc AUTHORS
	insinto /usr/share/pixmaps
	newins ${S}/avidemux_icon.png avidemux.png
}

pkg_postinst() {
	if ( use extrafilters ); then
		echo
		einfo "If you want to activate external filters"
		einfo "open ~/.avidemux/config file and"
		einfo "set filter autoload active to 1"
		einfo "set filter autoload path to /usr/share/avidemux/filters"
		einfo "You can also set the path in the GUI in the"
		einfo "Edit > Preferences > External Filters dialog"
		einfo "Note that there are no usable external Avidemux filters yet,"
		einfo "so you may find this option useless."
	fi
	if use ppc && use oss; then
		echo
		einfo "OSS sound output may not work on ppc"
		einfo "If your hear only static noise, try"
		einfo "changing the sound device to ALSA or arts"
	fi
	echo
	einfo "Big Fat Warning: This is a live SVN ebuild."
	einfo "Use at your own risk."
	echo
}
