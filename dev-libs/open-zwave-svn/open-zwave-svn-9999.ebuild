# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion

DESCRIPTION="An open-source interface to Z-Wave networks."
HOMEPAGE="https://code.google.com/p/open-zwave/"
ESVN_REPO_URI="http://open-zwave.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/libxml2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/get-rid-of-bundled-tinyxml.patch
}

src_compile() {
	subversion_wc_info
	emake VERSION_REV="${ESVN_WC_REVISION}" || die "Compile failed"
}

src_install() {
	#emake DESTDIR="${D}" PREFIX="/usr" install || die "Install failed"

	dodir /etc/openzwave
	dodir /usr/include/openzwave
	dodir /usr/share/openzwave
	#dodir /usr/lib

	insinto /usr/share/openzwave
	doins -r config

	#exeinto /usr/lib
	dolib.so libopenzwave.so*
	#dolib.a libopenzwave.a

	insinto /usr/include/openzwave
	doins cpp/src/*.h cpp/src/value_classes/*.h cpp/src/command_classes/*.h cpp/src/platform/*.h cpp/src/platform/unix/*.h

	#dodoc README* AUTHORS TODO* COPYING
}
