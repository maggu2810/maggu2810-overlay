# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: #

inherit eutils linux-info linux-mod python

DESCRIPTION="CD drive emulator (can read bin/cue/ccd/iso/mds/nrg files)"
HOMEPAGE="http://cdemu.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="udev"

RDEPEND="dev-lang/python
	udev? ( sys-fs/udev )"
DEPEND=""

pkg_setup() {
	MODULE_NAMES="${PN}"
	linux-mod_pkg_setup

	if kernel_is lt 2 6 16 ; then
		die ">=app-cdr/cdemu-0.8 requires a kernel >= 2.6.16"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/kernel.patch"
}

src_compile() {
	# Need to unset ARCH or Bad Things (tm) will happen.
	# See: http://www.openafs.org/pipermail/openafs-devel/2005-June/012325.html
	# and: http://linuxfromscratch.org/pipermail/livecd/2005-September/001613.html
	# or Google for it: http://www.google.com/search?hl=en&q=%22arch%2Fx86%2FMakefile%22+%22no+such+file%22&btnG=Google+Search
	unset ARCH
	make mrproper || die "make mrproper failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use udev ; then
		# The docs cannot decide whether to use a subdirectory, so do both,
		# as with /dev/loop/n and /dev/loopn.
		echo 'KERNEL=="cdemu*", NAME="cdemu/%n", SYMLINK="%k", GROUP="cdrom", MODE="0660"' > 99-${PN}.rules
		insinto /etc/udev/rules.d
		doins 99-${PN}.rules || die
	fi

	# The INSTALL and README docs are out-of-date
	dodoc AUTHORS ChangeLog TODO
}

pkg_postinst() {
	linux-mod_pkg_postinst
	python_mod_optimize

	elog "Users of cdemu must be in the 'cdrom' group."
	echo
}

pkg_postrm() {
	linux-mod_pkg_postrm
	python_mod_cleanup
}
