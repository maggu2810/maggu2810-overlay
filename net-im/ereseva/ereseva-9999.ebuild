# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by maggu2810 (maggu2810@gentooforum.de)

ESVN_REPO_URI="https://tapioca-voip.svn.sourceforge.net/svnroot/tapioca-voip/trunk/ereseva"

inherit eutils subversion

DESCRIPTION="Ereseva IM - using tapioca"
HOMEPAGE="http://tapioca-voip.sf.net"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="net-im/tapioca-glib
    net-im/tapioca-python"

src_compile() {
    sed -i 's/pylint --indent-string="    " --max-args=6 --max-public-methods=35 $@//g' ereseva/Makefile*
    ./autogen.sh
    econf || die
    emake || die
}

src_install() {
    make install DESTDIR=${D}
}
