# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="https://tapioca-voip.svn.sourceforge.net/svnroot/tapioca-voip/trunk/tapioca-glib"

inherit eutils subversion

DESCRIPTION="Tapioca glib"
HOMEPAGE="http://tapioca-voip.sf.net"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/glib
    dev-util/gtk-doc"

src_compile() {
    ./autogen.sh
    econf || die
    emake || die
}

src_install() {
    make install DESTDIR=${D}
}
