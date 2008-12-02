# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator toolchain-funcs multilib

EMULTILIB_PKG="true"

DESCRIPTION="OpenGL video capturing framework"
HOMEPAGE="http://neopsis.com/projects/yukon/"

SRC_URI="http://dbservice.com/ftpdir/tom/${PN}/trunk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="x11-libs/seom"
RDEPEND="${DEPEND}"

src_unpack() {
	for ABI in $(get_install_abis); do
		unpack ${A}
		mv "${P}" "${ABI}"
	done
}

src_compile() {
	for ABI in $(get_install_abis); do
		cd "${WORKDIR}/${ABI}"

		econf --libdir="$(get_abi_LIBDIR ${ABI})" || die "econf failed"
		emake CC="$(tc-getCC) $(get_abi_CFLAGS ${ABI})" || die "emake failed"
	done
}

src_install() {
	dodir /etc/yukon/system

	for ABI in $(get_install_abis); do
		cd "${WORKDIR}/${ABI}"
		emake DESTDIR="${D}" install || die "emake install failed"
		cp sysconf "${D}/etc/yukon/system/${ABI}"
	done
}
