# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jdk/jdk-1.6.0.ebuild,v 1.7 2008/04/28 00:54:28 betelgeuse Exp $

DESCRIPTION="Virtual for JDK"
HOMEPAGE="http://java.sun.com/"
SRC_URI=""

LICENSE="as-is"
SLOT="1.7"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Keeps this and java-virtuals/jaf in sync
RDEPEND="|| (
		=dev-java/icedtea-1.7.0*
		=dev-java/icedtea-bin-1.7.0*
	)"
DEPEND=""
