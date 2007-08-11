# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

inherit eutils pam autotools

DESCRIPTION="A PAM module that can mount volumes for a user session e.g. encrypted home directories"
HOMEPAGE="http://pam-mount.souceforge.net"
#go get the source from sourceforge!
SRC_URI="mirror://sourceforge/pam-mount/${P}.tbz2"

# The next line should be removed when this ebuild will be inserted into
# portage to download the needed source code from the gentoo mirrors and
# not from sf.net
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"

IUSE="crypt"
DEPEND=">=sys-libs/pam-0.72 
	>=openssl-0.9.7c-r2
	>=glib-2.0.0"
RDEPEND="$DEPEND
	crypt? ( >=sys-fs/cryptsetup-luks )
	sys-process/lsof"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Gentoo installs cryptsetup in /bin, this patches the relevant 
	# locations, in srcipts/(u)mount.crypt and adds gentoo specific
	# comments to pam_mount.conf
	epatch ${FILESDIR}/pam_mount-gentoo-paths-and-examples.patch
}

src_compile() {
	# fixes the sanity check failure
	_elibtoolize --copy --force

	# configure and build pam_mount
	econf \
	    --libdir=/lib \
		"--with-pam-dir=$(getpam_mod_dir)" || die "econf failed"
	emake || die "make failed"
}

src_install() {
	# install all pam_mount files
	DESTDIR=${D} make install || die "make install failed"

	# install the configuration files
	insinto /etc/security
	insopts -m0644
	doins ${S}/config/pam_mount.conf
	insinto /etc/pam.d
	doins ${FILESDIR}/system-auth
	dodir /sbin
	dosym /usr/bin/mount.crypt /sbin/mount.crypt

	# install the documentation
	dodoc README TODO AUTHORS ChangeLog FAQ INSTALL NEWS
}

pkg_postinst() {
	einfo "In order to use pam_mount you will need to configure it."
	einfo "After the modifications in /etc/security/pam_mount.conf you "
	einfo "can create the encrypted directory using the mkehd command."
	einfo "Please use mkhed -h for more informations."
	einfo
	einfo "If you want to encrypt the home directories you will need a "
	einfo "kernel with device-mapper and crypto (AES or any other chipher)"
	einfo "support."
	einfo
	einfo "This ebuild only modifies the /etc/pam.d/system-auth file to"
	einfo "support pam_mount. If you have any programs that use pam with "
	einfo "a configuration file that does NOT include system-auth you will "
	einfo "need to modify this file too. Look at /etc/pam.d/system-auth or "
	einfo "the pam_mount README file for more informations."
}
