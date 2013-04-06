# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 systemd udev

MY_P="QtSixA-${PV}"
DESCRIPTION="Sixaxis Joystick Manager"
HOMEPAGE="http://qtsixa.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P/-/%20}/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc jack qt4"

DEPEND="net-wireless/bluez
	virtual/libusb:1
	jack? ( media-sound/jack-audio-connection-kit )
	qt4? ( dev-python/PyQt4 )"

RDEPEND="${DEPEND}
	dev-python/dbus-python
	qt4? (
		net-wireless/bluez-hcidump
		x11-libs/libnotify
		x11-misc/xdg-utils
	)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/qtsixa-1.5.1-fix-missing-includes.patch

	sed -i -e s/exec\ python/exec\ "${EPYTHON}"/g qtsixa/qtsixa
}

src_compile() {
	use qt4 && emake -C qtsixa
	emake -C utils WANT_JACK=$(use jack && echo true)
	emake -C sixad
}

src_install() {
	use qt4 && emake -C qtsixa install DESTDIR="${D}"
	emake -C utils install DESTDIR="${D}" WANT_JACK=$(use jack && echo true)
	emake -C sixad install DESTDIR="${D}"

	use doc && dodoc INSTALL manual.pdf README TODO

	if use qt4; then
		python_fix_shebang "${D}"/usr/bin/sixad-lq
		python_fix_shebang "${D}"/usr/bin/sixad-notify
		python_fix_shebang "${D}"/usr/share/qtsixa/gui
		python_optimize "${D}"/usr/share/qtsixa/gui
	fi

	rm "${D}etc/init.d/sixad" || die # TODO: Write a Gentoo version.

	systemd_dounit "${FILESDIR}"/sixad.service

	udev_dorules "${FILESDIR}"/97-sixpair.rules
}

pkg_postinst() {
	udevadm control --reload-rules

	einfo "Requirements:"
	einfo "Ensure that the uinput module is loaded."

	einfo "Solve conflicts:"
	einfo "Do not forget to disable the input plugin of your bluetooth daemon."
	einfo "You could disable the plugin by adding the following line to the"
	einfo "configuration file of the bluetooth daemon (/etc/bluetooth/main.conf):"
	einfo "DisablePlugins = input"
}
