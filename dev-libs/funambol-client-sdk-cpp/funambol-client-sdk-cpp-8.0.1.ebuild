# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools

MY_PN=${PN%%-cpp}

DESCRIPTION="Funambol Client SDK, C++ part only"
HOMEPAGE="https://www.forge.funambol.org/download/"

SRC_URI="${MY_PN}-${PV}.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror fetch"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/Funambol/sdk/cpp/build/autotools"

pkg_nofetch() {
	elog "Download the file ${SRC_URI} from ${HOMEPAGE}"
	elog "and place it in ${DISTDIR:-/usr/portage/distfiles}."
}

src_prepare() {
	epatch "${FILESDIR}/fireevent.patch"
	eautoreconf || die "Failed to autotoolize"

}

src_compile() {
#	cd "${S}/build/autotools"
	emake || die "Failed to compilerize"
}

src_install() {
#	cd "${S}/build/autotools"
	emake DESTDIR="${D}" install || die "Failed to installerize"
}
