# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvsd/root/portage/kde-misc/find_applet/find_applet-0.2.1.ebuild,v 1.2 2007/06/09 20:24:39 root Exp $

inherit kde eutils

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="http://demandiseineseite.gmxhome.de/find/$P.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="kde-misc/kio-find
|| ( kde-base/kicker kde-base/kdebase)"
RDEPEND=""

src_compile()
{
	econf --without-arts || die
	emake || die
}

