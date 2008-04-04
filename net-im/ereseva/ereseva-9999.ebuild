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
    net-im/tapioca-python
    dev-python/pyxdg
    dev-python/elementtree
    dev-python/gst-python"

src_compile() {
    sed -i 's/pylint --indent-string="    " --max-args=6 --max-public-methods=35 $@//g' ereseva/Makefile.am
    sed -i 's/python setup.py install --prefix=${prefix}/python setup.py install --prefix=${DESTDIR}${prefix}/g' Makefile.am
    for i in data/icons data/emotes data/avatars
    do
	sed -i 's:$(mkinstalldirs) $(datadir):$(mkinstalldirs) $(DESTDIR)$(datadir):g' ${i}/Makefile.am
        sed -i 's: $(datadir)/: $(DESTDIR)$(datadir)/:g' ${i}/Makefile.am
    done
    ./autogen.sh
    econf || die
    emake || die
}

src_install() {
    make install DESTDIR=${D}
    find ${D} -name "*.pyc" -exec rm '{}' \;
}
