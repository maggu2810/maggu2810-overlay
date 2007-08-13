# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvsd/root/portage/dev-python/python-extattr/python-extattr-0.1.3.ebuild,v 1.1 2007/03/16 16:44:11 oliver Exp $

inherit distutils

DESCRIPTION="This is a Python extension created to manipulate extended attributes in filesystems that support them."
HOMEPAGE="http://rudd-o.com/projects/python-extattr/"
SRC_URI="http://rudd-o.com/wp-content/projects/files/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=">=dev-lang/python-2.2
	sys-apps/attr"
