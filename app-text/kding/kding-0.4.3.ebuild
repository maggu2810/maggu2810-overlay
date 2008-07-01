# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/kding/kding-0.4.3.ebuild,v 1.1 2008/06/01 03:08:56 tgurr Exp $

inherit eutils kde

DESCRIPTION="KDing is a KDE port of Ding, a dictionary lookup program."
HOMEPAGE="http://www.rexi.org/software/kding/"
SRC_URI="http://www.rexi.org/downloads/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

need-kde 3.5

LANGS="de"
LANGS_DOC="de en"

for X in ${LANGS} ${LANGS_DOC} ; do
	IUSE="${IUSE} linguas_${X}"
done

src_unpack() {
	kde_src_unpack

	cd "${S}"
	elibtoolize

	epatch "${FILESDIR}/limit-results.patch"

	local MAKE_LANGS
	cd "${WORKDIR}/${P}/po"
	for X in ${LANGS} ; do
		use linguas_${X} && MAKE_LANGS="${MAKE_LANGS} ${X}.po"
	done
	sed -i -e "s:POFILES =.*:POFILES = ${MAKE_LANGS}:" Makefile.am

	MAKE_LANGS=""
	cd "${WORKDIR}/${P}/doc"
	for X in ${LANGS_DOC} ; do
		use linguas_${X} && MAKE_LANGS="${MAKE_LANGS} ${X}"
	done
	sed -i -e "s:SUBDIRS =.*:SUBDIRS = ${MAKE_LANGS}:" Makefile.am
	rm -f "${S}"/configure
}
