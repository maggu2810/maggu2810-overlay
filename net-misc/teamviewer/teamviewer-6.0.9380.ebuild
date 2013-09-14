# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

MY_FILENAME="${P}.tar.gz"

DESCRIPTION="the All-In-One Solution for Remote Access and Support over the
Internet"
HOMEPAGE="http://www.teamviewer.com"
SRC_URI="http://www.teamviewer.com/download/${PN}_linux.tar.gz -> ${MY_FILENAME}"

LICENSE="TeamViewer"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RESTRICT="fetch mirror strip"

DEPEND="app-emulation/wine"
RDEPEND="${DEPEND}"

pkg_nofetch() {
	local FILE="${FILESDIR}/${MY_FILENAME}"
	einfo "Move the file from ${FILE} to ${DISTDIR}."
	einfo " cp \"${FILE}\" \"${DISTDIR}\""
}

pkg_setup() {
	elog "This ebuild installs the TeamViewer binary and libraries and relies on"
	elog "Gentoo's wine package to run the actual program."
	elog
	elog "If you encounter any problems, consider running TeamViewer with the"
	elog "bundled wine package manually."
}

src_install() {
	insinto /opt/teamviewer/ || die
	doins teamviewer6/.wine/drive_c/Program\ Files/TeamViewer/Version6/* ||
		die
	echo "#!/bin/bash" > teamviewer || die
	echo "/usr/bin/wine /opt/teamviewer/TeamViewer.exe" >> teamviewer || die
	insinto /usr/bin || die
	dobin teamviewer || die

	local res
	for res in 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps
		doins teamviewer6/.tvscript/teamviewer.png || die
	done

	dodoc teamviewer6/linux_FAQ_{EN,DE}.txt || die

	make_desktop_entry ${PN} TeamViewer ${PN}
}
