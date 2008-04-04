# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by maggu2810 (maggu2810@gentooforum.de)

ESVN_REPO_URI="https://tapioca-voip.svn.sourceforge.net/svnroot/tapioca-voip/trunk/tapioca-python"

inherit eutils subversion

DESCRIPTION="Tapioca python"
HOMEPAGE="http://tapioca-voip.sf.net"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="net-im/tapioca-glib"

src_compile() {
    ./autogen.sh
    econf || die
    emake || die
}

src_install() {
    make install DESTDIR=${D}
}
