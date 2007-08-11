# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvsd/root/portage/media-sound/amarok-scripts-meta/amarok-scripts-meta-1.0.ebuild,v 1.1 2007/03/16 16:44:11 oliver Exp $

inherit eutils

DESCRIPTION="Meta ebuild for some packages required for amarok scripts"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	dev-python/pykde
	dev-python/python-amarok
	dev-python/python-commandsplus
	dev-python/python-extattr
	dev-python/python-Observable
	media-libs/mutagen
	media-sound/mpg321
	media-sound/songanalysis
	media-sound/mp3gain"
