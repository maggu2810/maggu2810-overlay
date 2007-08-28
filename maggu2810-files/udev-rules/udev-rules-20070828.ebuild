# maggu2810

DESCRIPTION="A custom asound.conf file for upmix, low-pass filter, etc."

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

RDEPEND="media-plugins/blop
	 media-libs/ladspa-cmt"

src_install() {
        insopts -m0640 -o root -g audio
        insinto /etc/udev/rules.d
        doins "${FILESDIR}/10-my-udev.rules"
}
