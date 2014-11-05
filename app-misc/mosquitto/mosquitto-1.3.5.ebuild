# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils cmake-utils user systemd flag-o-matic multilib

DESCRIPTION="An Open Source MQTT v3 Broker"
HOMEPAGE="http://mosquitto.org/"

if [[ "${PV}" == "${PV%%_rc[0-9]}" ]]; then
	SRC_URI="http://mosquitto.org/files/source/${P}.tar.gz"
else
	SRC_URI="http://mosquitto.org/files/source/rc/${P/_/~}.tar.gz"
	S="${WORKDIR}/${P/_/~}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bridge examples +persistence ssl tcpd threads"

RDEPEND="tcpd? ( sys-apps/tcp-wrappers )
		ssl? ( >=dev-libs/openssl-1.0.0 )"
DEPEND="${RDEPEND}
	net-dns/c-ares"

pkg_setup() {
	enewuser mosquitto
}

src_prepare() {
	epatch "${FILESDIR}"/mosquitto-link.patch

	# Must not call ldconfig on install
	# install(CODE "EXEC_PROGRAM(/sbin/ldconfig)")
	find -type f -name "CMakeLists.txt" -exec sed s:/sbin/ldconfig:true:g -i '{}' \;

	# Don't automatically build Python module
	#sed -i "s:\$(MAKE) -C python:#:g" lib/Makefile || die

	if use persistence; then
		sed -i "s:^#autosave_interval:autosave_interval:" mosquitto.conf || die
		sed -i "s:^#persistence false$:persistence true:" mosquitto.conf || die
		sed -i "s:^#persistence_file:persistence_file:" mosquitto.conf || die
		sed -i "s:^#persistence_location$:persistence_location /var/lib/mosquitto/:" mosquitto.conf || die
	fi
}

src_configure() {
	local mycmakeargs=(
		"$(cmake-utils_use bridge INC_BRIDGE_SUPPORT)"
		"-DINC_MEMTRACK=ON"

		"$(cmake-utils_use_use tcpd LIBWRAP)"

		"$(cmake-utils_use_with persistence PERSISTENCE)"
		"-DWITH_SRC=ON"
		"-DWITH_SYS_TREE=ON"
		"$(cmake-utils_use_with threads THREADING)"
		"$(cmake-utils_use_with ssl TLS)"
		"$(cmake-utils_use_with ssl TLS_PSK)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodir /var/lib/mosquitto
	dodoc readme.txt ChangeLog.txt || die "dodoc failed"
	doinitd "${FILESDIR}"/mosquitto

	systemd_newunit "${FILESDIR}/mosquitto.service" "mosquitto.service"

	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		insinto "/usr/share/doc/${PF}/examples"
		doins -r examples/*
	fi
}

pkg_postinst() {
	chown mosquitto: /var/lib/mosquitto
	elog "To start mosquitto at boot, add it to the default runlevel with:"
	elog ""
	elog "    rc-update add mosquitto default"
}
