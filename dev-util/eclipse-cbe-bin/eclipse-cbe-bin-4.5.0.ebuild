inherit eutils

DESCRIPTION="Eclipse Test & Performance Tools CBE Native Logging"
HOMEPAGE="http://www.eclipse.org/tptp/"

SLOT="4.5"
ESLOT="3.4"
LICENSE="EPL-1.0"
IUSE=""
KEYWORDS="~amd64"
RESTRICT="strip mirror"

BASE="http://eclipsemirror.yoxos.com/eclipse.org/tptp/${PV}/TPTP-${PV}/"
SRC_URI="${BASE}cbe.linux_em64t-TPTP-${PV}.zip"
CDEPEND="|| ( =dev-util/eclipse-sdk-${ESLOT}* =dev-util/eclipse-sdk-bin-${ESLOT}* )"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

INSTALLDIR="/usr/lib/eclipse-cbe-${SLOT}"

src_install() {
	dodir "${INSTALLDIR}"
	cp -dpr * "${D}"/"${INSTALLDIR}"
}
