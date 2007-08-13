# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#doc: Add extra documentation
#gcov: Support for gcov (test coverage program)
#gprof: Support for gprof (GNU Profiler)
#no-verbose: Disable Verbose-Mode-Support (verbose + buffer_verbose)
#X: use the X window system; also enables compilation of gnee (the gui part).

IUSE="doc gcov gprof no-verbose X"

DESCRIPTION="Xnee can record and replay user sessions in the X Windows System environment."
HOMEPAGE="http://www.gnu.org/software/xnee/www/index.html"
SRC_URI="mirror://gnu/${PN}/Xnee-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

inherit eutils

# This docs disabled because of access violation!
# if app-office/dia is installed you get an acces violation
#dia --nosplash -e xngener.eps xngener.dia
#ACCESS DENIED  mkdir:     /root/.dia
#posible fix:
# - dia: teach it to use HOME not /root
# - ebuild: mkdir -p -p ${T}/home/.dia
#           HOME=${T}/home emake

#DEPEND="doc? (app-text/ghostscript
#		app-text/tetex
#		app-text/texi2html)"

DEPEND="X? (virtual/x11)"

S=${WORKDIR}/Xnee-${PV}

src_compile() {

	econf `use_enable gprof` \
		`use_enable gcov` \
		`use_enable no-verbose xosd` \
		`use_enable no-verbose verbose` \
		`use_enable no-verbose buffer_verbose` \
		`use_enable X gui` \
		`use_with X x` \
		--disable-doc \
		--enable-lib \
		--enable-cli \
		|| die "ERROR:econf failed"

	emake || die "ERROR:emake failed"

	# Build documentation
	einfo "Building documentation"

	emake man || die "ERROR: 'emake txt' failed"

	if use doc;
	then
		ewarn "You compiled with doc enabled."
		ewarn "Doc useflag is diabled because of make errors."
		ewarn "You should use the doc found at the project page:"
		ewarn "${HOMEPAGE}"

		sleep 5
	fi

}

src_install() {

	make DESTDIR=${D} install || die "ERROR: 'make install' failed"

	# Install documentation
	dodoc ChangeLog COPYING NEWS README sessions/example1.xns

	doman cnee/src/cnee.1

	# For compatibility with older versions
	ewarn "The command line interface is no longer called 'xnee'."
	ewarn "It's now called 'cnee'!"
	ewarn "There's a symlink that still allows using 'xnee',"
	ewarn "but from  now on 'cnee' should be used instead of 'xnee'!"

	dosym /usr/bin/cnee /usr/bin/xnee

	sleep 5
	make_desktop_entry gnee "gnee" "" "Development;GTK"
}
