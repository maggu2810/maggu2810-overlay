# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=0

inherit eutils

SPV=${PV%.*}

DESCRIPTION="PTXdist is a build system for userlands, started by Pengutronix"

HOMEPAGE="http://www.pengutronix.de/software/ptxdist/"

SRC_URI="http://www.pengutronix.de/software/${PN}/download/v${SPV}/${P}.tgz
	patches? ( http://www.pengutronix.de/software/${PN}/download/v${SPV}/${P}-patches.tgz )"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"

IUSE="+patches"

#RESTRICT="strip"

DEPEND=">=sys-libs/ncurses-5.6-r2
	>=dev-tcltk/expect-5.42.1-r1"

RDEPEND="${DEPEND}"

src_unpack() {
        unpack ${A}
        cd "${S}"
        epatch "${FILESDIR}"/bash_completion.patch
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
        elog ""
        elog "Do not forget to run '${PN} setup' as the user"
	elog "who wants use ${PN}."
        elog ""
}
