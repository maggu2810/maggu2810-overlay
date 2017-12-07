# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# ------------------------------------------------------------------------
#                                                                        -
#  Created by Maxxim                                                     -
#  Date: 12/06/17                                                        -
#                                                                        -
# ------------------------------------------------------------------------

#
# TODO:
# - Add support for x86
# - Check if there is any documentation available on required versions of dependencies
#   (maybe check RPM/DEB packages?)
#
# DONE:
# - Find out new download URI
#   -> 'dl.tvcdn.de' according to TV devs
# - Check if licenses changed
#   -> TeamViewer, MIT
# - Check if TeamViewer actually needs all files/folders of tv_bin (e.g. desktop)
#   -> yes, according to TV devs
# - Remove implicit dependencies (https://devmanual.gentoo.org/general-concepts/dependencies/index.html)
# - BUG: system tray icon not displayed (empty space only)
#   -> icons have to be named "TeamViewer.png" (not teamviewer)
#

EAPI=6

# Import eutils (required for newicon, make_desktop_entry)
inherit eutils

# Determine major version (required to determine download URL)
MY_MV=${PV/\.*}

# Strip '-bin' from package name
MY_PN=${PN/-bin/}

# Application name (used for menu entry)
MY_AN="TeamViewer"

# Package information
DESCRIPTION="All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="https://www.teamviewer.com"
#SRC_URI="https://download.teamviewer.com/download/version_${MY_MV}x/${MY_PN}_${PV}_amd64.tar.xz"
#SRC_URI="https://download.teamviewer.com/download/linux/teamviewer_amd64.tar.xz"
SRC_URI="https://dl.tvcdn.de/download/linux/version_${MY_MV}x/${MY_PN}_${PV}_amd64.tar.xz"
SLOT=0
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

# Licenses (TeamViewer, xdg-utils)
LICENSE="TeamViewer MIT"

# Required dependencies (provided by 'tv-setup checklibs' from archive)
RDEPEND="
	app-arch/snappy
	dev-db/sqlite
	dev-libs/double-conversion
	dev-libs/icu
	dev-libs/leveldb
	dev-libs/libbsd
	dev-qt/qtcore
	dev-qt/qtdbus
	dev-qt/qtdeclarative
	dev-qt/qtgui
	dev-qt/qtnetwork
	dev-qt/qtopengl
	dev-qt/qtsql
	dev-qt/qtwebkit
	dev-qt/qtwidgets
	dev-qt/qtx11extras
	media-gfx/graphite2
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/mesa
	sys-apps/dbus
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXxf86vm
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxshmfence
"

# Omitted implicit dependencies (generated using 'emerge -ep --nodeps @system' within untouched stage3 tarball chroot)
#RDEPEND="
#	app-arch/bzip2
#	dev-libs/expat
#	dev-libs/glib
#	dev-libs/libpcre
#	dev-libs/libxml2
#	dev-libs/libxslt
#	dev-libs/openssl
#	sys-devel/gcc
#	sys-libs/glibc
#	sys-libs/zlib
#"


# Silence QA messages
QA_PREBUILT="opt/${MY_PN}/*"

# Set temporary build directory to subdirectory of archive
S=${WORKDIR}/${MY_PN}


src_prepare() {
	default

	# Switch operation mode from 'portable' to 'installed'
	sed -i 's/TAR_NI/TAR_IN/g' tv_bin/script/tvw_config || die

	# Change user local share folder name from 'teamviewer13' to 'teamviewer'
	# TODO: ~/.local/share/teamviewer13/logfiles still gets created
	# NOTE: not officially supported and discouraged by TeamViewer devs
	#sed -i 's/teamviewer13/teamviewer/g' tv_bin/script/tvw_config || die
}


src_install() {

	# Define install destination
	local dst="/opt/${MY_PN}"

	# Install main application
	insinto ${dst}
	doins -r tv_bin

	# Set permissions for executables
	for exe in $(find tv_bin -type f -executable); do
		#elog "$exe -> ${dst}/${exe}"
		fperms 755 ${dst}/${exe}
	done

	# Set permissions for libraries
	for lib in $(find tv_bin -type f -name '*.so*'); do
		#elog "$lib -> ${dst}/${lib}"
		fperms 755 ${dst}/${lib}
	done

	# Install daemon init script and config
	newinitd ${FILESDIR}/${MY_PN}d.init ${MY_PN}d
	#newconfd ${FILESDIR}/${MY_PN}d.conf ${MY_PN}d

	# Install dbus services
	# TODO: is there a better way than hard-coded paths for this?
	insinto /usr/share/dbus-1/services
	doins tv_bin/script/com.teamviewer.TeamViewer.service
	doins tv_bin/script/com.teamviewer.TeamViewer.Desktop.service

	# Install polkit policy
	# TODO: is there a better way than hard-coded paths for this?
	insinto /usr/share/polkit-1/actions
	doins tv_bin/script/com.teamviewer.TeamViewer.policy

	# Create directory and symlink for global config
	keepdir /etc/${MY_PN}
	dosym /etc/${MY_PN} ${dst}/config

	# Create directory and symlink for log files
	keepdir /var/log/${MY_PN}
	dosym /var/log/${MY_PN} ${dst}/logfiles

	# Install symlink to executable
	dodir /opt/bin
	dosym ${dst}/tv_bin/script/${MY_PN} /opt/bin/${MY_PN}

	# Install application icons
	for size in 16 24 32 48 256; do
		#newicon -s $size tv_bin/desktop/${MY_PN}_$size.png ${MY_PN}.png
		newicon -s $size tv_bin/desktop/${MY_PN}_$size.png ${MY_AN}.png
	done

	# Install documents
	for doc in $(find doc -type f); do
		dodoc $doc
	done

	# Create application menu entry
	make_desktop_entry ${MY_PN} ${MY_AN} ${MY_PN}

}


pkg_postinst() {
	elog "Before using TeamViewer, you need to start its daemon:"
	elog "# /etc/init.d/teamviewerd start"
	elog ""
	elog "You might want to add teamviewerd to the default runlevel:"
	elog "# rc-update add teamviewerd default"
	elog ""
	elog "To display additional command line options simply run:"
	elog "# teamviewer help"
}
