inherit kde

DESCRIPTION="yaBi (Yet Another Beagle search Interface) is a python-kde-beagle
	search interface to find information from beagle."

HOMEPAGE="http://kde-apps.org/content/show.php?content=33222"
SRC_URI="http://kde-apps.org/CONTENT/content-files/33222-${P}.tar.gz"

LICENSE="X11"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-misc/beagle-0.2.0
	>=dev-libs/libbeagle-0.3.0
	>=dev-python/pykde-3.16.0"
DEPEND="${RDEPEND}"

need-kde 3.5

src_compile() {
	:
	sed -i "s:fullpathname = .*:fullpathname = \"/usr/share/${PN}\":" ${PN}.py
}

src_install() {
	dodoc AUTHORS Changelog README TODO

	docinto ${DOCDESTTREE}/scripts
	dodoc scripts/*

	insinto /usr/share/${PN}
	doins -r data/ pixmap/
	exeinto ${INSDESTTREE}
	doexe *.py

	dosym ${INSDESTTREE}/${PN}.py /usr/bin/${PN}
}
