# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-xineliboutput/vdr-xineliboutput-1.0.0_rc2.ebuild,v 1.6 2007/09/30 14:28:07 zzam Exp $

inherit vdr-plugin eutils multilib

MY_PV=${PV/_/}
MY_P=${PN}-${MY_PV}
#TIMESTAMP=CVS-${PV##*_p}000000
#MY_P=${PN}-${TIMESTAMP}

DESCRIPTION="Video Disk Recorder Xinelib PlugIn"
HOMEPAGE="http://sourceforge.net/projects/xineliboutput/"
SRC_URI="mirror://sourceforge/${PN#vdr-}/${MY_P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE="fbcon X"

RDEPEND=">=media-video/vdr-1.3.42
		>=media-libs/xine-lib-1.1.1
		media-libs/jpeg
		X? (
			x11-proto/xextproto
			x11-proto/xf86vidmodeproto
			x11-proto/xproto
		)"

DEPEND="${RDEPEND}
		sys-kernel/linux-headers
		X? (
			x11-libs/libX11
			x11-libs/libXv
			x11-libs/libXext
		)"

#MY_PV=${PV%_p*}
#MY_PV=${MY_PV/_/}
S=${WORKDIR}/xineliboutput-${MY_PV}

VDR_CONFD_FILE=${FILESDIR}/confd-1.0.0_pre6
PATCHES="${FILESDIR}/${P}-vdr-1.5.3.diff
	${FILESDIR}/${P}-vdr-1.5.9.diff"

NO_GETTEXT_HACK=1

enable_in_makefile() {
	local opt
	for opt; do
		sed -i "/^#${opt}.*= 1/s-^#--" Makefile
	done
}

src_unpack() {
	vdr-plugin_src_unpack

	cd ${S}

	XINE_LIB_VERSION=$(awk -F'"' '/XINE_VERSION/ {print $2}' /usr/include/xine.h)

	enable_in_makefile XINELIBOUTPUT_VDRPLUGIN XINELIBOUTPUT_XINEPLUGIN
	use fbcon && enable_in_makefile XINELIBOUTPUT_FB
	use X && enable_in_makefile XINELIBOUTPUT_X11

	# patching makefile to work with this
	# $ rm ${outdir}/file; cp file ${outdir}/file
	# work in the sandbox
	sed -i Makefile \
		-e 's:XINEPLUGINDIR.*=.*:XINEPLUGINDIR = '"${WORKDIR}/lib:" \
		-e 's:VDRINCDIR.*=.*:VDRINCDIR ?= /usr/include:'
	mkdir -p ${WORKDIR}/lib

	epatch ${FILESDIR}/fullscreen.diff
}

src_install() {
	vdr-plugin_src_install

	dobin vdr-fbfe vdr-sxfe

	insinto ${VDR_PLUGIN_DIR}
	doins *.so.${MY_PV} || die "could not install sub-plugins"

	insinto /usr/$(get_libdir)/xine/plugins/${XINE_LIB_VERSION}
	doins xineplug_inp_*.so

	insinto /usr/$(get_libdir)/xine/plugins/${XINE_LIB_VERSION}/post
	doins xineplug_post_*.so
}
