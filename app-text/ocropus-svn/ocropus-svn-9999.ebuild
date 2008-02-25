# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="OCRopus is a state-of-the-art document analysis and OCR system."
HOMEPAGE="http://code.google.com/p/ocropus/"

ESVN_REPO_URI="http://ocropus.googlecode.com/svn/trunk"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=app-text/tesseract-1.04b
	app-text/aspell
	media-libs/tiff
	media-libs/libpng
	media-libs/jpeg"
DEPEND="${RDEPEND}
	dev-util/jam"

src_compile() {
	econf --with-tesseract=/usr || die "econf failed"
	emake || die "emake failed"
}

src_test() {
	cd "${S}/testing"
	./test-compile || die "Tests failed to compile"
	./test-run || die "At least one test failed"
}

src_install() {
	dobin ocrocmd/ocrocmd || die
	dodoc README DIRS
}
