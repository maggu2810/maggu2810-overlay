# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games toolchain-funcs

DESCRIPTION="Hollywood tactical shooter based on the ioquake3 engine"
HOMEPAGE="http://www.urbanterror.net/
	  http://www.www0.org/w/Optimized_executable;_builds_of_ioq3_engine_for_urt"
SRC_URI="http://www0.org/urt/ioq3-1779-urt-git-170310.tar.7z
	http://urt.hsogaming.com/mirror/currentversion/UrbanTerror_${PV/./}_FULL.zip
	ftp://ftp.snt.utwente.nl/pub/games/urbanterror/UrbanTerror_${PV/./}_FULL.zip
	http://upload.wikimedia.org/wikipedia/en/5/56/Urbanterror.svg"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="dedicated openal vorbis"

RDEPEND="curl? ( net-misc/curl )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	openal? ( media-libs/openal )
	!dedicated? ( media-libs/libsdl[X,opengl] )
	dedicated? ( media-libs/libsdl )
"

S=${WORKDIR}

src_prepare() {
	# Extract source code
	tar -xf ioq3-urt-git.tar || die "unzip failed"
	rm ioq3-urt-git.tar
	epatch "${FILESDIR}/portability.diff"
}

src_configure() {
	:
}

src_compile() {
	buildit() { use $1 && echo 1 || echo 0 ; }

	cd "${S}/ioq3-urt-git/ioq3-urt"

	emake \
		$(use amd64 && echo ARCH=x86_64) \
		BUILD_SERVER=$(buildit dedicated) \
		BUILD_CLIENT_SMP=1 \
		BUILD_GAME_SO=0 \
		BUILD_GAME_QVM=0 \
		CC="$(tc-getCC)" \
		DEFAULT_BASEDIR="${GAMES_DATADIR}/${PN}" \
		USE_CODEC_VORBIS=$(buildit vorbis) \
		USE_OPENAL=$(buildit openal) \
		USE_CURL=1 \
		USE_LOCAL_HEADERS=0 \
			|| die "emake dedicated failed"
}

src_install() {
	use amd64 && ARCH=x86_64
	use x86 && ARCH=x86

	newgamesbin \
		ioq3-urt-git/ioq3-urt/build/release-linux-${ARCH}/ioquake3-smp.${ARCH} \
		${PN}
	make_desktop_entry ${PN} "UrbanTerror" Urbanterror.svg

	if use dedicated ; then
			newgamesbin \
		    		ioq3-urt-git/ioq3-urt/build/release-linux-${ARCH}/ioquake3-smp.${ARCH} \
				${PN}-dedicated
			make_desktop_entry ${PN}-dedicated "UrbanTerror dedicated" Urbanterror.svg

			insinto "${GAMES_DATADIR}"/${PN}/q3ut4
			doins dedicated.cfg
	fi

	doicon "${DISTDIR}"/Urbanterror.svg
	cd "${S}"/UrbanTerror/q3ut4
	dodoc readme41.txt

	# fix case sensitivity
	mv demos/tutorial.dm_68 demos/TUTORIAL.dm_68

	insinto "${GAMES_DATADIR}"/${PN}/q3ut4
	doins -r *.pk3 autoexec.cfg demos/ description.txt mapcycle.txt screenshots/

	prepgamesdirs
}
