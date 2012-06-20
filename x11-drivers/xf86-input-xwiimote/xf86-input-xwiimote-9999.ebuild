# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="https://github.com/dvdhrm/xf86-input-xwiimote.git"
inherit eutils git-2 autotools

DESCRIPTION="X.Org Wii Remote Input Driver"

HOMEPAGE="https://github.com/dvdhrm/xf86-input-xwiimote"

SRC_URI=""

LICENSE="BSD"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND="app-misc/xwiimote
		x11-base/xorg-server[udev]"

RDEPEND="${DEPEND}"

src_prepare()
{
	eautoreconf
	elibtoolize
}

src_install()
{
	emake DESTDIR="${D}" install || die

	insinto /etc/X11/xorg.conf.d
	doins "${S}"/60-xorg-xwiimote.conf
}
