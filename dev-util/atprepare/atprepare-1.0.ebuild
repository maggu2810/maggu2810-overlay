# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

# short description
DESCRIPTION="Prepares a C or C++ project for autotools usage."

# link to homepage
HOMEPAGE="https://darknrg.dyndns.org:28514/index.html"

# license(s)
LICENSE="GPL-2"

# slot (0 for none)
SLOT="0"

# platform keywords
KEYWORDS="~amd64 ~ia64 ~x86 ~x86-fbsd"

# restrict downloading from mirror
RESTRICT="mirror"

# use flags
IUSE=""

# common dependencies
COMMONDEP="
	app-shells/bash
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/sed

	sys-devel/autoconf-wrapper
	sys-devel/automake-wrapper
	sys-devel/make
	dev-util/subversion
"

DEPEND="${COMMONDEP}"
RDEPEND="${COMMONDEP}"


##############################################
########## END-OF-USER-CONFIG sh #############
##############################################


src_install() {
	cd ${FILESDIR}
	for f in *.sh; do
		f2=${T}/${f%.sh}
		cp $f $f2
		dobin $f2
	done
	cd -
}
