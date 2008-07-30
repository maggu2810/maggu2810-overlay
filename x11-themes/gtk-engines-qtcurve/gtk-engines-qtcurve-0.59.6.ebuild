# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-qtcurve/gtk-engines-qtcurve-0.59.6.ebuild,v 1.1 2008/07/19 22:06:20 yngwin Exp $

inherit eutils cmake-utils

MY_P=${P/gtk-engines-qtcurve/QtCurve-Gtk2}

DESCRIPTION="A set of widget styles for GTK2 based apps, also available for KDE3 and Qt4"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=40492"
SRC_URI="http://home.freeuk.com/cpdrummond/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="mozilla"

RDEPEND=">=x11-libs/gtk+-2
	x11-libs/cairo"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4"

S=${WORKDIR}/${MY_P}
DOCS="ChangeLog README TODO"

src_compile() {
	local mycmakeargs=""
	use mozilla && mycmakeargs="-DQTC_MODIFY_MOZILLA=true
		-DQTC_MODIFY_MOZILLA_USER_JS=true
		-DQTC_NEW_MOZILLA=true"
	cmake-utils_src_compile
}
