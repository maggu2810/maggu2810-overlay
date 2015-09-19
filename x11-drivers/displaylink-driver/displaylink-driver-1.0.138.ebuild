# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils systemd udev

DESCRIPTION="DisplayLink USB Graphics Software"

HOMEPAGE="http://www.displaylink.com/downloads/ubuntu.php"

SRC_URI="http://downloads.displaylink.com/publicsoftware/DisplayLink-Ubuntu-${PV}.zip"


LICENSE="closed"

SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND="app-admin/chrpath"

RDEPEND="virtual/libusb:1
	x11-video/evdi"

# Use the variable of the normal install script.
# Perhaps we should use '/opt/...' for binary stuff.
# Let's check this later...
# ATM I do not know if the executable require that location.
DST_COREDIR="/usr/lib/displaylink"
DST_DLM_BASENAME="DisplayLinkManager"

QA_PREBUILT="${DST_COREDIR}/${DST_DLM_BASENAME}"

src_unpack() {
	default
	sh ./"${P}".run --noexec --keep
}

src_install() {
	case "${ARCH}" in
		amd64) DLM="${S}/x64/DisplayLinkManager";;
		x86)   DLM="${S}/x86/DisplayLinkManager";;
		*) die "invalid ARCH (${ARCH})";;
	esac

	# Remove DT_RPATH
	chrpath -d "${DLM}"
	exeinto "${DST_COREDIR}"
	newexe "${DLM}" "${DST_DLM_BASENAME}"

	insinto "${DST_COREDIR}"
	doins "${S}/"*.spkg
	doins "${S}/LICENSE"

	systemd_dounit "${FILESDIR}"/displaylink.service

	udev_dorules "${FILESDIR}"/99-displaylink.rules
}

pkg_postinst() {
	einfo
	einfo "You should enable the display link service:"
	einfo " systemctl enable displaylink.service"
	einfo "and perhaps restart your system."
	einfo
	einfo "If all went fine, you should see an additional provider in X:"
	einfo " xrandr --listproviders"
	einfo "set the provider output source using e.g."
	einfo " xrandr --setprovideroutputsource 1 0"
	einfo "and configure your displays"
	einfo
}
