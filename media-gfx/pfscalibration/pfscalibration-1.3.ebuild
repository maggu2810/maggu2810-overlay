# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="photometric calibration of HDR and LDR cameras"
HOMEPAGE="http://www.mpi-sb.mpg.de/resources/hdr/calibration/pfs.html"
SRC_URI="mirror://sourceforge/pfstools/${P}.tar.gz"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/pfstools"
RDEPEND="media-gfx/jhead"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-numerical_sep_gentoo.patch
}

src_compile() {
	econf  || die "configure failed"
	emake || die "compiling failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS README TODO
}
