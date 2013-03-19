# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="3"

inherit cmake-utils eutils flag-o-matic games git-2 wxwidgets

DESCRIPTION="A gamecube/wii/triforce emulator."
HOMEPAGE="http://www.dolphin-emu.com/"
SRC_URI=""
EGIT_REPO_URI="http://code.google.com/p/dolphin-emu/"
EGIT_PROJECT="dolphin-emu"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa ao bluetooth doc encode +lzo openal opencl opengl portaudio pulseaudio +wxwidgets +xrandr"
RESTRICT=""

RDEPEND=">=media-libs/glew-1.5
	>=media-libs/libsdl-1.2[joystick]
	sys-libs/readline
	x11-libs/libXext
	>=x11-libs/wxGTK-2.8
	<media-libs/libsfml-2.0
	ao? ( media-libs/libao )
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez )
	encode? ( media-video/ffmpeg[encode] )
	lzo? ( dev-libs/lzo )
	openal? ( media-libs/openal )
	opencl? ( || ( media-libs/mesa[opencl]
			x11-drivers/nvidia-drivers
			x11-drivers/ati-drivers ) )
	opengl? ( virtual/opengl )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	xrandr? ( x11-libs/libXrandr )
	virtual/jpeg
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	dev-util/cmake
	virtual/pkgconfig
	media-gfx/nvidia-cg-toolkit"

#src_prepare() {
#	epatch "${FILESDIR}/linking_cg_cggl.patch"
#cmake-utils_src_prepare
#}
src_configure() {
	# Configure cmake
	mycmakeargs="
		-DDOLPHIN_WC_REVISION=9999
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DCMAKE_INCLUDE_PATH=/opt/nvidia-cg-toolkit/include
		-DCMAKE_LIBRARY_PATH=/opt/nvidia-cg-toolkit/lib
		-DwxWidgets_ROOT_DIR=/usr/lib
		-Dprefix=${GAMES_PREFIX}
		-Ddatadir=${GAMES_DATADIR}/${PN}
		-Dplugindir=$(games_get_libdir)/${PN}
		$(cmake-utils_use portaudio)
		$(cmake-utils_use !wxwidgets DISABLE_WX)
		$(cmake-utils_use encode ENCODE_FRAMEDUMPS)"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	# copy files to target installation directory
	cmake-utils_src_install

	# set binary name
	local binary="${PN}"
	use wxwidgets || binary+="-nogui"

	# install documentation as appropriate
	cd "${S}"
	dodoc Readme.txt
	if use doc; then
		doins -r docs
	fi

	# create menu entry for GUI builds
	if use wxwidgets; then
		doicon Source/Core/DolphinWX/resources/Dolphin.xpm || die
		make_desktop_entry "${binary}" "Dolphin" "Dolphin" "Game;Emulator"
	fi

	prepgamesdirs
}

pkg_postinst() {
	echo
	if ! use portaudio; then
		ewarn "If you need to use your microphone for a game, rebuild with USE=portaudio"
		echo
	fi
	if ! use wxwidgets; then
		ewarn "Note: It is not currently possible to configure Dolphin without the GUI."
		ewarn "Rebuild with USE=wxwidgets to enable the GUI if needed."
		echo
	fi

	games_pkg_postinst
}
