# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit versionator toolchain-funcs multilib

EMULTILIB_PKG="true"

if [[ ${PV} == "9999" ]] ; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/wereHamster/${PN}.git"
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="http://dbservice.com/ftpdir/tom/${PN}/trunk/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="OpenGL video capturing library"
HOMEPAGE="http://neopsis.com/projects/seom"
LICENSE="GPL-2"
SLOT="0"

IUSE=""

DEPEND=">=dev-lang/yasm-0.6.0"
RDEPEND=""

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		EGIT_NOUNPACK=1
		git-2_src_unpack $@
	fi

	for ABI in $(get_install_abis); do
		default_src_unpack
		mv "${P}" "${ABI}"
		echo "1.0" > "${ABI}/VERSION"
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

