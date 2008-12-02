# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator toolchain-funcs multilib

EMULTILIB_PKG="true"

DESCRIPTION="OpenGL video capturing library"
HOMEPAGE="http://neopsis.com/projects/seom"

SRC_URI="http://dbservice.com/ftpdir/tom/${PN}/trunk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=">=dev-lang/yasm-0.6.0"
RDEPEND=""

src_unpack() {
	for ABI in $(get_install_abis); do
		unpack ${A}
		mv "${P}" "${ABI}"
	done
}

src_compile() {
	for ABI in $(get_install_abis); do
		cd "${WORKDIR}/${ABI}"

		if [ "${ABI}" = "default" ]; then
			ABI=x86
		fi

		econf --arch="${ABI}" --prefix="/usr" || die "econf failed"
		emake CC="$(tc-getCC) $(get_abi_CFLAGS ${ABI})" || die "emake failed"
	done
}

src_install() {
	for ABI in $(get_install_abis); do
		cd "${WORKDIR}/${ABI}"
		emake DESTDIR="${D}" LIBDIR="$(get_abi_LIBDIR ${ABI})" install || die "emake install failed"
	done
}
