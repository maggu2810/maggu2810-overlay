# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=0

inherit eutils

DESCRIPTION="UseNeXT Newsreader"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

HOMEPAGE="http://www.usenext.com"
DOWNLOAD_URL=${HOMEPAGE}
ORIG_NAME="${PN}.deb"
SRC_URI="${P}.deb"
UN="UseNeXT"
MAINT="this-is@a-dummy.one"
RESTRICT="fetch strip"

DEPEND="sys-apps/debianutils"
RDEPEND=">=dev-lang/mono-1.1.8.1
	>=dev-libs/glib-2.10.2
	>=gnome-base/libgnome-2.16.0
	>=x11-libs/gtk+-2.10.2
	dev-dotnet/libgdiplus
	app-arch/unrar"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download \"${ORIG_NAME}\" from your personal area of"
	einfo "\"${DOWNLOAD_URL}\""
	einfo "Place it in \"${DISTDIR}\" named as \"${SRC_URI}\"."
	einfo "Notice the ${PV}. Because ${UN} changes the deb file"
	einfo "without changing the filename, I/we have to resort to renaming to keep"
	einfo "the md5sum verification working for existing and new downloads."
	einfo ""
	einfo "If emerge fails because of a md5sum error it is possible that ${UN}"
	einfo "has again changed the upstream release, try downloading the file"
	einfo "again or a newer revision if available. Otherwise report this to"
	einfo "\"${MAINT}\" and I/we will make a new revision."
}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	rm -f control.tar.gz data.tar.gz debian-binary
}

src_install() {
	cp -pPR * "${D}"/ || die "installing data failed"
}
