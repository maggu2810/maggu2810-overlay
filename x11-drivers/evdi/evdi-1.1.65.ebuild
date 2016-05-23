# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils linux-info linux-mod git-r3

DESCRIPTION="Extensible Virtual Display Interface"
HOMEPAGE="https://github.com/DisplayLink/evdi"
#SRC_URI="ftp://foo.example.org/${P}.tar.gz"
EGIT_REPO_URI="git://github.com/DisplayLink/evdi.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND="sys-kernel/linux-headers"

#S=${WORKDIR}/${P}

MODULE_NAMES="evdi(video:${S}/module)"
LIB_PATH="${S}/library"

src_compile() {
	linux-mod_src_compile

	pushd "${LIB_PATH}"
	default
	popd
}

src_install() {
	linux-mod_src_install

	pushd "${LIB_PATH}"
	dolib.so libevdi.so
	popd
}

