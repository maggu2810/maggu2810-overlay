# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome.org git-r3 autotools

MY_PN="${PN/networkmanager/NetworkManager}"

DESCRIPTION="NetworkManager L2TP - for L2TP and L2TP over IPSec VPN support."
HOMEPAGE="https://github.com/nm-l2tp/network-manager-l2tp"
SRC_URI=""

EGIT_REPO_URI="git://github.com/nm-l2tp/network-manager-l2tp.git"
EGIT_COMMIT="${PV}"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

DEPEND="sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig
	>=net-misc/networkmanager-0.8.1
	>=dev-libs/dbus-glib-0.74
	=net-dialup/ppp-2.4.7*
	net-dialup/xl2tpd
	net-vpn/libreswan
	gnome? (
		x11-libs/gtk+:3
		gnome-base/gconf:2
		gnome-base/gnome-keyring
	)"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	mkdir -p m4
	intltoolize --copy --force --automake
	eautoreconf
	default
}

src_configure() {
	ECONF="--with-pppd-plugin-dir=/usr/lib/pppd/2.4.7
		$(use_with gnome)"

	econf ${ECONF}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
