# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit eutils subversion linux-info

DESCRIPTION="A cd-drive emulator for Linux"
HOMEPAGE="http://cdemu.org/"
ESVN_REPO_URI="https://cdemu.svn.sourceforge.net/svnroot/cdemu/trunk/cdemu"
ESVN_PROJECT="cdemu"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="udev"

DEPEND=""
RDEPEND="udev? ( sys-fs/udev )
         dev-lang/python"

pkg_setup() {
        if kernel_is lt 2 6 16 ; then
                die "CDemu version 0.8 and up requires kernel >= 2.6.16"
        fi
  }

src_compile() {
  # Need to unset ARCH or Bad Things TM will happen.
  # See: http://www.openafs.org/pipermail/openafs-devel/2005-June/012325.html
  # and: http://linuxfromscratch.org/pipermail/livecd/2005-September/001613.html
  # or google for it: http://www.google.com/search?hl=en&q=%22arch%2Fx86%2FMakefile%22+%22no+such+file%22&btnG=Google+Search
  unset ARCH ; make mrproper
  emake || die emake failed
  }

src_install() {
  emake DESTDIR=${D} install || die emake install failed
  dodoc AUTHORS ChangeLog README TODO
  if use udev; then
    echo 'KERNEL="cdemu*", NAME="cdemu/%n", SYMLINK="%n", MODE="0660", GROUP="cdrom"' > "${S}/cdemu.udev-rules"
    insinto /etc/udev/rules.d/
    newins "${S}/cdemu.udev-rules" 99-cdemu.rules
    fi
  }

pkg_postinst() {
	[ "${ROOT}" == "/" ] && depmod -a
	ewarn 
	ewarn Remember: You need to be in the \`cdrom\' group to acces cdrom devices!
	ewarn
  }
