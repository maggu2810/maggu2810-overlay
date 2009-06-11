# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="External library to compress/decompress S3TC textures"
HOMEPAGE="http://homepage.hispeed.ch/rscheidegger/dri_experimental/s3tc_index.html"
SRC_URI="http://homepage.hispeed.ch/rscheidegger/dri_experimental/${PN}${PV}.tar.gz"
RESTRICT="mirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S=${WORKDIR}

src_unpack() {
	local ABI
	for ABI in `get_all_abis` ; do
		mkdir -p "${ABI}"
		cd "${ABI}"
		unpack ${A}
		cd "${WORKDIR}"
	done
}

src_compile() {
	local ABI
	for ABI in `get_all_abis` ; do
		emake -C "${ABI}/${PN}" || die "emake (ABI=${ABI})"
	done
}

src_install() {
	local ABI
	for ABI in `get_all_abis` ; do
		dolib.so "${ABI}/${PN}/libtxc_dxtn.so" || die "dolib.so libtxc_dxtn.so (ABI=${ABI})"
	done
}

pkg_postinst() {
	einfo "\"IP\" issues"
	einfo ""
	einfo "\"Depending on where you live, you might need a valid license"
	einfo "for s3tc in order to be legally allowed to use the patch"
	einfo "and/or the external library. Redistribution in binary form"
	einfo "might also be problematic (I certainly don't impose any"
	einfo "restrictions on redistribution, the code itself is all BSD"
	einfo "licensed). Ask your lawyer, the patent is supposedly held by"
	einfo "VIA. It is your responsibility to make sure you comply with"
	einfo "the laws of your country, not mine!\""
	einfo ""
	einfo "source:"
	einfo "http://homepage.hispeed.ch/rscheidegger/dri_experimental/s3tc_index.html"
	einfo ""
	einfo "DO NOT CONTACT the libtxc_dxtn author with support questions"
}

