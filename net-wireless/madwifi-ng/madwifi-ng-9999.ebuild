# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/madwifi-ng/madwifi-ng-0.9.3.2.ebuild,v 1.4 2007/08/15 21:29:30 dertobi123 Exp $

inherit linux-mod subversion

MY_P=${PN/-ng/}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Next Generation driver for Atheros based IEEE 802.11a/b/g wireless LAN cards"
HOMEPAGE="http://www.madwifi.org/"

LICENSE="atheros-hal
	|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="app-arch/sharutils"
RDEPEND="!net-wireless/madwifi-old
		net-wireless/wireless-tools
		net-wireless/madwifi-ng-tools"

CONFIG_CHECK="CRYPTO WIRELESS_EXT SYSCTL"
ERROR_CRYPTO="${P} requires Cryptographic API support (CONFIG_CRYPTO)."
ERROR_WIRELESS_EXT="${P} requires CONFIG_WIRELESS_EXT selected by Wireless LAN drivers (non-hamradio) & Wireless Extensions"
ERROR_SYSCTL="${P} requires Sysctl support (CONFIG_SYSCTL)."
BUILD_TARGETS="all"
MODULESD_ATH_PCI_DOCS="README"

pkg_setup() {
	linux-mod_pkg_setup

	MODULE_NAMES="ath_hal(net:${S}/ath_hal)
				wlan(net:${S}/net80211)
				wlan_acl(net:${S}/net80211)
				wlan_ccmp(net:${S}/net80211)
				wlan_tkip(net:${S}/net80211)
				wlan_wep(net:${S}/net80211)
				wlan_xauth(net:${S}/net80211)
				wlan_scan_sta(net:${S}/net80211)
				wlan_scan_ap(net:${S}/net80211)
				ath_rate_amrr(net:${S}/ath_rate/amrr)
				ath_rate_onoe(net:${S}/ath_rate/onoe)
				ath_rate_sample(net:${S}/ath_rate/sample)
				ath_pci(net:${S}/ath)"

	BUILD_PARAMS="KERNELPATH=${KV_OUT_DIR}"
}

src_unpack() {
	mkdir ${MY_P} || die
	cd ${MY_P} || die

	svn checkout "http://svn.madwifi.org/madwifi/trunk" || die

	mv trunk/* . || die
	touch svnversion.h || die
	epatch "${FILESDIR}/madwifi-ng-2.6.24.patch" || die
}

src_install() {
	linux-mod_src_install

	dodoc README THANKS docs/users-guide.pdf docs/WEP-HOWTO.txt
}

pkg_postinst() {
	local moddir="${ROOT}/lib/modules/${KV_FULL}/net/"

	linux-mod_pkg_postinst

	einfo
	einfo "Interfaces (athX) are now automatically created upon loading the ath_pci"
	einfo "module."
	einfo
	einfo "The type of the created interface can be controlled through the 'autocreate'"
	einfo "module parameter."
	einfo
	einfo "As of net-wireless/madwifi-ng-0.9.3 rate control module selection is done at"
	einfo "module load time via the 'ratectl' module parameter. USE flags amrr and onoe"
	einfo "no longer serve any purpose."
}
