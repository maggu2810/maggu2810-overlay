# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV="${PV%.*}.b${PV##*.}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="An MAME frontend for XMAME and SDLMAME"
HOMEPAGE="http://www.mameworld.net/mamecat/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

DEPEND=">=x11-libs/qt-4.2"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

FLAGS="PREFIX=${D}usr DATADIR=${D}usr/share SYSCONFDIR=${D}etc CTIME=0"
QTDIR="/usr"

pkg_setup() {
	if ! built_with_use =x11-libs/qt-4* accessibility ; then
#		|| ! built_with_use =x11-libs/qt-4* qt3support; then
		eerror '=x11-libs/qt-4* must be built with USE="accessibility"'
#		eerror "qt3support prior to building ${PN}"
		die "Please re-emerge =x11-libs/qt-4 with proper USE flag set"
	fi
}

src_compile() {
	## This is not as it appears, ARCH means something different to qmc2's Makefile
	## then it means to the portage/portage-compatible package manager
	sed -ie 's%ifndef ARCH%ifdef ARCH%' Makefile

	use debug && FLAGS="${FLAGS} DEBUG=0"
	make ${FLAGS} || die "make failed"
}

src_install() {
	make ${FLAGS} install || die "make install failed"

	## Not a big fan of doing this, but it's necessary due to build system
	sed -ie "s%${D}%/%g" "${D}etc/${PN}/${PN}.ini" 
	rm "${D}etc/${PN}/${PN}.inie"
}

pkg_postinst() {
	ewarn "After starting qmc2 you may get a warning about a missing template,"
	ewarn "it appears to be minor, and probably a bug since qmc2 didn't create it."
	ewarn "To create it:"
	ewarn "mkdir -p "\${HOME}/.qmc2/data/opt" && touch \${HOME}/.qmc2/data/opt/template.xml"
}
