# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/eagle/eagle-5.2.0.ebuild,v 1.1 2008/10/02 02:43:17 nixphoeni Exp $

EAPI=0

inherit eutils

DESCRIPTION="Themeable and easy to use TV Guide - written in Java"
HOMEPAGE="http://java.sun.com/products/javacomm/"
SRC_URI="${PN}${PV}_u1_linux.zip"
RESTRICT="fetch strip"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="sun-comm"
SLOT="0"

RDEPEND=">=virtual/jre-1.4"

MY_PN="${PN}api"

S="${WORKDIR}/${MY_PN}"

INSTALLDIR="/opt/${P}"

# src_compile() { :; }

src_install() {
	dodir "${INSTALLDIR}"
	cp -r . "${D}"/"${INSTALLDIR}"

	dodir "/usr/lib"
	dosym "${INSTALLDIR}/lib/libLinuxSerialParallel.so" "/usr/lib"
	dosym "${INSTALLDIR}/lib/libLinuxSerialParallel_g.so" "/usr/lib"
}
