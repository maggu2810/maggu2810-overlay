# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

MY_PN="${PN}-soft"

DESCRIPTION="OpenAL Soft is a cross-platform software implementation of the OpenAL 3D audio API. The Open Audio Library is an open, vendor-neutral, cross-platform API for interactive, primarily spatialized audio"
HOMEPAGE="http://kcat.strangesoft.net/openal.html"
SRC_URI="http://kcat.strangesoft.net/openal-releases/${MY_PN}-${PV}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="alsa oss debug"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0.2 )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.0"

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	local myconf=""

	use alsa || myconf="${myconf} -DALSA=OFF"
	use oss || myconf="${myconf} -DOSS=OFF"
	use debug && myconf="${myconf} -DCMAKE_BUILD_TYPE=Debug"
	
	cd "${S}/CMakeConf"
	cmake	-D CMAKE_INSTALL_PREFIX=/usr \
			-D CMAKE_C_FLAGS:STRING="${CFLAGS}" ${myconf} ..  \
				|| die "cmake failed"
	emake || die "emake failed"
	cd "${S}"
}

src_install() {
	cd "${S}/CMakeConf"
	emake install DESTDIR="${D}" || die "emake install failed"
	cd "${S}"
	dodoc alsoftrc.sample
	insinto /usr/lib
	doins "${FILESDIR}/libopenal.la"
}

pkg_postinst() {
	einfo If you have performance problems using this library then
	einfo 'try add these lines to your ~/.alsoftrc config file:'
	einfo [alsa]
	einfo mmap = off
}
