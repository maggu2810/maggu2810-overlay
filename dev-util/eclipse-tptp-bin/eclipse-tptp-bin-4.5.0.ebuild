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
#SRC_URI="${BASE2}tptp.runtime-TPTP-${PV}.zip ${BASE3}2.4.0/R200806091234/emf-runtime-2.4.0.zip
#	${BASE3}2.4.0/R200806091234/xsd-runtime-2.4.0.zip ${BASE3}2.2.4/R200710030400/emf-sdo-xsd-SDK-2.2.4.zip"
SRC_URI="${BASE2}tptp.runtime-TPTP-${PV}.zip ${BASE3}2.2.4/R200710030400/emf-sdo-xsd-SDK-2.2.4.zip"
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
	cd "${D}"/"${INSTALLDIR}"

	# remove files which are already contained in eclipse-sdk
	rm -f epl-v10.html notice.html
	cd plugins
	rm -f javax.xml_1.3.4.v200806030440.jar \
		org.apache.commons.logging_1.0.4.v20080605-1930.jar \
		org.apache.log4j_1.2.13.v200806030600.jar \
		org.apache.xerces_2.9.0.v200805270400.jar \
		org.apache.xml.resolver_1.2.0.v200806030312.jar \
		org.apache.xml.serializer_2.7.1.v200806030322.jar
}
