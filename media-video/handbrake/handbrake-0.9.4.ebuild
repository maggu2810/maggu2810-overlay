# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2-utils

MY_PN="HandBrake"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Open-source DVD to MPEG-4 converter"
HOMEPAGE="http://handbrake.fr/"
SRC_URI="http://handbrake.fr/rotation.php?file=${MY_PN}-${PV}.tar.bz2
		-> ${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="css doc gtk"
RDEPEND="sys-libs/zlib
	css? ( media-libs/libdvdcss )
	gtk? (	>=x11-libs/gtk+-2.8
			dev-libs/dbus-glib
			sys-apps/hal
			net-libs/webkit-gtk
			x11-libs/libnotify
			media-libs/gstreamer
			media-libs/gst-plugins-base
	)"
DEPEND="dev-lang/yasm
	dev-lang/python
	|| ( net-misc/wget net-misc/curl ) 
	${RDEPEND}"

src_configure() {
	# Python configure script doesn't accept all econf flags
	./configure --force --prefix=/usr \
		$(use_enable gtk) \
		|| die "configure failed"
}

src_compile() {
	emake -C build || die "failed compiling ${PN}"
}

src_install() {
	emake -C build DESTDIR="${D}" install || die "failed installing ${PN}"

	if use doc; then
		emake -C build doc
		dodoc AUTHORS CREDITS NEWS THANKS \
			build/doc/articles/txt/* || die "docs failed"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
