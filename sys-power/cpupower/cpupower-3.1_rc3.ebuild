# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

MY_P="linux-${PV/_/-}"

DESCRIPTION="successor to cpufrequtils distributed along Linux kernel sources"
HOMEPAGE="http://lwn.net/Articles/433002/"
SRC_URI="mirror://kernel/linux/kernel/v3.x/testing/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls benchmark"

# while the binaries are renamed, other files still collide
RDEPEND="!sys-power/cpufrequtils"

S="${WORKDIR}/${MY_P}/tools/power/cpupower"

src_unpack() {
	local extract_only extract_list
	extract_only="Makefile tools/power/cpupower/"
	for file in ${extract_only}
	do
		extract_list+=" ${MY_P}/${file}"
	done
	tar -xjpf "${DISTDIR}/${A}" ${extract_list}
}

src_prepare() {
	pushd "${WORKDIR}/${MY_P}" > /dev/null
	epatch "${FILESDIR}/cpupower-do-not-fail-build-with-Wl-as-needed.patch"
	popd > /dev/null
}

src_compile() {
	use nls && NLS="true" || NLS="false"
	export NLS
	use benchmark && CPUFRQ_BENCH="true" || CPUFRQ_BENCH="false"
	export CPUFRQ_BENCH
	# set strip command to no-op so that is is handled by portage
	emake STRIP=/bin/true
}

src_install() {
	# cannot use einstall as it encodes ${ED} into {bin,man,doc,...}dir
	emake \
		DESTDIR="${D}" \
		mandir="/usr/share/man" \
		docdir="/usr/share/doc/${PF}" \
		libdir="/usr/$(get_libdir)" \
		install
}
