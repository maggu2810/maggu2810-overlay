# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5

inherit multilib python

DESCRIPTION="A tool to download flash films from video portals like youtube or myvideo"
HOMEPAGE="http://code.google.com/p/vdown/"
SRC_URI="http://vdown.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.10.4
	>=net-misc/wget-1.10.2"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
}

src_install() {
	python_version

	exeinto /usr/bin
	doexe engine/vdown
	doexe gvdown

	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/gvdown/glade
	doins gvdown.conf
	doins glade/gvdown.glade

	insinto /etc
	doins gvdown.conf

	exeinto /usr/$(get_libdir)/python${PYVER}/site-packages/gvdown/
	doexe gvdown.py

	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/gvdown/
	doins controller.py config.py gvdown_handler.py handler.py 
	 
	doman man/vdown.1
}

pkg_postinst() {
        python_version
        python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/gvdown
}

pkg_postrm() {
        python_mod_cleanup
}
