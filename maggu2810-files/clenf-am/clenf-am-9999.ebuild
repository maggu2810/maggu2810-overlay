# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Yet another automounter - works also with dm-crypt-luks, ntfs3g, ..."
HOMEPAGE="I have no home :-("

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

IUSE=""

RDEPEND="sys-fs/udev
	 sys-fs/cryptsetup
	 sys-fs/ntfs3g"

src_install() {
        insopts -m 0755 -o root -g root
        insinto /usr/sbin
        doins "${FILESDIR}/clenf-am"
}
