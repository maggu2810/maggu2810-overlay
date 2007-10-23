#
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="High Dynamic Range Images and Video manipulation tools"
HOMEPAGE="http://www.mpi-inf.mpg.de/resources/pfstools/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="octave imagemagick tiff netpbm openexr qt opengl raw"

DEPEND="octave? ( sci-mathematics/octave )
        imagemagick? ( media-gfx/imagemagick )
	tiff? ( media-libs/tiff )
	netpbm? ( media-libs/netpbm )
	openexr? ( media-libs/openexr )
	qt? ( x11-libs/qt )
	opengl? ( virtual/opengl )
	raw? ( media-gfx/dcraw )"

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf \
		$(use_enable octave) \
		$(use_enable qt) \
		$(use_enable tiff) \
		$(use_enable openexr) \
		$(use_enable imagemagick) \
		$(use_enable opengl) || die "configure failed"
	emake || die "compiling failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS README TODO
}
