# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libmems/libmems-9999.ebuild,v 1.1 2009/04/03 16:36:24 weaver Exp $

EAPI="2"

# To look with revision is tagged for which version:
# http://smokinguns.svn.sourceforge.net/viewvc/smokinguns/tags/
MY_PREV=494

# remove the -svn for the package name
MY_PN="${PN/-svn/}"

# remove _pre, _beta, etc. for the package version
MY_DELIM="_"
MY_PV="${PV%%${MY_DELIM}*}"

ESVN_REPO_URI="https://${MY_PN}.svn.sourceforge.net/svnroot/${MY_PN}/branches/@${MY_PREV}"

inherit eutils games subversion

DESCRIPTION="A first person Western style shooter engine (based on the Quake 3 engine)"
HOMEPAGE="http://www.smokin-guns.net/"
#SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND="virtual/opengl
        media-libs/openal
        media-libs/libsdl"
RDEPEND="${DEPEND}
	games-fps/${MY_PN}-data"

MY_S="${WORKDIR}"/"${P}"/"${MY_PV}"
MY_DEST="${GAMES_DATADIR}"/"${MY_PN}"

# ------------------------------------------------
# must be done for branch (230)
src_compile() {
	cd "${MY_S}"
	emake
}
# ------------------------------------------------

src_install() {
	# ------------------------------------------------
	# must be done for branch (230)
	cd "${MY_S}"
	# ------------------------------------------------

	# ------------------------------------------------
	# works for branch (230)
	COPYDIR="${D}"/"${MY_DEST}" make copyfiles
	# ------------------------------------------------

	# ------------------------------------------------
	# works for branch (230), but lets use 'make copyfiles'
	#mkdir -p "${D}/${MY_DEST}/"
	#cp	build/release-linux-"${ARCH}"/"${MY_PN}"_dedicated."${ARCH}" \
	#	build/release-linux-"${ARCH}"/"${MY_PN}"."${ARCH}" \
	#	"${D}/${MY_DEST}/." || die "Install failed!"
	# ------------------------------------------------
	
	# ------------------------------------------------
	# common section
	games_make_wrapper "${MY_PN}"           "${MY_DEST}"/"${MY_PN}"."${ARCH}"           "${MY_DEST}" "${MY_DEST}"
	games_make_wrapper "${MY_PN}"_dedicated "${MY_DEST}"/"${MY_PN}"_dedicated."${ARCH}" "${MY_DEST}" "${MY_DEST}"
	prepgamesdirs
	# ------------------------------------------------
}

# ------------------------------------------------
# not necessary for branch (230)
#pkg_postinst() {
#	games_pkg_postinst
#
#	elog "If you want to use the contained 'vm',"
#	elog "you should run the following command as user:"
#	elog "   mkdir -p ~/.smokinguns/smokinguns/vm"
#	elog "   ln -s /usr/share/games/smokinguns/smokinguns/vm \\"
#	elog "         ~/.smokinguns/smokinguns/vm"
#}
# ------------------------------------------------
