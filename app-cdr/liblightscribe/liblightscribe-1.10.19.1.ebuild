# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm multilib flag-o-matic toolchain-funcs

MY_P="lightscribeApplications-${PV}"
DESCRIPTION="LightScribe System Software (binary only library)."
HOMEPAGE="http://www.lightscribe.com/"
SRC_URI="http://www.lightscribe.com/downloadSection/linux/downloads/lsl/${MY_P}-linux-2.6-intel.rpm"
LICENSE="HP-LightScribe"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="multilib"

DEPEND=""

RDEPEND="virtual/libc
	x86? ( sys-libs/libstdc++-v3 )
	amd64? ( app-emulation/emul-linux-x86-compat )"

RESTRICT="mirror strip"

src_unpack() {
	rpm_src_unpack
}

src_compile() { 
	ln -sf ${WORKDIR}/usr/lib/liblightscribe.so.1 liblightscribe.so
	append-flags -I${WORKDIR}/usr/include -pthread -m32
	append-ldflags -L${WORKDIR} -lm -llightscribe
        $(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -o lsprint  \
	    ${WORKDIR}/usr/share/doc/lightscribe-sdk/sample/lsprint/bmlite.cpp \
	    ${WORKDIR}/usr/share/doc/lightscribe-sdk/sample/lsprint/lsprint.cpp || die "lsprint compile failed"
}

src_install() {
	has_multilib_profile && ABI="x86"
	
	into /opt
	dobin lsprint
	insinto /opt/liblightscribe/$(get_libdir)/lightscribe/xres
	doins ${WORKDIR}/usr/lib/lightscribe/xres/*
	insinto /opt/liblightscribe/$(get_libdir)/lightscribe/sres
	doins ${WORKDIR}/usr/lib/lightscribe/res/*
	dosym sres /opt/liblightscribe/$(get_libdir)/lightscribe/res
	exeinto /opt/liblightscribe/$(get_libdir)/lightscribe/updates
	doexe ${WORKDIR}/usr/lib/lightscribe/updates/fallback.sh
	exeinto /opt/liblightscribe/$(get_libdir)/lightscribe
	doexe ${WORKDIR}/usr/lib/lightscribe/elcu.sh
	dosed "s%/usr/lib%/opt/liblightscribe/$(get_libdir)%" /opt/liblightscribe/$(get_libdir)/lightscribe/elcu.sh
	into /opt/liblightscribe
	dolib.so ${WORKDIR}/usr/lib/liblightscribe.so.*
	dosym liblightscribe.so.1 /opt/liblightscribe/$(get_libdir)/liblightscribe.so
	insinto /usr/include/lightsribe
	doins -r ${WORKDIR}/usr/include/*
	insinto /etc
	doins -r ${WORKDIR}/etc/*
	dosed "s%/usr/lib%/opt/liblightscribe/$(get_libdir)%" /etc/lightscribe.rc
	dodoc ${WORKDIR}/usr/share/doc/*.*
	dodoc ${WORKDIR}/usr/share/doc/lightscribe-sdk/*.*
	dodoc ${WORKDIR}/usr/share/doc/lightscribe-sdk/docs/*
	docinto sample/lsprint
	dodoc ${WORKDIR}/usr/share/doc/lightscribe-sdk/sample/lsprint/*
	# cope with libraries being in /opt/liblightscribe/lib
        dodir /etc/env.d
        echo "LDPATH=/opt/liblightscribe/$(get_libdir)" > ${D}/etc/env.d/80liblightscribe

}

pkg_postinst() {
        einfo
        einfo "This version olso support Enhanced Contrast"
        einfo "You can activate it by running:"
        einfo "/opt/liblightscribe/$(get_libdir)/lightscribe/elcu.sh"
        einfo
}
