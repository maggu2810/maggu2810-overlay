inherit eutils

DESCRIPTION="Eclipse Tools Platform"
HOMEPAGE="http://www.eclipse.org/"

SLOT="3.4"
LICENSE="EPL-1.0"
IUSE=""
KEYWORDS=""
RESTRICT="strip mirror"

SRC_URI="http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops/M20080724-0918/eclipse-SDK-M20080724-0918-linux-gtk-x86_64.tar.gz"

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

src_install() {
	dodir "${INSTALLDIR}"
	cp -dpr eclipse/* "${D}/${INSTALLDIR}" || die "No eclipse/ dir in archive?"

	mem=`grep MemTotal: /proc/meminfo`
	[[ "$mem" =~ ([0-9]*)\ kB$ ]]
	mem=$[ 10#${BASH_REMATCH[1]} / 1024 ]
	dodir "/etc/env.d"
	echo "ECLIPSE_XMX="$[ $mem * 8 / 10 ]"M" >> "${D}/etc/env.d/99eclipse"
	echo "ECLIPSE_MAX_PERMSIZE="$[ $mem * 2 / 10 ]"M" >> "${D}/etc/env.d/99eclipse"
	einfo "Your system has $mem MB RAM; setting max memory for eclipse to\n`cat "${D}/etc/env.d/99eclipse"`"

	dobin "${FILESDIR}"/eclipse-${SLOT}
}
