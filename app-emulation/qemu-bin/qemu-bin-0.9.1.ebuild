# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Multi-platform & multi-targets cpu emulator and dynamic translator"
HOMEPAGE="http://fabrice.bellard.free.fr/qemu/"
SRC_URI="${HOMEPAGE}${P/-bin/}-i386.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND="${DEPEND}"

#S=${WORKDIR}/${P/-bin/}
# * S: '/var/tmp/portage/app-emulation/qemu-bin-0.9.1/work/qemu-0.9.1'
# * P: 'qemu-bin-0.9.1'
# * PV: '0.9.1'
# * WORKDIR: '/var/tmp/portage/app-emulation/qemu-bin-0.9.1/work'

src_install() {
        cp -pPR . "${D}/" || die "failed to copy"
}
