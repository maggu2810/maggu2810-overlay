# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

SRC="ManiaDrive-${PV}-src"
DATA="ManiaDrive-${PV}-data"
ODE="ode.tar.gz"
PHP="php5.2-latest.tar.gz"

DESCRIPTION="ManiaDrive is a clone of Trackmania: 3D, stunts and skills!"
HOMEPAGE="http://maniadrive.raydium.org/"
SRC_URI="mirror://sourceforge/${PN}/${SRC}.tar.gz
	mirror://sourceforge/${PN}/${DATA}.tar.gz
	http://freeway.raydium.org/data/stable_mirrors/${ODE}
	http://snaps.php.net/${PHP}"

LICENSE="CCPL-Attribution-2.0
	GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/openal
	media-libs/freealut
	media-libs/libvorbis
	media-libs/libogg
	media-libs/jpeg
	virtual/glu
	media-libs/glew
	sys-devel/bison
	net-misc/curl
	dev-libs/libxml2"

S=${WORKDIR}/${SRC}
RAY=${S}/raydium
dir=${GAMES_DATADIR}/${PN}

src_unpack() {
	unpack "${DATA}.tar.gz"
	unpack "${SRC}.tar.gz"


	# copy ode
	cp ${DISTDIR}/${ODE} ${RAY} || die
	
	# unpack ode
	cd ${RAY}
	unpack ${ODE}
	

	# copy php
	cp ${DISTDIR}/${PHP} ${RAY} || die

	# unpack php
	cd ${RAY}
	unpack ${PHP}

	# rename the php folder
	mv php5.2-[0-9]* php


	# apply patches
	cd "${S}"
	epatch ${FILESDIR}/ocomp.patch

	# Copy game data in build directory
	#cp -r "${WORKDIR}/${DATA}"/game/* "${S}" || die

	# Change version to allow to send scores
	#sed -i "s/ManiaDrive ${PV}custom/ManiaDrive ${PV}/" mania_drive.c || die 'sed failed'
}

src_compile() {
	# now compile ode
	cd ${RAY}/ode
	echo '	# Raydium ODE autoconfig
		PLATFORM=unix-gcc
		PRECISION=SINGLE
		BUILD=release
		WINDOWS16=0
		OPCODE_DIRECTORY=OPCODE
	' > config/user-settings

	emake configure || die "'emake configure' for ode failed"

	echo '	#ifndef dEpsilon
		#define dEpsilon FLT_EPSILON
		#endif
	' >> include/ode/config.h

	emake || die "'emake' for ode failed"


	# now compile php
	cd ${RAY}/php
    	econf	--enable-embed=static \
		--with-zlib \
		--enable-ftp \
		--enable-static=zlib \
		--with-curl \
		--disable-simplexml \
		--disable-xmlreader \
		--disable-xmlwriter \
		--enable-soap || die "'econf' for php failed"

	emake || die "'emake' for php failed"


	# no compile raydium
	cd ${S}
	emake || die "emake failed"



	# The Makefile compiles only the engine (raydium).
	# We can compile the game binaries with the ocomp script
	# (static using ode).
	local f
	for f in mania{_drive,_server,2}.c ; do
		./ocomp.sh "${f}" || die "ocomp.sh ${f} failed"
	done
}

src_install() {
	local f
	for f in mania{_drive,_server,2} ; do
		newgamesbin "${S}/${f}" "${f}.bin" \
			|| die "newgamesbin ${f} failed"
		games_make_wrapper "${f}" "${f}.bin" "${dir}"
	done

	insinto "${dir}"
	doins -r "${WORKDIR}/${DATA}"/game/*

	dodoc "${WORKDIR}/${DATA}"/README
	einfo "wait"
}
