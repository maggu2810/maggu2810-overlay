inherit eutils

DESCRIPTION="Eclipse Tools Platform"
HOMEPAGE="http://www.eclipse.org/"

SLOT="3.4"
LICENSE="EPL-1.0"
IUSE=""
KEYWORDS="~amd64"
RESTRICT="strip mirror"

VERDATE="200806091311"
RL="RC4"
SRC_URI="http://mirror.yoxos-eclipse-distribution.de/eclipse.org/eclipse/downloads/drops/S-${PV}${RL}-${VERDATE}/eclipse-SDK-${PV}${RL}-linux-gtk-x86_64.tar.gz"

CDEPEND=">=dev-java/ant-eclipse-ecj-3.3
	dev-java/ant-core
	dev-java/ant-nodeps
	=dev-java/junit-3*
	dev-java/junit:4
	<dev-java/swt-3.4_alpha:3
	>=dev-java/jsch-0.1.36-r1
	>=dev-java/icu4j-3.6.1
	>=dev-java/commons-el-1.0-r2
	>=dev-java/commons-logging-1.1-r6
	>=dev-java/tomcat-servlet-api-5.5.25-r1:2.4
	dev-java/lucene:1.9"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	sys-apps/findutils
	dev-java/cldc-api:1.1
	app-arch/unzip
	app-arch/zip
	${CDEPEND}"

INSTALLDIR="/usr/lib/eclipse-${SLOT}"

S="${WORKDIR}"

src_install() {
	dodir "${INSTALLDIR}"
	cp -dpr eclipse/* "${D}"/"${INSTALLDIR}"

	dobin "${FILESDIR}"/eclipse-${SLOT}
}
