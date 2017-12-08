# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Import eutils (newicon, make_desktop_entry), systemd (systemd_dounit), gnome2-utils (gnome2_icon_cache_update)
inherit eutils systemd gnome2-utils

# Determine major version (required to determine download URL)
MY_MV=${PV/\.*}

# Strip '-bin' from package name
MY_PN=${PN/-bin/}

# Application name (used for menu entry, icon file names)
MY_AN="TeamViewer"

# Package information
DESCRIPTION="All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="https://www.teamviewer.com"
SRC_URI="amd64? ( https://dl.tvcdn.de/download/linux/version_${MY_MV}x/${MY_PN}_${PV}_amd64.tar.xz )
         x86? ( https://dl.tvcdn.de/download/linux/version_${MY_MV}x/${MY_PN}_${PV}_i386.tar.xz )"
SLOT=0
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror"

# Licenses (TeamViewer, bundled xdg-utils)
LICENSE="TeamViewer MIT"

# Required dependencies
# TODO: versions, differences for amd64/x86
RDEPEND="app-arch/snappy
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
         dev-qt/qtquickcontrols
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
         x11-libs/libxshmfence"

# Silence QA messages
QA_PREBUILT="opt/${MY_PN}/*"

# Set temporary build directory to subdirectory of archive
S=${WORKDIR}/${MY_PN}


src_prepare() {

	# Call default handler (mandatory, handles PATCHES and user patches)
	default

	# Switch operation mode from 'portable' to 'installed'
	sed -i 's/TAR_NI/TAR_IN/g' tv_bin/script/tvw_config || die

}


src_install() {

	# Define install destination
	local dst="/opt/${MY_PN}"

	# Install application files/ressources
	insinto ${dst}
	doins -r tv_bin

	# Restore permissions for executables
	for exe in $(find tv_bin -type f -executable); do
		fperms 755 ${dst}/${exe}
	done

	# Restore permissions for libraries
	for lib in $(find tv_bin -type f -name '*.so*'); do
		fperms 755 ${dst}/${lib}
	done

	# Install daemon init script and systemd service
	newinitd ${FILESDIR}/${MY_PN}d.init ${MY_PN}d
	systemd_dounit tv_bin/script/teamviewerd.service

	# Install dbus services
	insinto /usr/share/dbus-1/services
	doins tv_bin/script/com.teamviewer.TeamViewer.service
	doins tv_bin/script/com.teamviewer.TeamViewer.Desktop.service

	# Install polkit policy
	insinto /usr/share/polkit-1/actions
	doins tv_bin/script/com.teamviewer.TeamViewer.policy

	# Install application icons
	for size in 16 24 32 48 256; do
		newicon -s $size tv_bin/desktop/${MY_PN}_$size.png ${MY_AN}.png
	done

	# Install documents
	for doc in $(find doc -type f); do
		dodoc $doc
	done

	# Create directory and symlink for global config
	keepdir /etc/${MY_PN}
	dosym /etc/${MY_PN} ${dst}/config

	# Create directory and symlink for log files
	keepdir /var/log/${MY_PN}
	dosym /var/log/${MY_PN} ${dst}/logfiles

	# Create symlinks to main executables in /opt/bin
	dodir /opt/bin
	dosym ${dst}/tv_bin/${MY_PN}d /opt/bin/${MY_PN}d
	dosym ${dst}/tv_bin/script/${MY_PN} /opt/bin/${MY_PN}

	# Create application menu entry
	make_desktop_entry ${MY_PN} ${MY_AN} ${MY_AN}

}


pkg_postinst() {

	# Update Gnome icon cache (needs to be called in both pkg_postinst and pkg_postrm)
	gnome2_icon_cache_update

	# Elog notes
	elog "Before using TeamViewer, you need to start its daemon:"
	elog "OpenRC:"
	elog "# /etc/init.d/teamviewerd start"
	elog "Systemd:"
	elog "# systemctl start teamviewerd.service"
	elog ""
	elog "You might want to automatically start the daemon at boot:"
	elog "OpenRC:"
	elog "# rc-update add teamviewerd default"
	elog "Systemd:"
	elog "# systemctl enable teamviewerd.service"
	elog ""
	elog "To display additional command line options simply run:"
	elog "# teamviewer help"

}


pkg_postrm() {

	# Update Gnome icon cache (needs to be called in both pkg_postinst and pkg_postrm)
	gnome2_icon_cache_update

}
