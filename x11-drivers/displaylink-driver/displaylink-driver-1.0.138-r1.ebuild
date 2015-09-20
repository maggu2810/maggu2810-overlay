# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils systemd udev

DESCRIPTION="DisplayLink USB Graphics Software"

HOMEPAGE="http://www.displaylink.com/downloads/ubuntu.php"

SRC_URI="http://downloads.displaylink.com/publicsoftware/DisplayLink-Ubuntu-${PV}.zip"

LICENSE="closed"

SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND="app-admin/chrpath"

RDEPEND="virtual/libusb:1
	x11-video/evdi"

DL_COREDIR="/opt/displaylink"
DLM_DIR="${DL_COREDIR}/manager"
DLM_BASE="DisplayLinkManager"
DLM_PATH="${DLM_DIR}/${DLM_BASE}"

QA_PREBUILT="${DLM_PATH}"

TMPDIR="${WORKDIR}/tmp"

rpl_envs() {
	local SRC_FILE="${1}"; shift

	local BASENAME="$(basename "${SRC_FILE}")"
	local DST_FILE="${TMPDIR}/${BASENAME}"

	cp "${SRC_FILE}" "${DST_FILE}" || die "Copy temp file failed"

	sed 's:$DL_COREDIR:'"${DL_COREDIR}"':g' -i "${DST_FILE}"
	sed 's:$DLM_DIR:'"${DLM_DIR}"':g' -i "${DST_FILE}"
	sed 's:$DLM_BASE:'"${DLM_BASE}"':g' -i "${DST_FILE}"
	sed 's:$DLM_PATH:'"${DLM_PATH}"':g' -i "${DST_FILE}"
	echo "${DST_FILE}"
}

src_prepare() {
	mkdir -p "${TMPDIR}"
	default
}

src_unpack() {
	default
	sh ./"${P}".run --noexec --keep
}

src_install() {
	case "${ARCH}" in
		amd64) DLM="${S}/x64/DisplayLinkManager";;
		x90)   DLM="${S}/x86/DisplayLinkManager";;
		*) die "invalid ARCH (${ARCH})";;
	esac

	# Remove DT_RPATH
	chrpath -d "${DLM}"
	exeinto "${DLM_DIR}"
	newexe "${DLM}" "${DLM_BASE}"

	insinto "${DLM_DIR}"
	doins "${S}/"*.spkg
	doins "${S}/LICENSE"

	local FILE
	FILE="$(rpl_envs "${FILESDIR}"/displaylink.service)"
	systemd_dounit "${FILE}"

	local SYSTEMD_SLEEP="$(systemd_get_utildir)/system-sleep"
	FILE="$(rpl_envs "${FILESDIR}"/displaylink.sh)"
	exeinto "${SYSTEMD_SLEEP}"
	doexe "${FILE}"

	udev_dorules "${FILESDIR}"/99-displaylink.rules
}

pkg_postinst() {
	einfo
	einfo "You should enable the display link service:"
	einfo " systemctl enable displaylink.service"
	einfo "and perhaps restart your system."
	einfo
	einfo "If all went fine, you should see an additional provider in X:"
	einfo " xrandr --listproviders"
	einfo "set the provider output source using e.g."
	einfo " xrandr --setprovideroutputsource 1 0"
	einfo "and configure your displays"
	einfo
}
