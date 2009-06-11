# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/app-mobilephone/kmobiletools/Attic/kmobiletools-0.5.0_beta3.ebuild,v 1.7 2009/03/01 15:01:39 dev-zero dead $

inherit kde eutils

MY_P=${P/_beta/-beta}
DESCRIPTION="KMobiletools is a KDE-based application that allows to control mobile phones with your PC."
SRC_URI="mirror://berlios/kmobiletools/${MY_P}.tar.bz2"
HOMEPAGE="http://www.kmobiletools.org/"
LICENSE="GPL-2"

IUSE="bluetooth gammu kde obex"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	kde? (
		|| ( ( =kde-base/libkcal-3.5* =kde-base/kontact-3.5* )
			=kde-base/kdepim-3.5* )
		)
	bluetooth? ( >=net-wireless/kdebluetooth-1.0_beta2 )
	gammu? ( ~app-mobilephone/gammu-1.11.0 net-wireless/bluez-libs )
	obex? ( >=app-mobilephone/obexftp-0.21 net-wireless/bluez-libs )"
RDEPEND=""

need-kde 3.4

S="${WORKDIR}"/${MY_P}

src_unpack() {
	kde_src_unpack

	epatch "${FILESDIR}"/${P}-no-automagic-deps.patch

	# Fixing file collision between kmobiletools and kdebluetooth when
	# USE="obex" is set, see bug 183245
	epatch "${FILESDIR}"/${P}-obexftp-file-collision-fix.patch

	# remove configure script to trigger it's rebuild during kde_src_compile
	rm -f "${S}"/configure || die "Failed to remove ./configure"
}

src_compile() {
	myconf="$(use_enable kde libkcal)
		$(use_enable kde kontact)
		$(use_with gammu)
		$(use_enable bluetooth kdebluetooth)
		$(use_enable obex obexftp)
		--disable-p2kmoto"
	# the last 3 configure switches have only effect when above automagic deps patch is applied

	kde_src_compile
}

pkg_postinst() {
	if use gammu ; then
		echo
		elog "You have enabled gammu engine backend. Please note that support for this"
		elog "engine in ${PN} is considered experimental and may not work as expected."
		elog "More information and configuration steps for gammu engine can be found here:"
		elog "http://www.kmobiletools.org/gammu"
		echo
	fi
}
