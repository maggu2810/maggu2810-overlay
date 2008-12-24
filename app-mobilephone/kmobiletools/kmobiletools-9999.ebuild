# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_KDE="4.1"
inherit eutils kde4-base subversion
SLOT="4.1"

DESCRIPTION="KMobiletools is a KDE-based application that allows to control mobile phones with your PC."
HOMEPAGE="http://www.kmobiletools.org/"

LICENSE="GPL-2"
KEYWORDS=""
IUSE=""
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/KDE/kdepim/${PN}/"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
	subversion_wc_info
	epatch "${FILESDIR}"/cmake.patch
}
