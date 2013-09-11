# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils

MY_P="${P/_alpha/-alpha}"

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions"

HOMEPAGE="http://www.keepassx.org/"

SRC_URI="http://www.keepassx.org/dev/attachments/download/36/${MY_P}.tar.gz"

LICENSE=""

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="c++0x"

#RESTRICT="strip"

DEPEND=">=dev-qt/qtcore-4.6.0
	>=dev-qt/qtgui-4.6.0
	>=dev-qt/qtdbus-4.6.0"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare()
{
	epatch "${FILESDIR}/${PV}-make-test.patch"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS=OFF
		-DWITH_GUI_TESTS=OFF
		$(cmake-utils_use_with c++0x CXX11)
	)
	cmake-utils_src_configure
}
