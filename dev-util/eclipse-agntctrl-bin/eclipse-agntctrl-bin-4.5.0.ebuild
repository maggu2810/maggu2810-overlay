inherit eutils

DESCRIPTION="Eclipse Test & Performance Tools Platform Agent Controller"
HOMEPAGE="http://www.eclipse.org/"

SLOT="4.5"
ESLOT="3.4"
LICENSE="EPL-1.0"
IUSE=""
KEYWORDS="~amd64"
RESTRICT="strip mirror"

BASE="http://eclipsemirror.yoxos.com/eclipse.org/tptp/${PV}/TPTP-${PV}/"
SRC_URI="${BASE}agntctrl.linux_em64t-TPTP-${PV}.zip"
CDEPEND="|| ( =dev-util/eclipse-sdk-${ESLOT}* =dev-util/eclipse-sdk-bin-${ESLOT}* ) 
	sys-libs/libstdc++-v3"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

INSTALLDIR="/usr/lib/eclipse-ac-${SLOT}"

src_install() {
	dodir "${INSTALLDIR}"
	cp -dpr * "${D}"/"${INSTALLDIR}"

	dodir "/etc/env.d"
	echo "PATH=\"${INSTALLDIR}/bin\"" >> "${D}/etc/env.d/99eclipse-agntctrl"
	echo "LDPATH=\"${INSTALLDIR}/lib\"" >> "${D}/etc/env.d/99eclipse-agntctrl"

	libdir="${D}/${INSTALLDIR}/lib"
	rm $libdir/libxerces-c.so
	rm $libdir/libxerces-c.so.26
	ln -s libxerces-c.so.26.0 $libdir/libxerces-c.so
	ln -s libxerces-c.so.26.0 $libdir/libxerces-c.so.26

	# create executable
	echo "#!/bin/bash" >> "ACStart"
	echo "cd ${INSTALLDIR}/bin" >> "ACStart"
	echo "./ACStart.sh" >> "ACStart"
	echo "#!/bin/bash" >> "ACStop"
	echo "cd ${INSTALLDIR}/bin" >> "ACStop"
	echo "./ACStop.sh" >> "ACStop"
	dobin ACStart ACStop

	ewarn "Use emerge --config ${PN} to configure TPTP Agent Controller before using it !!!"
}

pkg_config() {
	cd "${INSTALLDIR}"/bin
	./SetConfig.sh
}
