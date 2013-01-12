# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games cmake-utils

MY_PN="${PN}-linux"
MY_PV="${PV/_rc/rc}"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="The new Blobby Volley, a volley-game with colorful blobs"
HOMEPAGE="http://blobby.sourceforge.net/"
SRC_URI="mirror://sourceforge/blobby/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/opengl
	media-libs/libsdl
	dev-games/physfs"
DEPEND="${RDEPEND}"

S="${WORKDIR}/blobby-${MY_PV}"

src_prepare()
{
	epatch "${FILESDIR}/${P}.patch"
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
