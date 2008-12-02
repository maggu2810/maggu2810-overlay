# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.7"

inherit eutils x11 linux-mod autotools

IUSE_VIDEO_CARDS="
	video_cards_i810
	video_cards_mach64
	video_cards_mga
	video_cards_nv
	video_cards_r128
	video_cards_radeon
	video_cards_savage
	video_cards_sis
	video_cards_sunffb
	video_cards_tdfx
	video_cards_via"
IUSE="${IUSE_VIDEO_CARDS} kernel_FreeBSD kernel_linux"

# Make sure Portage does _NOT_ strip symbols.  We will do it later and make sure
# that only we only strip stuff that are safe to strip ...
RESTRICT="strip"

S="${WORKDIR}/drm"
PATCHVER="0.1"
PATCHDIR="${WORKDIR}/patch"
EXCLUDED="${WORKDIR}/excluded"

DESCRIPTION="DRM Kernel Modules for X11"
HOMEPAGE="http://dri.sf.net"
SRC_URI="mirror://gentoo/${P}-gentoo-${PATCHVER}.tar.bz2
	 mirror://gentoo/linux-drm-${PV}-kernelsource.tar.bz2"

SLOT="0"
LICENSE="X11"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86 ~x86-fbsd"

DEPEND="kernel_linux? ( virtual/linux-sources )
	kernel_FreeBSD? ( sys-freebsd/freebsd-sources
			sys-freebsd/freebsd-mk-defs )"
RDEPEND=""

pkg_setup() {
	# Setup the kernel's stuff.
	kernel_setup

	# Set video cards to build for.
	set_vidcards

	# Determine which -core dir we build in.
	get_drm_build_dir

	return 0
}

src_unpack() {
	unpack linux-drm-${PV}-kernelsource.tar.bz2
	unpack ${P}-gentoo-${PATCHVER}.tar.bz2

	cd "${S}"

	patch_prepare

	# Apply patches
	EPATCH_SUFFIX="patch" epatch "${PATCHDIR}"

	# Substitute new directory under /lib/modules/${KV_FULL}
	cd "${SRC_BUILD}"
	sed -ie "s:/kernel/drivers/char/drm:/${PN}:g" Makefile

	cp "${S}"/tests/*.c "${SRC_BUILD}"

	src_unpack_os

	cd "${S}"
	eautoreconf -v --install
}

src_compile() {
	cd "${S}"
	# Building the programs. These are useful for developers and getting info from DRI and DRM.
	#
	# libdrm objects are needed for drmstat.
	econf || die "libdrm configure failed."
	emake || die "libdrm build failed."

	einfo "Building DRM in ${SRC_BUILD}..."
	src_compile_os
	einfo "DRM build finished".
}

src_install() {
	einfo "Installing DRM..."
	cd "${SRC_BUILD}"

	src_install_os

	dodoc "${S}/linux-core/README.drm"

	dobin dristat
	dobin drmstat
}

pkg_postinst() {
	if use video_cards_sis
	then
		einfo "SiS direct rendering only works on 300 series chipsets."
		einfo "SiS framebuffer also needs to be enabled in the kernel."
	fi

	if use video_cards_mach64
	then
		einfo "The Mach64 DRI driver is insecure."
		einfo "Malicious clients can write to system memory."
		einfo "For more information, see:"
		einfo "http://dri.freedesktop.org/wiki/ATIMach64."
	fi

	pkg_postinst_os
}

# Functions used above are defined below:

kernel_setup() {
	if use kernel_FreeBSD
	then
		K_RV=${CHOST/*-freebsd/}
	elif use kernel_linux
	then
		linux-mod_pkg_setup

		if kernel_is 2 4
		then
			eerror "Upstream support for 2.4 kernels has been removed, so this package will no"
			eerror "longer support them."
			die "Please use in-kernel DRM or switch to a 2.6 kernel."
		fi

		linux_chkconfig_builtin "DRM" && \
			die "Please disable or modularize DRM in the kernel config. (CONFIG_DRM = n or m)"

		CONFIG_CHECK="AGP"
		ERROR_AGP="AGP support is not enabled in your kernel config (CONFIG_AGP)"
	fi
}

set_vidcards() {
	if use kernel_linux; then
		set_kvobj
		I810_VIDCARDS="i810.${KV_OBJ} i915.${KV_OBJ}"
	elif use kernel_FreeBSD; then
		KV_OBJ="ko"
		# bsd does not have i810, only i915:
		I810_VIDCARDS="i915.${KV_OBJ}"
	fi

	VIDCARDS=""

	if [[ -n "${VIDEO_CARDS}" ]]; then
		use video_cards_i810 && \
			VIDCARDS="${VIDCARDS} ${I810_VIDCARDS}"
		use video_cards_mach64 && \
			VIDCARDS="${VIDCARDS} mach64.${KV_OBJ}"
		use video_cards_mga && \
			VIDCARDS="${VIDCARDS} mga.${KV_OBJ}"
		use video_cards_nv && \
			VIDCARDS="${VIDCARDS} nv.${KV_OBJ} nouveau.${KV_OBJ}"
		use video_cards_r128 && \
			VIDCARDS="${VIDCARDS} r128.${KV_OBJ}"
		use video_cards_radeon && \
			VIDCARDS="${VIDCARDS} radeon.${KV_OBJ}"
		use video_cards_savage && \
			VIDCARDS="${VIDCARDS} savage.${KV_OBJ}"
		use video_cards_sis && \
			VIDCARDS="${VIDCARDS} sis.${KV_OBJ}"
		use video_cards_via && \
			VIDCARDS="${VIDCARDS} via.${KV_OBJ}"
		use video_cards_sunffb && \
			VIDCARDS="${VIDCARDS} ffb.${KV_OBJ}"
		use video_cards_tdfx && \
			VIDCARDS="${VIDCARDS} tdfx.${KV_OBJ}"
	fi
}

get_drm_build_dir() {
	if use kernel_FreeBSD
	then
		SRC_BUILD="${S}/bsd-core"
	elif kernel_is 2 6
	then
		SRC_BUILD="${S}/linux-core"
	fi
}

patch_prepare() {
	# Handle exclusions based on the following...
	#     All trees (0**), Standard only (1**), Others (none right now)
	#     2.4 vs. 2.6 kernels
	if use kernel_linux
	then
	    kernel_is 2 6 && mv -f "${PATCHDIR}"/*kernel-2.4* "${EXCLUDED}"
	fi

	# There is only one tree being maintained now. No numeric exclusions need
	# to be done based on DRM tree.
	
	cp ${FILESDIR}/*.patch ${PATCHDIR}
}

src_unpack_freebsd() {
	# Do FreeBSD stuff.
	if use kernel_FreeBSD
	then
		# Link in freebsd kernel.
		ln -s "/usr/src/sys-${K_RV}" "${WORKDIR}/sys"
		# SUBDIR variable gets to all Makefiles, we need it only in the main one.
		SUBDIRS=${VIDCARDS//.ko}
		sed -ie "s:SUBDIR\ =.*:SUBDIR\ =\ drm ${SUBDIRS}:" "${SRC_BUILD}"/Makefile
	fi
}

src_unpack_os() {
	if use kernel_FreeBSD
	then
		src_unpack_freebsd
	fi
}

src_compile_os() {
	if use kernel_linux
	then
		src_compile_linux
	elif use kernel_FreeBSD
	then
		src_compile_freebsd
	fi
}

src_install_os() {
	if use kernel_linux
	then
		src_install_linux
	elif use kernel_FreeBSD
	then
		src_install_freebsd
	fi
}

src_compile_linux() {
	# This now uses an M= build system. Makefile does most of the work.
	cd "${SRC_BUILD}"
	unset ARCH
	emake M="${SRC_BUILD}" \
		LINUXDIR="${KERNEL_DIR}" \
		DRM_MODULES="${VIDCARDS}" \
		modules || die_error

	if linux_chkconfig_present DRM
	then
		echo "Please disable in-kernel DRM support to use this package."
	fi

	# LINUXDIR is needed to allow Makefiles to find kernel release.
	cd "${SRC_BUILD}"
	emake LINUXDIR="${KERNEL_DIR}" dristat || die "Building dristat failed."
	emake LINUXDIR="${KERNEL_DIR}" drmstat || die "Building drmstat failed."
}

src_compile_freebsd() {
	cd "${SRC_BUILD}"
	# Environment CFLAGS overwrite kernel CFLAGS which is bad.
	local svcflags=${CFLAGS}; local svldflags=${LDFLAGS}
	unset CFLAGS; unset LDFLAGS
	MAKE=make \
		emake \
		NO_WERROR= \
		SYSDIR="${WORKDIR}/sys" \
		KMODDIR="/boot/modules" \
		|| die "pmake failed."
	export CFLAGS=${svcflags}; export LDFLAGS=${svldflags}

	cd "${S}/tests"
	# -D_POSIX_SOURCE skips the definition of several stuff we need
	# for these two to compile
	sed -i -e "s/-D_POSIX_SOURCE//" Makefile
	emake dristat || die "Building dristat failed."
	emake drmstat || die "Building drmstat failed."
	# Move these where the linux stuff expects them
	mv dristat drmstat "${SRC_BUILD}"
}

die_error() {
	eerror "Portage could not build the DRM modules. If you see an ACCESS DENIED error,"
	eerror "this could mean that you were using an unsupported kernel build system."
	eerror "Only 2.6 kernels at least as new as 2.6.6 are supported."
	die "Unable to build DRM modules."
}

src_install_linux() {
	cd "${SRC_BUILD}"
	unset ARCH
	kernel_is 2 6 && DRM_KMOD="drm.${KV_OBJ}"
	emake KV="${KV_FULL}" \
		LINUXDIR="${KERNEL_DIR}" \
		DESTDIR="${D}" \
		RUNNING_REL="${KV_FULL}" \
		MODULE_LIST="${VIDCARDS} ${DRM_KMOD}" \
		O="${KBUILD_OUTPUT}" \
		install || die "Install failed."

	# Strip binaries, leaving /lib/modules untouched (bug #24415)
	strip_bins \/lib\/modules

	# Yoinked from the sys-apps/touchpad ebuild. Thanks to whoever made this.
	keepdir /etc/modules.d
	sed 's:%PN%:'${PN}':g' "${FILESDIR}"/modules.d-${PN} > "${D}"/etc/modules.d/${PN}
	sed -i 's:%KV%:'${KV_FULL}':g' "${D}"/etc/modules.d/${PN}
}

src_install_freebsd() {
	cd "${SRC_BUILD}"
	dodir "/boot/modules"
	MAKE=make \
		emake \
		install \
		NO_WERROR= \
		DESTDIR="${D}" \
		KMODDIR="/boot/modules" \
		|| die "Install failed."
}

pkg_postinst_os() {
	if use kernel_linux
	then
		linux-mod_pkg_postinst
	fi
}
