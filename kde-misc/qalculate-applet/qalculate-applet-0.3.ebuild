# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="1"

NEED_KDE="4.2"
inherit kde4overlay-base

DESCRIPTION="A KDE4 Plasma Applet. A variation of the KAlgebra plasmoid that makes use of the Qalculate! library."
HOME_PAGE="http://www.kde-look.org/content/show.php/Qalculate?content=84618"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="http://www.kde-look.org/CONTENT/content-files/84618-qalculate_applet-${PV}.tar.gz"
SLOT="4.2"

DEPEND="kde-base/libplasma"

S=${WORKDIR}/qalculate_applet
