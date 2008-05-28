# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# very bad ebuild, but it works for me and I have no time at the moment

MY_PN="${PN/amp/Amp}"
MY_DIR="${MY_PN}.vfs"

DESCRIPTION="SnackAmp: Tcl/Tk Music Player"
HOMEPAGE="http://snackamp.sourceforge.net"
SRC_URI="mirror://sourceforge/snackamp/${MY_PN}-${PV}.tar.gz"

DEPEND=""
RDEPEND="dev-lang/tcl
	 dev-lang/tk
	 dev-db/metakit"

inherit eutils

IUSE=""

S="${WORKDIR}/${MY_DIR}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

src_install() {
	dodir /opt
        cp -r "${S}" "${D}/opt"
        dosym /opt/${MY_DIR}/snackAmp.tcl /usr/bin/${MY_PN}
}
