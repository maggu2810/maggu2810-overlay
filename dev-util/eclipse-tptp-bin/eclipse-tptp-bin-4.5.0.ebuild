inherit eutils

DESCRIPTION="Eclipse Test & Performance Tools Platform Project"
HOMEPAGE="http://www.eclipse.org/tptp/"

SLOT="4.5"
ESLOT="3.4"
LICENSE="EPL-1.0"
IUSE=""
KEYWORDS="~amd64"
RESTRICT="strip mirror"

BASE1="http://eclipsemirror.yoxos.com/eclipse.org/"
BASE2="${BASE1}tptp/${PV}/TPTP-${PV}/"
BASE3="${BASE1}modeling/emf/emf/downloads/drops/"
SRC_URI="${BASE2}tptp.runtime-TPTP-${PV}.zip ${BASE3}2.4.0/R200806091234/emf-runtime-2.4.0.zip
	${BASE3}2.4.0/R200806091234/xsd-runtime-2.4.0.zip ${BASE3}2.2.4/R200710030400/emf-sdo-xsd-SDK-2.2.4.zip"
CDEPEND="|| ( =dev-util/eclipse-sdk-${ESLOT}* =dev-util/eclipse-sdk-bin-${ESLOT}* )
	=dev-util/eclipse-agntctrl-bin-${PV} =dev-util/eclipse-cbe-bin-${PV}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

INSTALLDIR="/usr/lib/eclipse-${ESLOT}"

src_install() {
	dodir "${INSTALLDIR}"
	cp -dpr eclipse/* "${D}"/"${INSTALLDIR}"
}
