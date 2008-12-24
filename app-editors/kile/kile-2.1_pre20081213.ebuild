# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_KDE="4.1"
KDE_LINGUAS="ar be bg ca da de el en_GB eo es et eu fi fr ga gl hi hu it ja km
lt lv nb nds nl nn oc pl pt pt_BR ro ru se sk sl sv tr uk zh_CN zh_TW"
inherit eutils subversion kde4-base
SLOT="4.1"

DESCRIPTION="A Latex Editor and TeX shell for kde"
HOMEPAGE="http://kile.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/extragear/office/${PN}/@{${PV/2.1_pre/}}"
DEPEND="dev-lang/perl"
RDEPEND="virtual/tex-base
	virtual/latex-base"

# Suggestions:
# app-text/acroread: Display pdf files
# app-text/dvipdfmx: Convert dvi files to pdf
# app-text/dvipng: Convert dvi files to png
# app-text/ghostscript-gpl: Display ps files
# dev-tex/latex2html: Compile latex files as html
# kde-base/okular: View document files
# media-gfx/imagemagick: ?
#PDEPEND="
#	app-text/acroread
#	app-text/dvipdfmx
#	app-text/dvipng
#	app-text/ghostscript-gpl
#	dev-tex/latex2html
#	kde-base/okular:${SLOT}
#	media-gfx/imagemagick"

src_unpack() {
        subversion_src_unpack
        subversion_wc_info
	cd "${S}"
        epatch "${FILESDIR}/collisions.patch"
	mv "${S}/src/data/icons/actions/hi64-action-preview.png" \
		"${S}/src/data/icons/actions/hi64-action-preview_kile.png"
}
