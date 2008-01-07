# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="Multiplayer game network engine"
HOMEPAGE="http://www.rakkarsoft.com/"
SRC_URI="http://perso.renchap.com/${P}.tgz"

LICENSE="CCPL-Attribution-NonCommercial-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	eend
}

src_compile() {
	emake CONF=Release || die "emake (release version) failed!"
	if use debug; then
		emake || die "emake (debug version) failed!"
	fi
}

src_install() {
	dolib Lib/GNU-Linux-x86/libraknet.a
	if use debug ; then
		dolib Lib/GNU-Linux-x86/libraknetd.a
	fi

	insinto /usr/include/raknet
	doins Source/*.h

	if use doc; then
		dodoc readme.txt

		dohtml Help/*
		
		docinto api
		dohtml Help/DOxygen/*
	fi
}
