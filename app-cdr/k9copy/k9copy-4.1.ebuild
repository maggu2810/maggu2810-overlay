# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_KDE=":4.1"
KDE_LINGUAS="ar be bg ca da de el en_GB eo es et eu fi fr ga gl hi hu it ja km
lt lv nb nds nl nn oc pl pt pt_BR ro ru se sk sl sv tr uk zh_CN zh_TW"
inherit eutils kde4-base subversion
SLOT="4.1"

DESCRIPTION="k9copy is a DVD backup utility which allows the copy of one or more titles from a DVD9 to a DVD5"
HOMEPAGE="http://k9copy.sourceforge.net/"

ESVN_REPO_URI="https://k9copy.svn.sourceforge.net/svnroot/k9copy/kde4"
ESVN_PROJECT="k9copy"
ESVN_REVISION="291"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-libs/libdvdread
	x11-libs/qt-dbus
	sys-apps/hal
	media-video/ffmpeg
	media-video/mplayer
	app-cdr/k3b"
RDEPEND="${DEPEND}
	media-libs/xine-lib
	media-video/dvdauthor"

src_unpack() {
	subversion_src_unpack
	subversion_wc_info
	epatch "${FILESDIR}/ffmpeg.patch"
}

#src_compile() {
#	kde4overlay-base_src_compile
#}

#src_install() {
#	kde4overlay-base_src_install
#}

