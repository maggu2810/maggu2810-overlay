# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Qt4 graphical user interface that provides a workflow for HDR imaging"
HOMEPAGE="http://qtpfsgui.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"


LICENSE="GPLv2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="=x11-libs/qt-4*
	media-gfx/exiv2
	=sci-libs/fftw-3*
	media-libs/jpeg
	media-libs/tiff
	media-libs/openexr"
RDEPEND="${DEPEND}"

src_compile() {
	qmake PREFIX=/usr|| die "qmake failed"
	emake || die "emake failed"
}

src_install() {
        dobin qtpfsgui

        insinto /usr/share/applications
        doins qtpfsgui.desktop

        insinto /usr/share/pixmaps
        doins images/qtpfsgui.png

        dodoc AUTHORS COPYING Changelog NEWS README TODO
        dohtml -r -A jpeg html/*
}
