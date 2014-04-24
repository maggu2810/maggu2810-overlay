# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion

DESCRIPTION="An open-source interface to Z-Wave networks."
HOMEPAGE="https://code.google.com/p/openzwave-control-panel/"
ESVN_REPO_URI="http://openzwave-control-panel.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libmicrohttpd[messages]
	dev-libs/tinyxml
	dev-libs/open-zwave"
RDEPEND="${DEPEND}"

src_compile() {
	cp "${FILESDIR}"/Makefile "${S}"
	epatch "${FILESDIR}"/webserver.patch
	epatch "${FILESDIR}"/ozwcp.patch
	epatch "${FILESDIR}"/ozwcp-random-port-fix.patch
	emake || die
}

src_install() {
	dodir /usr/share/${PN}
	dodir /usr/bin
	insinto /usr/share/${PN}
	doins cp.html cp.js openzwavetinyicon.png
	exeinto /usr/bin
	doexe ozwcp
	dodoc README TODO
}
