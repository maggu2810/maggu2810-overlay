# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit eutils user systemd flag-o-matic multilib python-r1

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
IUSE="bridge examples +persistence python ssl tcpd"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="tcpd? ( sys-apps/tcp-wrappers )
		ssl? ( >=dev-libs/openssl-1.0.0 )
		python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	net-dns/c-ares"

pkg_setup() {
	enewuser mosquitto
}

src_prepare() {
	if use python; then
		python_copy_sources lib/python
	fi

	# Don't automatically build Python module
	sed -i "s:\$(MAKE) -C python:#:g" lib/Makefile || die

	if use persistence; then
		sed -i "s:^#autosave_interval:autosave_interval:" mosquitto.conf || die
		sed -i "s:^#persistence false$:persistence true:" mosquitto.conf || die
		sed -i "s:^#persistence_file:persistence_file:" mosquitto.conf || die
		sed -i "s:^#persistence_location$:persistence_location /var/lib/mosquitto/:" mosquitto.conf || die
	fi
}

src_configure() {
	local LIBDIR=$(get_libdir)
	makeopts="LIB_SUFFIX=${LIBDIR:3}"
	if use bridge ; then
		makeopts="${makeopts} WITH_BRIDGE=yes"
	else
		makeopts="${makeopts} WITH_BRIDGE=no"
	fi
	if use persistence ; then
		makeopts="${makeopts} WITH_PERSISTENCE=yes"
	else
		makeopts="${makeopts} WITH_PERSISTENCE=no"
	fi
	if use ssl ; then
		makeopts="${makeopts} WITH_TLS=yes"
	else
		makeopts="${makeopts} WITH_TLS=no"
	fi
	if use tcpd ; then
		makeopts="${makeopts} WITH_WRAP=yes"
	else
		makeopts="${makeopts} WITH_WRAP=no"
	fi
	einfo "${makeopts}"
}

src_compile() {
	emake || die
}

src_install() {
	emake install ${makeopts} DESTDIR="${D}" prefix=/usr || die "Install failed"
	dodir /var/lib/mosquitto
	dodoc readme.txt ChangeLog.txt || die "dodoc failed"
	doinitd "${FILESDIR}"/mosquitto

	# Note: wait for mod_systemd to be included in the next release,
	# then apache2.4.service can be used and systemd support controlled
	# through --enable-systemd
	systemd_newunit "${FILESDIR}/mosquitto.service" "mosquitto.service"

	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		insinto "/usr/share/doc/${PF}/examples"
		doins -r examples/*
		if use python; then
			doins lib/python/sub.py
		fi
	fi
}

pkg_postinst() {
	chown mosquitto: /var/lib/mosquitto
	elog "To start mosquitto at boot, add it to the default runlevel with:"
	elog ""
	elog "    rc-update add mosquitto default"
}
