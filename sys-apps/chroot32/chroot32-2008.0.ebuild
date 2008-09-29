# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

STAGE3="stage3-i686-${PV}.tar.bz2"

DESCRIPTION="Gentoo chroot environment for i686"
HOMEPAGE="http://www.gentoo.org/proj/en/base/amd64/howtos/chroot.xml"
SRC_URI="http://distfiles.gentoo.org/releases/x86/${PV}/stages/${STAGE3}"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="|| ( sys-apps/setarch sys-apps/util-linux )"


src_unpack() {
	tar -xjpf ${DISTDIR}/${STAGE3} --totals
}

src_compile() {
	:
}

INSTALLDIR="/usr/lib/chroot32"

src_install() {
	dodir "${INSTALLDIR}"
	mv * "${D}/${INSTALLDIR}" || die "Cannot move stage3 files"
	mkdir "${D}/${INSTALLDIR}/usr/portage"

	cd "${FILESDIR}"
	insinto "${INSTALLDIR}/etc"
	doins "make.conf"

	exeinto "/etc/init.d"
	newexe "chroot32.init" "chroot32"

	dobin "chroot32"
}

pkg_postinst() {
	rc-update add chroot32 default
	/etc/init.d/chroot32 start
	linux32 chroot ${INSTALLDIR} /bin/bash -c "
		source /etc/profile
		env-update
		emerge -1v portage
		emerge -uvDN @system @world
	"
	einfo "To change to your chroot, execute 'chroot32'"
	einfo "Remember to run 'xhost local:localhost' from the host system
		if you want to execute X applications."
}

pkg_prerm() {
	rc-update del chroot32
	/etc/init.d/chroot32 stop
	mount | grep -q chroot32 && \
		die "Cannot uninstall while filesystems are mounted inside chroot"
	einfo "Cleaning tmp, cache and log directories ..."
	for f in tmp usr/tmp var/cache var/log; do
		rm -rf ${INSTALLDIR}/$f
	done
	for f in resolv.conf passwd shadow group gshadow hosts localtime; do
		rm -f ${INSTALLDIR}/etc/$f
	done
	einfo "Unmerging ..."
}
