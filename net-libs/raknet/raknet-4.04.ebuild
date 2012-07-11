# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils

DESCRIPTION="Multiplayer game network engine"
HOMEPAGE="http://www.jenkinssoftware.com/"
SRC_URI="http://www.raknet.com/raknet/downloads/RakNet_PC-${PV}.zip"
LICENSE="CCPL-Attribution-NonCommercial-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs boost mysql fmod ogre ois portaudio postgres scaleform speex irrlicht"

RDEPEND="speex? ( media-libs/speex )
	boost? ( dev-libs/boost )
	fmod? ( media-libs/fmod )
	mysql? ( virtual/mysql )
	ogre? ( dev-games/ogre )
	ois? ( dev-games/ois )
	portaudio? ( media-libs/portaudio )
	postgres? ( dev-db/postgresql-base )
	irrlicht? ( dev-games/irrlicht )"
DEPEND="${RDEPEND}
    app-arch/unzip
	sys-devel/libtool
	virtual/pkgconfig"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-fix-install-dirs.patch

	# disable examples completely (DISABLE_EXAMPLES seems not to be enough)
	sed -i -e \
		's:add_subdirectory(DependentExtensions):#add_subdirectory(DependentExtensions):g' \
		"${S}"/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_EXAMPLES=ON
		-DCMAKE_INSTALL_PREFIX=/usr/
	)

	mycmakeargs+=(
			$(cmake-utils_use !static-libs DISABLE_STATICLIB)
			$(cmake-utils_use boost USEBOOST)
			$(cmake-utils_use mysql USEMYSQL)
			$(cmake-utils_use fmod USEFMOD)
			$(cmake-utils_use ogre USEOGRE3D)
			$(cmake-utils_use ois USEOIS)
			$(cmake-utils_use portaudio USEPORTAUDIO)
			$(cmake-utils_use postgres USEPOSTGRESQL)
			$(cmake-utils_use scaleform USESCALEFORM)
			$(cmake-utils_use speex USESPEEX)
	)

	use irrlicht &&
	mycmakeargs+=(
		-DIRRLICHT=ON
		-DIRRKLANG=ON
	)
	cmake-utils_src_configure
}
