# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-2.6.27.ebuild,v 1.5 2008/10/15 20:30:19 armin76 Exp $

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="1"
inherit kernel-2
detect_version
detect_arch

KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://dev.gentoo.org/~dsd/genpatches"

EXT4_VERSION="rc9-ext4-1"
EXT4_SRC="${PV}-${EXT4_VERSION}"
EXT4_URI="http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/${EXT4_SRC}/${EXT4_SRC}.bz2"

UNIPATCH_LIST="${DISTDIR}/${EXT4_SRC}.bz2"
UNIPATCH_STRICTORDER="yes"

DESCRIPTION="Ext4 + Gentoo patchset sources"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${EXT4_URI}"

K_EXTRAEWARN="The e1000e driver is this kernel version is non-functional but
will not damage your hardware. See bug #238489 for more information"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
