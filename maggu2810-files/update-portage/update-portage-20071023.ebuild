# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Yet another tool to update the portage tree"
HOMEPAGE="I have no home :-("

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

IUSE=""

src_install() {
        insopts -m 0755 -o root -g root
        insinto /usr/sbin
        doins "${FILESDIR}/update-portage"
}
