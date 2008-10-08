# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

[[ "${PORTDIR_OVERLAY}" =~ kdesvn-portage ]] || exit

EAPI="1"

NEED_KDE="4.2"

inherit kde4svn

DESCRIPTION="k9copy is a DVD backup utility which allows the copy of one or more titles from a DVD9 to a DVD5"
HOMEPAGE="http://k9copy.sourceforge.net/"
ESVN_REPO_URI="https://k9copy.svn.sourceforge.net/svnroot/k9copy/kde4"
ESVN_PROJECT="k9copy"
ESVN_REVISION="291"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

#KDE_LINGUAS="ca cs de el es_AR es et fr it nl pl pt_BR ru sr@latin sr tr zh_TW" to do

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
}

src_compile() {
	kde4overlay-base_src_compile
}

src_install() {
	kde4overlay-base_src_install
}

