# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/tvtime/tvtime-1.0.2-r2.ebuild,v 1.2 2007/11/27 10:46:09 zzam Exp $

WANT_AUTOMAKE=1.7
WANT_AUTOCONF=2.5

inherit eutils autotools

DESCRIPTION="High quality television application for use with video capture cards"
HOMEPAGE="http://tvtime.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls xinerama"

RDEPEND="x11-libs/libSM
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXv
	x11-libs/libXxf86vm
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXtst
	x11-libs/libXau
	x11-libs/libXdmcp
	>=media-libs/freetype-2
	>=sys-libs/zlib-1.1.4
	>=media-libs/libpng-1.2
	>=dev-libs/libxml2-2.5.11
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/tvtime-1.0.2-gcc41.patch

	# use 'tvtime' for the application icon see bug #66293
	sed -i -e "s/tvtime.png/tvtime/" docs/net-tvtime.desktop

	# patch to adapt to PIC or __PIC__ for pic support
	epatch "${FILESDIR}"/${PN}-pic.patch #74227

	epatch "${FILESDIR}/${P}-xinerama.patch"

	# Remove linux headers and patch to build with 2.6.18 headers
	rm -f "${S}"/src/{videodev.h,videodev2.h}
	epatch "${FILESDIR}/${P}+linux-headers-2.6.18.patch"

	epatch "${FILESDIR}/${P}-libsupc++.patch"

	epatch "${FILESDIR}/glibc-2.10.patch"

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf $(use_enable nls) \
		$(use_with xinerama) || die "econf failed"
	emake || die "compile problem"

}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dohtml docs/html/*
	dodoc ChangeLog AUTHORS NEWS README
}

pkg_postinst() {
	elog "A default setup for ${PN} has been saved as"
	elog "/etc/tvtime/tvtime.xml. You may need to modify it"
	elog "for your needs."
	elog
	elog "Detailed information on ${PN} setup can be"
	elog "found at ${HOMEPAGE}help.html"
	echo
}
