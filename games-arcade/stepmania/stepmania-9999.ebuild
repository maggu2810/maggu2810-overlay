# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils cvs games autotools eutils

DESCRIPTION="An advanced DDR simulator"
HOMEPAGE="http://www.stepmania.com/stepmania/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc"
IUSE="debug gtk jpeg mp3 ffmpeg theora vorbis force-oss net png profiling"

ECVS_SERVER="stepmania.cvs.sourceforge.net:/cvsroot/stepmania"
ECVS_MODULE="stepmania"
ECVS_AUTH="pserver"
ECVS_USER="anonymous"

RESTRICT="test"

DEPEND="gtk? ( >=x11-libs/gtk+-2.0 )
	mp3? ( media-libs/libmad )
	>=dev-lang/lua-5.0
	media-libs/libsdl
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	sys-libs/zlib
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20061016 )
	vorbis? ( media-libs/libvorbis )
	theora? ( media-libs/libtheora)
	virtual/opengl"

S=${WORKDIR}/${ECVS_MODULE}							

src_unpack() {
	cvs_src_unpack ${A}
	cd "${S}"

	AT_M4DIR="autoconf/m4" eautoreconf
}

src_compile() {

	econf \
		--disable-dependency-tracking \
		$(use_with debug) \
		$(use_with jpeg) \
		$(use_with vorbis) \
		$(use_with mp3) \
		$(use_with net networking) \
		$(use_with theora) \
		$(use_with ffmpeg) \
		$(use_with png) \
		$(use_with profiling) \
		$(use_enable gtk gtk2) \
		$(use_enable force-oss) \
		|| die "Configure Failed"

	emake || die "emake failed"
}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	dodir ${dir}
	exeinto ${dir}
	doexe src/stepmania || die "Install failed"
	if use gtk; then
		doexe src/GtkModule.so || die "Install failed"
	fi

	cd "${WORKDIR}"/stepmania

	insinto ${dir}

	
	doins -r Announcers BackgroundEffects BackgroundTransitions BGAnimations \
		CDTitles Characters Courses Data Docs \
		NoteSkins Packages RandomMovies Songs \
		Themes || die "Install failed"

	make_desktop_entry "${PN}" Stepmania
	
	 newicon "Themes/default/Graphics/Common window icon.png" ${PN}.png
		 
	 games_make_wrapper ${PN} "${dir}"/"${PN}" "${dir}" 
			 
	prepgamesdirs

}

