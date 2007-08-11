inherit eutils
# used for epause

DESCRIPTION="
	Dictconv is a program to convert a dictionary from one format to another.
	The program supports conversion from Babylon glossaries (.bgl) to stardict."
HOMEPAGE="http://freshmeat.net/projects/dictconv/"
SRC_URI="http://freshmeat.net/redir/dictconv/68455/url_bz2/${P}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND_COMMON=""

RDEPEND="${DEPEND_COMMON}
	"

DEPEND="
	${DEPEND_COMMON}
	"

src_compile() {
	econf || die "econf failed"
	emake || die "compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog AUTHORS README
}
