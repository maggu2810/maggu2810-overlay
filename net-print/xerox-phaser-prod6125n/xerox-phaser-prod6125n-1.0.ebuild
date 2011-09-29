# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator rpm

MY_PV=1.0
MY_P=Fuji_Xerox-DocuPrint_C525_A_AP-${MY_PV}-1.i386

SRC_URI="http://suse.osuosl.org/suse/i386/9.2/suse/src/${MY_P}.src.rpm"
DESCRIPTION="Fuji-Xerox DPC525A CUPS driver"
HOMEPAGE="http://www.fujixerox.com.au/support/downloaddriver?productId=307&operatingSystemCode=Linux"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
SRC_URI="${MY_P}.rpm"

RESTRICT="fetch strip"

# Need to test if the file can be unpacked with rpmoffset and cpio
# If it can't then set:

#DEPEND="app-arch/rpm"

# To force the use of rpmoffset and cpio instead of rpm2cpio from
# app-arch/rpm, then set the following:

#USE_RPMOFFSET_ONLY=1

src_install() {
	        cp -pPR * "${D}"/ || die "installing data failed"
}
