# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygame/pygame-1.7.1.ebuild,v 1.4 2006/08/19 13:11:29 herbs Exp $

inherit distutils

S="${WORKDIR}/${P}"

DESCRIPTION="The Vision Egg is a powerful, flexible, and free way to produce stimuli for vision research experiments."
HOMEPAGE="http://www.visionegg.org/"
SRC_URI="mirror://sourceforge/visionegg/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

# 	>=dev-python/numarray-1.3
DEPEND="virtual/python
	>=dev-python/numeric-23
	>=dev-python/imaging-1.1.5
	>=dev-python/pyopengl-2
	>=dev-python/pygame-1.7"

src_unpack() {
	unpack ${A}
}

src_install() {
	mydoc=WHATSNEW
	distutils_src_install

	if use doc; then
		dohtml -r docs/*
		insinto /usr/share/doc/${PF}/examples
		doins ${S}/examples/*
		insinto /usr/share/doc/${PF}/examples/data
		doins ${S}/examples/data/*
	fi
}
