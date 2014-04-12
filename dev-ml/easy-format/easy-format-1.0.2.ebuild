# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit findlib

DESCRIPTION="A functional interface to the Format libray in Ocaml"
HOMEPAGE="http://mjambon.com/easy-format.html"
SRC_URI="http://mjambon.com/releases/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-lang/ocaml"
RDEPEND="${DEPEND}"
DOCS=( "README.md Changes" )

src_compile() {
	emake
}

src_install() {
	findlib_src_install
	dodoc ${DOCS}
}
