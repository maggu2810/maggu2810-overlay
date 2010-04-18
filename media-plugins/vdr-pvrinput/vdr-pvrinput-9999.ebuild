# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-pvrinput/vdr-pvrinput-2010.04.03_rc1.ebuild,v 1.2 2010/04/11 14:00:16 hd_brummy Exp $

EAPI="2"

inherit vdr-plugin eutils versionator

MY_PV=$(replace_all_version_separators '-')
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == "9999" ]] ; then
        EGIT_REPO_URI="git://projects.vdr-developer.org/vdr-plugin-pvrinput.git"
		EGIT_PROJECT="pvrinput"
		inherit git
        KEYWORDS=""
else
		SRC_URI="http://projects.vdr-developer.org/attachments/download/278/${MY_P}.tgz"
        KEYWORDS="~x86"
fi

DESCRIPTION="VDR Plugin: Use a PVR* card as input device"
HOMEPAGE="http://projects.vdr-developer.org/projects/show/plg-pvrinput"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P#vdr-}"

src_prepare() {
	vdr-plugin_src_prepare

	fix_vdr_libsi_include reader.c
}

src_install() {
	vdr-plugin_src_install

	dodoc TODO FAQ example/channels.conf_*
}
