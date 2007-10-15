# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Markus Rathgeb - maggu2810@gentooforum.de

MY_PVR="${PVR/_rc/-RC}"
MY_PF="${PN}-${MY_PVR}"

inherit eutils

DESCRIPTION="Java based Least Cost Router for Germany"

HOMEPAGE="http://www.bongosoft.de/"

SRC_URI="http://www.bongosoft.de/${MY_PF}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"

IUSE=""

#DEPEND="app-text/rpl"
DEPEND=""

RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_PF}"

pkg_setup() {
	enewgroup dialout
}

src_compile() {
	epatch "${FILESDIR}/${MY_PF}_install.patch"
}

src_install() {
	#rpl 'BONGO_INST="/usr/share/bongosurfer"' 'BONGO_INST="${PREFIX}/share/bongosurfer"' install.sh
	#rpl 'BONGO_DOC="/usr/share/doc/bongosurfer"' 'BONGO_DOC="${PREFIX}/share/doc/bongosurfer"' install.sh
	#rpl 'BONGO_CONF="/etc/bongosurfer"'  'BONGO_CONF="${GLOBAL_CONF}/bongosurfer"' install.sh
	#rpl ' /etc/' ' ${GLOBAL_CONF}/' install.sh
	#rpl ' /usr/' ' ${PREFIX}/' install.sh
	#rpl '/usr/sbin/bongosetup2 -a' '#/usr/sbin/bongosetup2 -a' install.sh
	#rpl -e 'if [ ! -d ${BONGO_INST} ]; then' 'if [ ! -d ${PREFIX}/bin ]; then\n\tinstall -vm 755 -d ${PREFIX}/bin\nfi\nif [ ! -d ${PREFIX}/sbin ]; then\n\tinstall -vm 755 -d ${PREFIX}/sbin\nfi\nif [ ! -d ${PREFIX}/share/man/man1 ]; then\n\tinstall -vm 755 -d ${PREFIX}/share/man/man1\nfi\nif [ ! -d ${PREFIX}/share/pixmaps ]; then\n\tinstall -vm 755 -d ${PREFIX}/share/pixmaps\nfi\nif [ ! -d ${BONGO_INST} ]; then' install.sh
	BASEDIR="${D}" "./install.sh" || die "Install failed"
}

pkg_postinst() {
        elog "Run \`/usr/sbin/bongosetup2 -a\` as root now to set up the correct privileges."
}
