inherit eutils

DESCRIPTION="Tool to transform PC multimedia file(s) in any format, into a DVD complete with menus & suitable for playback on a standalone DVD player"
HOMEPAGE="http://any2dvd.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

IUSE="dv matroska mpegts mythtv ogg pcm"

DEPEND=">=app-arch/sharutils-4.2.1
	>=net-misc/wget-1.9.1
	media-fonts/gnu-gs-fonts-std
	media-fonts/gnu-gs-fonts-other
	>=media-video/ffmpeg-0.4.9
	>=media-gfx/imagemagick-6.2.5.5
	>=media-video/dvdauthor-0.6.11
	>=app-cdr/dvd+rw-tools-6.1
	>=media-video/transcode-1.0.2
	>=media-video/mplayer-1.0_pre8
	>=media-video/mpgtx-1.3.1
	>=media-video/mjpegtools-1.6.2
	>=media-libs/a52dec-0.7.4
	>=media-libs/libdts-0.0.2
	>=media-libs/libsndfile-1.0.11
	>=media-sound/ecasound-2.4.1
	>=media-sound/multimux-0.2.3
	>=media-libs/libsoundtouch-1.3.0
	dv? ( >=media-libs/libdv-1.0.0 )
	matroska? ( >=media-video/mkvtoolnix-1.4.2 )
	mpegts? ( >=media-video/replex-0.1.4 )
	mythtv? ( >=media-tv/mythtv-0.18.1 )
	ogg? ( >=media-sound/ogmtools-1.5 )
	pcm? ( >=media-sound/wav2lpcm-0.1 )"

RDEPEND="${DEPEND}"

pkg_setup() {
	if use dv; then
		if ! built_with_use media-video/transcode dv; then
			eerror "Transcode is missing 'dv' support. Please add"
			eerror "'dv' to your USE flags, and re-emerge media-video/transcode"
			die "Transcode needs dv support"
		fi

		if ! built_with_use media-video/mjpegtools dv; then
			eerror "Mjpegtools is missing 'dv' support. Please add"
			eerror "'dv' to your USE flags, and re-emerge media-video/mjpegtools"
			die "Mjpegtools needs dv support"
		fi
	fi

	## FFmpeg dependencies ##
	if ! built_with_use media-video/ffmpeg {a52,aac,dts,encode}; then
		eerror "FFmpeg is missing 'a52,aac,dts and encode' support. Please add"
		eerror "'a52,aac,dts and encode' to your USE flags, and re-emerge media-video/ffmpeg"
		die "FFmpeg needs 'a52,aac,dts and encode' support"
	fi

	## Transcode dependencies ##
	if ! built_with_use media-video/transcode {a52,mjpeg,mp3,mpeg,xvid}; then
		eerror "Transcode is missing 'a52,mjpeg,mp3,mpeg and xvid' support. Please add"
		eerror "'a52,mjpeg,mp3,mpeg and xvid' to your USE flags, and re-emerge media-video/transcode"
		die "Transcode needs 'a52,mjpeg,mp3,mpeg and xvid' support"
	fi

	## Imagemagick dependencies ##
	if ! built_with_use media-gfx/imagemagick {jpeg,png}; then
		eerror "Imagemagick is missing 'jpeg and png' support. Please add"
		eerror "'jpeg and png' to your USE flags, and re-emerge media-gfx/imagemagick"
		die "Imagemagick needs 'jpeg and png' support"
	fi

	## MPlayer dependencies ##
	if ! built_with_use media-video/mplayer {aac,dts,dv,encode,jpeg,mad,png,real,vorbis,win32codecs,x264}; then
		eerror "Mplayer is missing 'aac,dts,dv,encode,jpeg,mad,png,real,vorbis,win32codecs and x264' support. Please add"
		eerror "'aac,dts,dv,encode,jpeg,mad,png,real,vorbis,win32codecs and x264' to your USE flags, and re-emerge media-video/mplayer"
		die "Mplayer needs 'aac,dts,dv,encode,jpeg,mad,png,real,vorbis,win32codecs and x264' support"
	fi

	if ! built_with_use media-video/mjpegtools png; then
		eerror "Mjpegtools is missing 'png' support. Please add"
		eerror "'png' to your USE flags, and re-emerge media-video/mjpegtools"
		die "Mjpegtools needs png support"
	fi
}

src_install() {
	dobin any2vob any2dvd
	doman any2vob.1 any2dvd.1
	dodoc Changelog-any2dvd Changelog-any2vob DISCLAIMER INSTALL LICENSE TODO
}
