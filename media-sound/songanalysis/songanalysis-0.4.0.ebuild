# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvsd/root/portage/media-sound/songanalysis/songanalysis-0.4.0.ebuild,v 1.1 2007/03/16 16:44:11 oliver Exp $

inherit eutils
DESCRIPTION="This program analyzes a song and produces an output consisting of the volume differential, the relative strength in each frequency band, and the tempo."

HOMEPAGE="http://rudd-o.com/projects/songanalysis/"
SRC_URI="http://rudd-o.com/wp-content/projects/files/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="mp3 vorbis"

DEPEND="sci-libs/gsl"

RDEPEND="mp3? ( media-sound/mpg321 )
	vorbis? ( media-sound/vorbis-tools )"

src_install() {
	einstall || die
}