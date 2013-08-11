# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="ARP scanning and fingerprinting tool"
HOMEPAGE="http://www.nta-monitor.com/tools/arp-scan/index.html"
SRC_URI="http://www.nta-monitor.com/tools/${PN}/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

src_install() {
	default

	dodoc NEWS README TODO AUTHORS || die
}
