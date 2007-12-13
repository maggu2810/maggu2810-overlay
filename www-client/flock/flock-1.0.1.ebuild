# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils mozconfig-2 makeedit multilib fdo-mime mozextension autotools

DESCRIPTION="Flock Web Browser"
HOMEPAGE="http://www.flock.com/"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
IUSE="java mozdevelop xforms restrict-javascript filepicker"

SRC_URI="http://ftp.osuosl.org/pub/flock/releases/${PV}/${P}-source.tar.bz2"

RDEPEND="java? ( virtual/jre )
	>=dev-cpp/clucene-0.9.21
	media-video/ffmpeg
	>=sys-devel/binutils-2.16.1
	>=dev-libs/nss-3.11.5
	>=dev-libs/nspr-4.6.5"

DEPEND="${RDEPEND}
	java? ( >=dev-java/java-config-0.2.0 )"

PDEPEND="restrict-javascript? ( x11-plugins/noscript )"

S="${WORKDIR}/${PN}"

# Needed by src_compile() and src_install().
# Would do in pkg_setup but that loses the export attribute, they
# become pure shell variables.
export MOZ_CO_PROJECT=browser
export BUILD_OFFICIAL=1
#export MOZILLA_OFFICIAL=1

pkg_setup(){
	if ! built_with_use x11-libs/cairo X; then
		eerror "Cairo is not built with X useflag."
		eerror "Please add 'X' to your USE flags, and re-emerge cairo."
		die "Cairo needs X"
	fi

	use moznopango && warn_mozilla_launcher_stub
}

src_unpack() {
	unpack ${A}

	# Apply our patches
	cd "${S}" || die "cd failed"
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	mozconfig_init
	mozconfig_config

	mozconfig_annotate '' --enable-official-branding
	mozconfig_annotate '' --enable-application=browser
	mozconfig_annotate '' --enable-image-encoder=all
	mozconfig_annotate '' --enable-canvas
	mozconfig_annotate '' --with-system-nspr
	mozconfig_annotate '' --with-system-nss

	if use xforms; then
		mozconfig_annotate '' --enable-extensions=default,xforms,schema-validation,typeaheadfind
	else
		mozconfig_annotate '' --enable-extensions=default,typeaheadfind
	fi

	if use ia64; then
		echo "ac_cv_visibility_pragma=no" >>  "${S}/.mozconfig"
	fi

	# Bug 60668: Galeon doesn't build without oji enabled, so enable it
	# regardless of java setting.
	mozconfig_annotate '' --enable-oji --enable-mathml

	# Other flock-specific settings
	mozconfig_annotate '' --with-clucene-prefix=/usr
	mozconfig_annotate '' --with-ffmpeg-prefix=/usr
	mozconfig_use_enable mozdevelop jsd
	mozconfig_use_enable mozdevelop xpctools
	mozconfig_use_extension mozdevelop venkman
	mozconfig_annotate '' --with-default-mozilla-five-home="${MOZILLA_FIVE_HOME}"

	# Finalize and report settings
	mozconfig_final

	# -fstack-protector breaks us
	if gcc-version ge 4 1; then
		gcc-specs-ssp && append-flags -fno-stack-protector
	else
		gcc-specs-ssp && append-flags -fno-stack-protector-all
	fi
		filter-flags -fstack-protector -fstack-protector-all

	####################################
	#
	#  Configure and build
	#
	####################################

	CPPFLAGS="${CPPFLAGS} -DARON_WAS_HERE" \
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	econf || die

	# It would be great if we could pass these in via CPPFLAGS or CFLAGS prior
	# to econf, but the quotes cause configure to fail.
	sed -i -e \
		's|-DARON_WAS_HERE|-DGENTOO_NSPLUGINS_DIR=\\\"/usr/'"$(get_libdir)"'/nsplugins\\\" -DGENTOO_NSBROWSER_PLUGINS_DIR=\\\"/usr/'"$(get_libdir)"'/nsbrowser/plugins\\\"|' \
		"${S}"/xpfe/global/buildconfig.html \
		"${S}"/toolkit/content/buildconfig.html

	# This removes extraneous CFLAGS from the Makefiles to reduce RAM
	# requirements while compiling
	edit_makefiles

	# Should the build use multiprocessing? Not enabled by default, as it tends to break
	[ "${WANT_MP}" = "true" ] && jobs=${MAKEOPTS} || jobs="-j1"
	emake ${jobs} || die
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# Most of the installation happens here
	dodir "${MOZILLA_FIVE_HOME}"
	cp -RL "${S}"/dist/bin/* "${D}"/"${MOZILLA_FIVE_HOME}"/ || die "cp failed"

	# Create /usr/bin/Flock
	#install_mozilla_launcher_stub Flock "${MOZILLA_FIVE_HOME}"
	cat >"${T}"/Flock <<EOF
#!/bin/sh
(
	cd "${MOZILLA_FIVE_HOME}"
	exec ./${PN} "\$@"
)
EOF
	dobin "${T}"/Flock

	# Install icon and .desktop for menu entry
	newicon "${S}"/dist/branding/mozicon50.xpm flock-icon.xpm
	domenu "${FILESDIR}"/flock.desktop

	# Install files necessary for applications to build against firefox
	einfo "Installing includes and idl files..."
	cp -LfR "${S}"/dist/include "${D}"/"${MOZILLA_FIVE_HOME}" || die "cp failed"
	cp -LfR "${S}"/dist/idl "${D}"/"${MOZILLA_FIVE_HOME}" || die "cp failed"

	# Dirty hack to get some applications using this header running
	dosym "${MOZILLA_FIVE_HOME}"/include/necko/nsIURI.h \
		"${MOZILLA_FIVE_HOME}"/include/nsIURI.h

	# Install pkgconfig files
	insinto /usr/"$(get_libdir)"/pkgconfig
	doins "${S}"/build/unix/*.pc

	insinto "${MOZILLA_FIVE_HOME}"/greprefs
	newins "${FILESDIR}"/gentoo-default-prefs.js all-gentoo.js
	insinto "${MOZILLA_FIVE_HOME}"/defaults/pref
	newins "${FILESDIR}"/gentoo-default-prefs.js all-gentoo.js
}

pkg_postinst() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# This should be called in the postinst and postrm of all the
	# mozilla, mozilla-bin, firefox, firefox-bin, thunderbird and
	# thunderbird-bin ebuilds.
	update_mozilla_launcher_symlinks

	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	update_mozilla_launcher_symlinks
}
