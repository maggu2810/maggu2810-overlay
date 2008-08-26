# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="1"

NEED_KDE="svn"
inherit kde4-base

DESCRIPTION="A KDE4 Plasma Applet display CPU usage and manage the cpu govenor"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
SRC_URI="http://www.hirnfrei.org/~joerg/coremoid/${P}.tar.bz2"
SLOT="kde-4"

DEPEND="kde-base/plasma-workspace"

src_compile() {
	epatch ${FILESDIR}/kdesvn-fix.patch
	kde4-base_src_compile
}
