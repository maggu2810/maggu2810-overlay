# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 # eutils

DESCRIPTION="Easily control Intel p-state driver on Linux"
HOMEPAGE="https://github.com/pyamsoft/pstate-frequency"

#SRC_URI="ftp://foo.example.org/${P}.tar.gz"
EGIT_REPO_URI="https://github.com/pyamsoft/pstate-frequency.git"
EGIT_COMMIT="${PV}"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

#IUSE="gnome X"

# Build-time dependencies, such as
#    ssl? ( >=dev-libs/openssl-0.9.6b )
#    >=dev-lang/perl-5.6.1-r1
# It is advisable to use the >= syntax show above, to reflect what you
# had installed on your system when you tested the package.  Then
# other users hopefully won't be caught without the right version of
# a dependency.
#DEPEND=""

# Run-time dependencies. Must be defined to whatever this depends on to run.
# The below is valid if the same run-time depends are required to compile.
RDEPEND="${DEPEND}"

src_configure() {
	sed 's:PREFIX?=/usr/local:PREFIX?=/usr:g' -i config.mk
}

src_compile() {
	# Nothing to do
	true
}
