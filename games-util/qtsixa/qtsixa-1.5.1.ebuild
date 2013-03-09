# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils systemd

MY_P="QtSixA-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Sixaxis Joystick Manager"
HOMEPAGE="http://qtsixa.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/qtsixa/files/${MY_P/-/%20}/${MY_P}-src.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="jack qt4"

DEPEND="virtual/libusb:1
	net-wireless/bluez
	jack? ( media-sound/jack-audio-connection-kit )
	qt4? ( dev-python/PyQt4 )"

RDEPEND="${DEPEND}
	dev-python/dbus-python
	qt4? (
		net-wireless/bluez-hcidump
		x11-libs/libnotify
		x11-misc/xdg-utils
	)"

src_compile() {
	use qt4 && emake -C qtsixa
	emake -C utils WANT_JACK=$(use jack && echo true)
	emake -C sixad
}

src_install() {
	use qt4 && emake -C qtsixa install DESTDIR="${D}"
	emake -C utils install DESTDIR="${D}" WANT_JACK=$(use jack && echo true)
	emake -C sixad install DESTDIR="${D}"

	dodoc INSTALL manual.pdf README TODO
	rm "${D}etc/init.d/sixad" || die # TODO: Write a Gentoo version.

	systemd_dounit "${FILESDIR}"/sixad.service
}
