# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jre/jre-1.6.0.ebuild,v 1.6 2008/01/18 01:40:58 ranger Exp $

DESCRIPTION="Virtual for JRE"
HOMEPAGE="http://java.sun.com/"
SRC_URI=""

LICENSE="as-is"
SLOT="1.7"
KEYWORDS="~amd64 ~x86"
IUSE=""

# we have to jre with version 7, so we depend on the jdk instead
RDEPEND="=virtual/jdk-1.7.0*"
DEPEND=""
