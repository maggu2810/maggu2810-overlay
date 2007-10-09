# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Azureus - Java BitTorrent Client"
HOMEPAGE="http://azureus.sourceforge.net"
SRC_URI="mirror://sourceforge/azureus/Azureus_${PV}_linux.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND=">=virtual/jre-1.6.0"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5"

S=${WORKDIR}/${PN}

src_install() {
	insinto /usr/share/${PN}
	doins Azureus2.jar swt.jar || die "doins Azureus2.jar swt.jar"
	
	cp -R plugins ${D}/usr/share/${PN} || die "cp -R plugins"

	(echo '6a'; echo 'PROGRAM_DIR="/usr/share/azureus"'; echo '.'; echo 'wq') | ed -s azureus
	dobin azureus

	mv Azureus.png azureus.png
	insinto /usr/share/pixmaps
	doins azureus.png
	make_desktop_entry "azureus" "Azureus - Java BitTorrent Client" "azureus.png" "Network;P2P"
	echo -e '\nName[ru]=Azureus - Java BitTorrent Клиент\n' >> ${D}/usr/share/applications/azureus-azureus.desktop
}

pkg_postinst() {
	echo
	ewarn "To update Azureus plugins from older version run:"
	ewarn "java -cp /usr/share/azureus/plugins/azupdater/Updater.jar org.gudy.azureus2.update.Updater updateonly `pwd` ~/.azureus"
}
