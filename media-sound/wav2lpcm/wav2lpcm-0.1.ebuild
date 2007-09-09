inherit eutils

IUSE=""

DESCRIPTION="Convert a WAV file to LPCM suitable for multiplexing into a DVD-Video"
HOMEPAGE="http://dvd-audio.sourceforge.net"
SRC_URI="http://dvd-audio.sourceforge.net/wav2lpcm.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
S="${WORKDIR}/wav2lpcm"

DEPEND=""

src_compile() {
	cd ${S}
	emake CFLAGS="$CFLAGS" || die "emake failed"
}

src_install() {
	dobin wav2lpcm
}
