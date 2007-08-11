DESCRIPTION="
	Dictconv is a program to convert a dictionary from one format to another.
	The program supports conversion from Babylon glossaries (.bgl) to stardict."
HOMEPAGE="http://freshmeat.net/projects/dictconv/"
SRC_URI="http://downloads.sourceforge.net/ktranslator/${P}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND_COMMON=">=dev-libs/libxml2-2.5.0"

RDEPEND="${DEPEND_COMMON}
	"

DEPEND="${DEPEND_COMMON}
	"

src_compile() {
	econf || die "econf failed"
	emake || die "compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog AUTHORS README
}
