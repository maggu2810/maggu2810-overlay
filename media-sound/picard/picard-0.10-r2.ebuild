# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/picard/picard-0.10-r1.ebuild,v 1.1 2008/11/07 11:30:27 coldwind Exp $

inherit eutils distutils

MY_P="${P/_/}"
DESCRIPTION="An improved rewrite/port of the Picard Tagger using Qt"
HOMEPAGE="http://musicbrainz.org/doc/PicardQt"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/picard/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdaudio ffmpeg nls"

RDEPEND=">=dev-lang/python-2.4
	|| ( >=dev-lang/python-2.5 >=dev-python/ctypes-0.9 )
	>=dev-python/PyQt4-4.2
	media-libs/mutagen
	cdaudio? ( >=media-libs/libdiscid-0.1.1 )
	ffmpeg? ( media-video/ffmpeg
		>=media-libs/libofa-0.9.2 )"

DEPEND="${RDEPEND}"

DOCS="AUTHORS.txt INSTALL.txt NEWS.txt"
S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! use ffmpeg; then
		ewarn "The 'ffmpeg' USE flag is disabled. Acoustic fingerprinting and"
		ewarn "recognition will not be available."
	fi
	if ! use cdaudio; then
		ewarn "The 'cdaudio' USE flag is disabled. CD index lookup and"
		ewarn "identification will not be available. You can get audio CD support"
		ewarn "by installing media-libs/libdiscid."
	fi

	if ! built_with_use --missing true dev-lang/python cxx ; then
		eerror "Please, rebuild dev-lang/python with USE=\"cxx\"."
		die "dev-lang/python built without cxx support"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	if has_version '>=media-video/ffmpeg-0.4.9_p20080326' ; then
		epatch "${FILESDIR}"/${PN}-0.10.0_rc1-ffmpeg-headers.patch
	fi
	if has_version '>=media-video/ffmpeg-0.4.9_p20081014' ; then
		epatch "${FILESDIR}"/${PN}-0.10.0_ffmpeg_decode_audio2_support.patch
	fi
}

src_compile() {
	${python} setup.py config || die "setup.py config failed"
	if ! use ffmpeg; then
		sed -i -e "s:\(^with-avcodec\ =\ \).*:\1False:" \
			-e "s:\(^with-libofa\ =\ \).*:\1False:" \
			build.cfg || die "sed failed"
	fi
	${python} setup.py build $(use nls || echo "--disable-locales") \
		|| die "setup.py build failed"
}

src_install() {
	distutils_src_install --disable-autoupdate --skip-build \
		$(use nls || echo "--disable-locales")

	doicon picard-{16,32}.png
	domenu picard.desktop
}

pkg_postinst() {
	distutils_pkg_postinst
	echo
	elog "You should set the environment variable BROWSER to something like"
	elog "\"firefox '%s' &\" to let python know which browser to use."
}
