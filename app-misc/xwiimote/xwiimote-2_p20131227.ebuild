# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ "${PV}" == 9999 ]]; then
	inherit autotools git-r3
elif [[ "${PV}" =~ _p ]]; then
	inherit autotools
	SHA=f2be57e24fc24652308840cec2ed702b9d1138df
	SRC_URI="https://github.com/dvdhrm/${PN}/archive/${SHA}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${SHA}"
else
	SRC_URI="https://github.com/dvdhrm/${PN}/releases/download/${P}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Nintendo Wii Remote Linux Device Driver Tools"
HOMEPAGE="https://github.com/dvdhrm/xwiimote"

LICENSE="MIT-with-advertising"
SLOT="0"
IUSE=""

DEPEND="
	sys-libs/ncurses
	virtual/libudev
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	if [[ "${PV}" == 9999 ]] || [[ "${PV}" =~ _p ]]; then
		eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die

	insinto /etc/X11/xorg.conf.d
	doins "${S}/res/50-xorg-fix-${PN}.conf"
}
