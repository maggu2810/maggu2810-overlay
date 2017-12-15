# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Import eutils (newicon, make_desktop_entry), systemd (systemd_dounit), gnome2-utils (gnome2_icon_cache_update)
inherit eutils systemd gnome2-utils

# Determine major version (used for download URL, log directory)
MY_MV="${PV/\.*}"

# Package information
DESCRIPTION="All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="https://www.teamviewer.com"
SRC_URI="amd64? ( https://dl.tvcdn.de/download/linux/version_${MY_MV}x/${PN}_${PV}_amd64.tar.xz -> ${PN}-${PV}_amd64.tar.xz )
         x86? ( https://dl.tvcdn.de/download/linux/version_${MY_MV}x/${PN}_${PV}_i386.tar.xz -> ${PN}-${PV}_x86.tar.xz )"
SLOT="13"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror"
IUSE=""

# Licenses (application, bundled xdg-utils)
LICENSE="TeamViewer MIT"

# Required dependencies
DEPEND="sys-apps/sed"
RDEPEND="!net-misc/teamviewer-host
         dev-qt/qtcore:5
         dev-qt/qtdbus:5
         dev-qt/qtdeclarative:5
         dev-qt/qtgui:5
         dev-qt/qtnetwork:5
         dev-qt/qtquickcontrols:5
         dev-qt/qtwebkit:5
         dev-qt/qtwidgets:5
         dev-qt/qtx11extras:5
         sys-apps/dbus"

# Silence QA messages
QA_PREBUILT="opt/teamviewer/*"

# Set temporary build directory to subdirectory of archive
S=${WORKDIR}/teamviewer


src_prepare() {

	# Call default handler (mandatory, handles PATCHES variable and user patches)
	default

	# Switch operation mode from 'portable' to 'installed'
	sed -i 's/TAR_NI/TAR_IN/g' tv_bin/script/tvw_config || die

}


src_install() {

	# Define install destination
	local dst="/opt/teamviewer"

	# Quirk:
	# Remove Intel 80386 32-bit ELF binary 'libdepend' present in all
	# archives. It will trip the 'emerge @preserved-libs' logic on amd64
	# when changing the ABI of one of its dependencies. According to the
	# TeamViewer devs, this binary is an unused remnant of previous Wine-
	# based builds and will be removed in future releases anyway
	rm tv_bin/script/libdepend

	# Install application files/resources
	insinto ${dst}
	doins -r tv_bin

	# Set permissions for executables and libraries
	for exe in $(find tv_bin -type f -executable -or -name '*.so'); do
		fperms 755 ${dst}/${exe}
	done

	# Install daemon init script and systemd service
	newinitd ${FILESDIR}/teamviewerd.init teamviewerd
	systemd_dounit tv_bin/script/teamviewerd.service

	# Install D-Bus services
	insinto /usr/share/dbus-1/services
	doins tv_bin/script/com.teamviewer.TeamViewer.service
	doins tv_bin/script/com.teamviewer.TeamViewer.Desktop.service

	# Install Polkit policy
	insinto /usr/share/polkit-1/actions
	doins tv_bin/script/com.teamviewer.TeamViewer.policy

	# Install icons
	for size in 16 24 32 48 256; do
		newicon -s ${size} tv_bin/desktop/teamviewer_${size}.png TeamViewer.png
	done

	# Install documents (NOTE: using 'dodoc -r doc' instead of loop will
	# have the undesired result of installing subdirectory 'doc' in /usr/
	# share/doc/teamviewer-<version>)
	for doc in $(find doc -type f); do
		dodoc ${doc}
	done

	# Create directory and symlink for global config
	keepdir /etc/teamviewer
	dosym /etc/teamviewer ${dst}/config

	# Create directory and symlink for log files (NOTE: according to Team-
	# Viewer devs, all paths are hard-coded in the binaries; therefore
	# using the same path as the DEB/RPM archives, i.e. '/var/log/teamviewer
	# <major-version>')
	keepdir /var/log/teamviewer${MY_MV}
	dosym /var/log/teamviewer${MY_MV} ${dst}/logfiles

	# Create symlinks to main executables in /opt/bin
	dodir /opt/bin
	dosym ${dst}/tv_bin/teamviewerd /opt/bin/teamviewerd
	dosym ${dst}/tv_bin/script/teamviewer /opt/bin/teamviewer

	# Create application menu entry
	make_desktop_entry teamviewer "TeamViewer" TeamViewer

}


pkg_postinst() {

	# Update Gnome icon cache (advised to be called in both pkg_postinst and pkg_postrm)
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

	# Update Gnome icon cache (advised to be called in both pkg_postinst and pkg_postrm)
	gnome2_icon_cache_update

}
