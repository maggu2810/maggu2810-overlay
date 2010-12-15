# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

KEYWORDS="~x86 ~amd64 ~ppc ~ppc64"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://github.com/abstrakraft/cwiid.git"
	SRC_URI=""
	KEYWORDS=""
	inherit git
else
	SRC_URI="http://abstrakraft.org/cwiid/downloads/${P}.tgz"
fi

inherit eutils linux-mod autotools

DESCRIPTION="Library, input driver, and utilities for the Nintendo Wiimote"
HOMEPAGE="http://abstrakraft.org/cwiid"

LICENSE="GPL-2"
SLOT="0"
IUSE="python -old-bluez-libs"

DEPEND="sys-devel/bison
	>=sys-devel/flex-2.5.35
	sys-apps/gawk"

RDEPEND="
	=x11-libs/gtk+-2*
	>=sys-kernel/linux-headers-2.6
	old-bluez-libs? (
		net-wireless/bluez-libs
		net-wireless/bluez-utils
		)
	!old-bluez-libs? ( net-wireless/bluez )
	python? ( >=dev-lang/python-2.4 )"

pkg_setup() {
	CONFIG_CHECK="BT_L2CAP INPUT_UINPUT"
	linux-mod_pkg_setup
}

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	eautoreconf
}
src_configure() {
	econf $(use_with python) --disable-ldconfig || die "died running econf"
}

src_compile() {
	emake || die "died running emake"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
