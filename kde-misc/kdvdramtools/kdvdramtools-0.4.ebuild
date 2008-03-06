# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="KDVD-RAM is a tool collection for DVD, DVD-RAM and BD."
HOMEPAGE="http://www.multimedia4linux.de/dvd-ram/index.html"
SRC_URI="http://www.multimedia4linux.de/dvd-ram/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="dolphin d3lphin konqueror doc"

DEPEND=""
RDEPEND="${DEPEND}
		>=kde-base/kommander-3.5
                >=sys-fs/udftools-1.0.0b-r3
		>=app-cdr/dvd+rw-tools-7.0
		>=sys-apps/hal-0.5.9"

src_install() {
	export KDEDIR="$(kde-config --prefix)"
	
        if use konqueror; then
		insinto ${KDEDIR}/share/apps/konqueror/servicemenus
		doins media_dvd*.desktop
        fi
	
        if use dolphin; then
		insinto ${KDEDIR}/share/apps/dolphin/servicemenus
		doins media_dvd*.desktop
        fi
	
        if use d3lphin; then
		insinto ${KDEDIR}/share/apps/d3lphin/servicemenus
		doins media_dvd*.desktop
        fi
	
	insinto ${KDEDIR}/share/templates
	doins linkDVDRAMWRITER.desktop
	
	insinto ${KDEDIR}/share/templates/.source
	doins DVDRAMWRITER-Device.desktop
	
	exeinto ${KDEDIR}/bin
	doexe src/*.sh src/*.kmdr
	
	#insinto ${KDEDIR}/share/locale/de/LC_MESSAGES
	#doins po/de/*.mo
	domo po/de/*.mo
	
	insinto ${KDEDIR}/share/icons/default.kde/32x32/devices
	doins icons/32x32/*.png
	
	insinto ${KDEDIR}/share/icons/default.kde/48x48/devices
	doins icons/48x48/*.png
	
	insinto ${KDEDIR}/share/icons/default.kde/64x64/devices
	doins icons/64x64/*.png

	if use doc; then
	        dodir /usr/share/doc/${PF}/html
		cp -PR doc/* "${D}"/usr/share/doc/${PF}/html/

		#docinto ${KDEDIR}/share/doc/kde/HTML/en/kdvd-ram-tools
		#dodoc doc/uk/index.docbook doc/uk/index.cache.bz2 doc/uk/*.png
		#insinto ${KDEDIR}/share/doc/kde/HTML/en/kdvd-ram-tools
		#dodoc doc/uk/*
		#docinto ${KDEDIR}/share/doc/kde/HTML/de/kdvd-ram-tools
		#dodoc doc/de/index.docbook doc/de/index.cache.bz2 doc/de/*.png
		#insinto ${KDEDIR}/share/doc/kde/HTML/de/kdvd-ram-tools
		#dodoc doc/de/*
	fi
}

pkg_postinst() {
#        if ! kernel_is ge 2 6 22; then
		einfo "If you want use DVD-RAM please install Linux 2.6.22 or higher."
		einfo "Older releases have bugs in the UDF filesystem."
		einfo "If you want use packet writing than install Linux 2.6.20 or higher."
		einfo "For writing files bigger than 1GB you need Linux 2.6.22!"
		einfo "For more informations see http://kernelnewbies.org/Linux26Changes, Known Linux Bugs)"
#        fi
}
