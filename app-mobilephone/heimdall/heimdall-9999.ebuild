# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools eutils qt4-r2 git-2

DESCRIPTION="Heimdall is a cross-platform (OSS) tool suite used to flash firmware onto Samsung Galaxy S devices."
HOMEPAGE="http://www.glassechidna.com.au/products/heimdall/"

EGIT_REPO_URI="git://github.com/Benjamin-Dobell/Heimdall.git
			   https://github.com/Benjamin-Dobell/Heimdall.git"
EGIT_TREE="master"
EGIT_PROJECT="Heimdall"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="qt4"

RDEPEND="qt4? ( dev-qt/qtcore dev-qt/qtgui )
		 >dev-libs/libusb-1.0"

DEPEND="$RDEPEND
		dev-util/pkgconfig"

src_prepare() {
	local LIBUSB_DIR=""
	if [ -d libusb-1.0 ]; then
		if [ -n "${LIBUSB_DIR}" ]; then die "Multiple libusb sources."; fi
		LIBUSB_DIR=libusb-1.0
	elif [ -d libusbx-1.0 ]; then
		if [ -n "${LIBUSB_DIR}" ]; then die "Multiple libusb sources."; fi
		LIBUSB_DIR=libusbx-1.0
	fi
	if [ -z "${LIBUSB_DIR}" ]; then die "Bundled libusb sources not found."; fi
	rm -r "${LIBUSB_DIR}" || die "Can't delete libusb sources"
	edos2unix "${S}"/${PN}-frontend/${PN}-frontend.pro
	edos2unix "${S}"/${PN}/Makefile.am
	sed -e 's:/usr/local:/usr:g' -i "${S}"/${PN}-frontend/${PN}-frontend.pro \
		|| die
	#sed 's:SYSFS:ATTRS:g' -i "${S}"/${PN}/60-${PN}-galaxy-s.rules || die
	sed -i -e '/sudo service udev restart/d' "${S}"/heimdall/Makefile.am
	cd "${S}/${PN}"
	eautoreconf
	cd ..
}

src_configure() {
	cd "${S}"/libpit
	econf --prefix=/usr/ --libdir=/usr/$(get_libdir) || die "econf failed"
	cd "${S}"/${PN}
	econf --prefix=/usr/ --libdir=/usr/$(get_libdir) || die "econf failed"
	if use qt4; then
	cd "${S}"/${PN}-frontend
		eqmake4 heimdall-frontend.pro OUTPUTDIR="${D}/usr/bin/" || die "eqmake failed"
	fi
}

src_compile() {
	cd "${S}"/libpit
	emake DESTDIR="${D}"|| die "compile failed"
	cd "${S}"/${PN}
	emake DESTDIR="${D}"|| die "compile failed"
	if use qt4; then
		cd "${S}"/${PN}-frontend
		emake OUTPUTDIR="${D}"|| die "compile failed"
	fi
}

src_install() {
	cd "${S}"/libpit
	emake DESTDIR="${D}" install || die "install failed"
	cd "${S}"/${PN}
	sed '/sudo service udev restart/d' Makefile > Makefile.new ||die "Couldn't patch Makefile"
	mv Makefile.new Makefile
	emake DESTDIR="${D}" install || die "install failed"
	if use qt4; then
		cd "${S}"/${PN}-frontend
		emake OUTPUTDIR="${D}" install|| die "install failed"
	fi
}

pkg_postinst() {
	udevadm control --reload-rules && udevadm trigger --subsystem-match=usb
}
