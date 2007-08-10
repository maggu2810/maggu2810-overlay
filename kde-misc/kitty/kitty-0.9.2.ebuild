# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde
DESCRIPTION="Kitty is a simple podcast client for the KDE 3.4 desktop that allows Linux (and other KDE-running OS) users to tune in, watch, download and bookmark TV programs from these so-called videocasts that are becoming more famous, thanks to the DTV, Yahoo! Podcast and other services."
HOMEPAGE="http://www.kesiev.com/kittyguide/home/"
SRC_URI="http://www.kde-apps.org/content/files/29730-${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/${PN}"
need-kde 3.4

pkg_postinst() {
	einfo
	einfo "Emerge net-p2p/bittorrent or net-p2p/bittornado"
	einfo "and point Kitty at /usr/bin/btdownloadheadless.py"
	einfo "for BitTorrent support."
	einfo
}
