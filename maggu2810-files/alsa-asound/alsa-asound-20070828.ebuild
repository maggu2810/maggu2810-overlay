# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A custom asound.conf file for upmix, low-pass filter, etc."

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

IUSE=""

RDEPEND="media-plugins/blop
	 media-libs/ladspa-cmt"

src_install() {
        insopts -m0640 -o root -g audio
        insinto /etc
        doins "${FILESDIR}/asound.conf"
}
