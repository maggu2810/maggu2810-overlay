# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit distutils

MYP="${P%.*}.dev${P##*.}"
S="${WORKDIR}/${MYP}"

DESCRIPTION="The Vision Egg is a powerful, flexible, and free way to produce stimuli for vision research experiments."
HOMEPAGE="http://www.visionegg.org/"
SRC_URI="mirror://sourceforge/visionegg/${MYP}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""
RESTRICT="mirror"

DEPEND=">=virtual/python-2.5.1
	>=dev-python/numeric-24.2
	>=dev-python/numarray-1.5.2
	>=dev-python/imaging-1.1.6
	>=dev-python/pyopengl-2.0.1
	>=dev-python/pygame-1.7.1"

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils_src_install
}
