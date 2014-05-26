# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Recent Notifications is a GNOME applet that collects recent messages notify-osd."

HOMEPAGE="https://launchpad.net/recent-notifications/"

SRC_URI="https://launchpad.net/${PN}/gnome3/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64"

#IUSE="gnome X"

#DEPEND=""

RDEPEND="${DEPEND}"
