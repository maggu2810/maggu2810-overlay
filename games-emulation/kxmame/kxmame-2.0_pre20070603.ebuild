# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krecipes/krecipes-0.8.1.ebuild,v 1.1 2005/07/31 23:10:14 carlo Exp $

inherit kde
need-kde 3.5

MY_P="${PN}-${PV/_pre/-svn-sdlmame-}"
DESCRIPTION="A KDE front-end to MAME"
HOMEPAGE="http://kxmame.sourceforge.net"
SRC_URI="mirror://sourceforge/kxmame/${MY_P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="${DEPEND}
	dev-util/pkgconfig
	dev-libs/glib"

S=${WORKDIR}/${PN}/trunk
