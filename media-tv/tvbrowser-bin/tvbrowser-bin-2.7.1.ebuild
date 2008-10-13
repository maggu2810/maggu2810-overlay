# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/eagle/eagle-5.2.0.ebuild,v 1.1 2008/10/02 02:43:17 nixphoeni Exp $

EAPI=0

inherit eutils

DESCRIPTION="Themeable and easy to use TV Guide - written in Java"
HOMEPAGE="http://www.tvbrowser.org/"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

SRC_URI="mirror://sourceforge/${PN}/${P/-bin/}.tar.gz"

RDEPEND="virtual/jre"

S="${WORKDIR}/${P/-bin/}"

INSTALLDIR="/opt/${P}"
MY_PN=${PN/-bin/}
MY_P=${P/-bin/}

# src_compile() { :; }

src_install() {
	cd "${S}"
	dodir ${INSTALLDIR}
	cp -r . "${D}"/${INSTALLDIR}

        dodir /opt/bin
        dosym "${INSTALLDIR}/${MY_PN}.sh" "/opt/bin/${MY_PN}"
}
