# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION=""
HOMEPAGE="https://darknrg.dyndns.org:28514/index.html"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/util-linux"

src_install() {

	cd ${T}
	mkdir -p work
	cd work
	cp -f ${FILESDIR}/* .

	[ -e ${PF}.patch ] && {
		sed -i "s:/etc/::" ${PF}.patch
		sed -i "s:/usr/bin/::" ${PF}.patch
		sed -i "s:/usr/share/vdr/record/::" ${PF}.patch
		epatch ${PF}.patch
	}

	# install config files
	insinto /etc
	doins *.cfg

	# install record-gate-script (doesn't have to be executable)
	insinto /usr/share/vdr/record
	doins record-99-*.sh

	# install executables
	for f in `find . -type f -regex "\./[^.]*"`; do
		dobin $f
	done

	einfo "To let vdr2avi-auto check for videos to process every 10 minutes,"
	einfo "add something like this to your crontab (if you have 2 cpu cores):"
	einfo "*/10 * * * * vdr2avi-auto 1 >>~/vdr2avi-auto.log 2>&1"
	einfo "*/10 * * * * vdr2avi-auto 2 >>~/vdr2avi-auto.log 2>&1"
}
