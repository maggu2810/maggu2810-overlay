# ==========================================================================
# This ebuild come from sunrise repository. Zugaina.org only host a copy.
# For more info go to http://gentoo.zugaina.org/
# ***************** General Portage Overlay (11/04/06) *****************
# ==========================================================================
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvsd/root/portage/sys-libs/pam_mount/pam_mount-0.18.ebuild,v 1.2 2006/11/05 12:28:05 root Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit eutils pam autotools

DESCRIPTION="A PAM module that can mount volumes for a user session e.g. encrypted home directories"
HOMEPAGE="http://pam-mount.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-mount/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt"

DEPEND=">=sys-libs/pam-0.78-r3
	>=dev-libs/openssl-0.9.7i
	>=dev-libs/glib-2"
RDEPEND="${DEPEND}
	crypt? ( sys-fs/cryptsetup-luks )
	sys-process/lsof"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Gentoo installs cryptsetup in /bin, this patches the relevant
	# locations, in scripts/(u)mount.crypt and adds gentoo specific
	# comments to pam_mount.conf
	epatch "${FILESDIR}/${PN}-gentoo-paths-and-examples.patch"
}

src_compile() {
	# fixes the sanity check failure
	_elibtoolize --copy --force

	econf \
	    --libdir=/$(get_libdir) \
		--with-pam-dir=$(getpam_mod_dir) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	insinto /etc/security
	insopts -m0644
	doins "${S}/config/pam_mount.conf"
	dopamd "${FILESDIR}/system-auth-pm"

	dodoc README TODO AUTHORS ChangeLog FAQ NEWS
}

pkg_postinst() {
	elog "In order to use pam_mount you will need to configure it."
	elog "After the modifications in /etc/security/pam_mount.conf you "
	elog "can create the encrypted directory using the mkehd command."
	elog "Please use mkhed -h for more informations."
	elog
	elog "If you want to encrypt the home directories you will need a "
	elog "kernel with device-mapper and crypto (AES or any other chipher)"
	elog "support."
	elog
	elog "This ebuild only modifies the /etc/pam.d/system-auth file to"
	elog "support pam_mount. If you have any programs that use pam with "
	elog "a configuration file that does NOT include system-auth you will "
	elog "need to modify this file too. Look at /etc/pam.d/system-auth or "
	elog "the /usr/share/doc/${PF}/README file for more informations."
}
