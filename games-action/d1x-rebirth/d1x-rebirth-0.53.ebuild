# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

# DV is the Descent version. Used because the d2x-rebirth ebuild is similar.
DV="1"
DATE="20071022"
DVX=d${DV}x
FILE_START="${PN}_v${PV}-src-${DATE}"
SRC_STEM="http://www.dxx-rebirth.de/download/dxx"

DESCRIPTION="Descent Rebirth - enhanced Descent 1 engine"
HOMEPAGE="http://www.dxx-rebirth.de/"
SRC_URI="${SRC_STEM}/oss/src/${FILE_START}.tar.gz
	${SRC_STEM}/res/dxx-rebirth_icons.zip
	${SRC_STEM}/res/${PN}_hires-briefings.zip
	${SRC_STEM}/res/${PN}_hires-fonts.zip"

# Licence info at bug #117344. All 3 licences apply.
LICENSE="D1X
	GPL-2
	as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug demo"

QA_EXECSTACK="${GAMES_BINDIR:1}/${PN}"

# physfs is only needed for d2x-rebirth
UIRDEPEND="media-libs/alsa-lib
	>=media-libs/libsdl-1.2.9
	>=media-libs/sdl-image-1.2.3-r1
	virtual/glu
	virtual/opengl
	x11-libs/libX11"
UIDEPEND="x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	x11-proto/xproto"
# There is no ebuild for descent1-data
RDEPEND="${UIRDEPEND}
	demo? ( games-action/descent1-demodata )"
DEPEND="${UIRDEPEND}
	${UIDEPEND}
	dev-util/scons
	app-arch/unzip"

S=${WORKDIR}/${PN}
dir=${GAMES_DATADIR}/${DVX}

pkg_setup() {
	games_pkg_setup

	# Crazy-but-true fix
	einfo "To fix sandbox violations:  emerge -C scons ; emerge scons"
	einfo "See http://bugs.gentoo.org/show_bug.cgi?id=107013"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Tidy help info
	sed -i \
		-e "s:${PN}-gl/sdl:${PN}:" \
		main/inferno.c || die "sed inferno.c"
}

src_compile() {
	local opts="sdlmixer=1"
	use debug && opts="${opts} debug=1"
	use demo && opts="${opts} shareware=1"

	# From "scons -h"
	scons \
		${opts} \
		sharepath="${dir}" \
		|| die "scons"
}

src_install() {
	local icon="${PN}.xpm"
	# Reasonable set of default options. Don't bother with ${DVX}.ini file.
	local params="-gl_trilinear -gl_anisotropy 8.0 -gl_transparency -gl_reticle 2 -fullscreen -menu_gameres -hiresfont -persistentdebris -sdlmixer"

	local exe=${PN}-gl

	newgamesbin ${exe} ${PN} || die "newgamesbin ${exe}"
	games_make_wrapper ${PN}-common "${PN} ${params}"
	doicon "${WORKDIR}/${icon}" || die "doicon"
	make_desktop_entry ${PN}-common "Descent ${DV} Rebirth" "${icon}"

	insinto "${dir}"/hires
	doins "${WORKDIR}"/*.{pcx,fnt} || die

	dodoc *.txt "${WORKDIR}"/*.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use demo ; then
		elog "${PN} has been compiled specifically for the demo data."
	else
		elog "Place the DOS data files in ${dir}"
		echo
		ewarn "Re-emerge with the 'demo' USE flag if this error is shown:"
		ewarn "   Error: Not enough strings in text file"
	fi
	echo

	elog "To play the game with common options, run:  ${PN}-common"
}
