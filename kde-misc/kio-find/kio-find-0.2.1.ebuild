# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvsd/root/portage/kde-misc/kio-find/kio-find-0.2.1.ebuild,v 1.2 2007/06/09 20:24:40 root Exp $

inherit kde eutils

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="http://demandiseineseite.gmxhome.de/find/$P.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=app-misc/tracker-0.5.4
dev-libs/glib
dev-libs/dbus-glib"
RDEPEND=""

src_compile()
{
	econf --without-arts || die
	MYFLAGS="$CXXFLAGS -I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include/ -I/usr/include/dbus-1.0" 
	MYFLAGS="$MYFLAGS -lglib-2.0 -ltrackerclient"
	emake CXXFLAGS="$MYFLAGS" || die
	#emake || die
}

