# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tesseract/tesseract-2.00.ebuild,v 1.1 2007/07/30 19:45:40 chutzpah Exp $

inherit eutils multilib

DESCRIPTION="A commercial quality OCR engine developed at HP in the 80's and early 90's."
HOMEPAGE="http://code.google.com/p/tesseract-ocr/"
SRC_URI="http://tesseract-ocr.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="tiff linguas_de linguas_en linguas_es linguas_fr linguas_it linguas_nl"

DEPEND="tiff? ( media-libs/tiff )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P%b}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# data files shouldn't be executable
	chmod a-x "${WORKDIR}"/tessdata/*
	mv -f "${WORKDIR}"/tessdata/* tessdata/

	sed -i -e "s:/usr/bin/X11/xterm:/usr/bin/xterm:" ccutil/debugwin.cpp
}

src_compile() {
	econf $(use_with tiff libtiff) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README AUTHORS phototest.tif
}
