# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mozplugger/mozplugger-1.10.2.ebuild,v 1.1 2008/05/28 13:44:28 hanno Exp $

inherit nsplugins

DESCRIPTION="Streaming media plugin for Mozilla, based on netscape-plugger"
SRC_URI="http://mozplugger.mozdev.org/files/${P}.tar.gz"
HOMEPAGE="http://mozplugger.mozdev.org/"

KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~alpha"
LICENSE="GPL-2"

SLOT="0"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}
	|| ( net-libs/xulrunner
		www-client/mozilla-firefox
		www-client/seamonkey )"

src_compile() {
	emake linux || die
}

src_install() {
	emake root="${D}" install || die "install failed"
	src_mv_plugins /usr/lib/mozilla/plugins

	dodoc ChangeLog README || die "dodoc failed"
}
