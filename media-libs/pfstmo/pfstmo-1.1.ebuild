#
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="implementation of tone mapping operators"
HOMEPAGE="http://www.mpi-sb.mpg.de/resources/tmo/"
SRC_URI="mirror://sourceforge/pfstools/${P}.tar.gz"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="fftw"

DEPEND="media-libs/pfstools
	fftw? ( >=sci-libs/fftw-3.0.1 )"

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf $(use_enable fftw fftw3f) || die "configure failed"
	emake || die "compiling failed"
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS README TODO
}
