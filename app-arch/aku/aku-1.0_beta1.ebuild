# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
NEED_KDE="4.1"
SLOT="kde-4" 

inherit kde4-base

DESCRIPTION="The RAR GUI application for KDE4"
HOMEPAGE="http://akublog.wordpress.com/"  	
SRC_URI="http://www.webalice.it/frgrieco/${PN}-${PV}.tar.bz2"

LICENSE="GPL-2"

IUSE=""

RDEPEND=""
       	
DEPEND="${RDEPEND}
       	>=app-arch/rar-3.8.0"

KEYWORDS="~x86 ~amd64"

S="${WORKDIR}/aku"


src_unpack() {
        kde4-base_src_unpack
	cd "${S}"
        epatch "${FILESDIR}"/cmake-include.patch
}
