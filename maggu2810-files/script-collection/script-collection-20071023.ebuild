# maggu2810

DESCRIPTION="A collection of scripts for MY daily routine"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

src_install() {
        insopts -m0755 -o root -g root
        insinto /usr/sbin
        doins "${FILESDIR}/maggu2810_automount"
}
