# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

[[ "${PORTDIR_OVERLAY}" =~ kdesvn-portage ]] || exit

EAPI="1"

KMNAME=kdeutils
inherit kde4overlay-meta

DESCRIPTION="KDE Archiving tool"
KEYWORDS=""
IUSE="debug htmlhandbook zip archive"

DEPEND="app-arch/libarchive
	zip? ( >=dev-libs/libzip-0.8 )"
RDEPEND="${DEPEND}"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with archive LibArchive)
		$(cmake-utils_use_with zip LibZip)"

	kde4overlay-meta_src_compile
}
