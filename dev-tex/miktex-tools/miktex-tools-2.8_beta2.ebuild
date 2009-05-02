# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cmake-utils

MY_P="miktex-2.8-beta-2"

DESCRIPTION="MiKTeX Tools for Unix"
HOMEPAGE="http://www.miktex.org/unx/"
SRC_URI="http://ftp.fernuni-hagen.de/ftp-dir/pub/mirrors/www.ctan.org/systems/win32/miktex/source/miktex-2.8-beta-2.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="net-misc/curl
	dev-libs/pth
	www-client/lynx
	dev-libs/libxslt
	!media-sound/mpc"
#	virtual/latex-base

S="${WORKDIR}/${MY_P}"

# Parallel make does not work
MAKEOPTS="${MAKEOPTS} -j1"

CMAKE_IN_SOURCE_BUILD=1

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
        insopts -m 0755 -o root -g root
        insinto /usr/bin
        doins "${FILESDIR}/miktex-mf"

}

pkg_postinst() {
	elog ""
	elog "Perhaps you should not run this tools as root."
	elog "But it is just me opinion."
	elog "I write a texlive + miktex howto on http://www.gentooforum.de"
	elog ""
}
