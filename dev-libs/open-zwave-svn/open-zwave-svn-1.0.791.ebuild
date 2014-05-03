# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit versionator subversion

MY_REV=$(get_version_component_range 3)

DESCRIPTION="An open-source interface to Z-Wave networks."
HOMEPAGE="https://code.google.com/p/open-zwave/"
ESVN_REPO_URI="http://open-zwave.googlecode.com/svn/trunk/"
ESVN_REVISION="${MY_REV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxml2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/get-rid-of-tinyxml.patch
}

src_compile() {
	emake VERSION_REV="${MY_REV}" || die "Compile failed"
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
