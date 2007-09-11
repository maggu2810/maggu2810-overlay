# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit eutils games autotools

DESCRIPTION="Playstation2 emulator"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="pcsx${PV}_and_plugins_src.7z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug alsa oss vmbuild sse2 devbuild hwaccel recompiler nls"

DEPEND="sys-libs/zlib
		media-gfx/nvidia-cg-toolkit
		x11-libs/cairo
		x11-libs/pango
		media-libs/glitz
		media-libs/libpng
		dev-libs/atk
		x11-proto/xf86vidmodeproto
		>=media-libs/freetype-2
		x11-libs/libXxf86vm
		app-arch/p7zip
		games-emulation/ps2emu-cdvdnull
		games-emulation/ps2emu-ZeroPAD
		games-emulation/ps2emu-spu2null
		games-emulation/ps2emu-dev9null
		>=games-emulation/ps2emu-usbnull-0.4-r1
		games-emulation/ps2emu-FWnull
		!hwaccel? ( games-emulation/ps2emu-gssoft )
		hwaccel? ( games-emulation/ps2emu-ZeroGS )

		>=x11-libs/gtk+-2"

RDEPEND="debug? ( sys-devel/gdb )
		${DEPEND}"

LANGS="ar bg cz de du el es fr hb it ja pe pl po ro ru sh sw tc tr"
LANGS1="po_BR"
for i in ${LANGS} ${LANGS1}; do
	IUSE="${IUSE} linguas_${i}"
done

RESTRICT="fetch"

S=${WORKDIR}/pcsx2

pkg_nofetch() {
	einfo "At the moment, there is no clean way to" 
	einfo "automatically download the ${P} sources."
	
	einfo "You can download them manually at http://www.pcsx2.net/files/8022 or"
	einfo "http://www.pcsx2.net/thel33tback3nd/attachment.php?aid=8022"
	einfo "and place them in ${DISTDIR} named pcsx${PV}_and_plugins_src.7z"
}

pkg_setup() {
	if ! use nls; then
		for i in ${LANGS} ${LANGS1}; do
			if [ -n "$(usev linguas_${i})" ]; then
				eerror "Any language other than english is not supported with USE=\"-nls\""
				die "Language ${i} not supported with USE=\"-nls\""
			fi
		done
	fi

	if use vmbuild; then
		ewarn " Warning: Compilation is known to fail with the vmbuild use flag enabled "
		ewarn " The recommended use flags are USE=\"-vmbuild sse2 recompiler\" "
		ewarn " Do not file a bug unless you are using the above USE flags. "
		ewarn " If you can get it to compile however, please file a bug or "
		ewarn " contact me at eatnumber1@gmail.com "
		ebeep 5
	fi

	if ! use recompiler; then
		ewarn " Warning: Compilation is known to fail with the recompiler use flag disabled "
		ewarn " The recommended use flags are USE=\"-vmbuild recompiler\" "
		ewarn " Do not file a bug unless you are using the above USE flags. "
		ewarn " If you can get it to compile however, please file a bug or "
		ewarn " contact me at eatnumber1@gmail.com "
		ebeep 5
	fi
}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"

	# There are a bunch of .svn folders from a svn checkout in the tarball
	# they need to be removed. There are also some Thumbs.db from windows that
	# should be removed
	find . -name Thumbs.db | xargs -r rm -rf
	find . -name .svn | xargs -r rm -rf

	cd "${S}"

	# preserve custom cflags passed to configure
	epatch "${FILESDIR}"/${P}-custom-cflags.patch

	# add nls support to the configure script
	epatch "${FILESDIR}"/${P}-add-nls.patch

	# This patch fixes compile errors when compiled with USE="-devbuild"
	epatch "${FILESDIR}"/${P}-fix-without-devbuild.patch
	
	eautoreconf -v --install || die "Error: eautoreconf failed!"
}

src_compile() {
	econf $(use_enable sse2) \
		$(use_enable devbuild) \
		$(use_enable debug) \
		$(use_enable recompiler recbuild) \
		$(use_enable vmbuild) \
		$(use_enable nls) \
		|| die "Error: econf failed!"
	emake || die "Error: emake failed!"
}

src_install() {
	dogamesbin "${FILESDIR}/pcsx2" || die "dogamesbin failed"
	exeinto "${GAMES_PREFIX_OPT}/${PN}"
	doexe Linux/${PN} || die "doexe failed"

	insinto "${GAMES_DATADIR}"/${PN}
	for i in $(ls -A ${WORKDIR}/bin/ | grep -v Langs | grep -v compat_list); do
		doins -r "${WORKDIR}/bin/${i}" || die "doins of ${i} failed"
	done

	insinto "${GAMES_DATADIR}/${PN}/Langs"
	keepdir "${GAMES_DATADIR}/${PN}/Langs"
	cd "${WORKDIR}"
	for i in ${LANGS}; do
		if use linguas_${i}; then
			doins -r bin/Langs/${i}_$(echo ${i} | tr 'a-z' 'A-Z') \
			|| die "Installation of language ${i} failed"
		fi
	done
	for i in ${LANGS1}; do
		if use linguas_${i}; then
			doins -r bin/Langs/${i} \
			|| die "Installation of language ${i} failed"
		fi
	done

	dodoc "${S}"/Docs/*.txt
	sed -i \
		-e "s:GAMES_PREFIX_OPT:${GAMES_PREFIX_OPT}:" \
		-e "s:GAMES_LIBDIR:$(games_get_libdir):" \
		-e "s:GAMES_DATADIR:${GAMES_DATADIR}:" \
		"${D}${GAMES_BINDIR}"/pcsx2 \
		|| die "sed failed"
	prepgamesdirs
}

pkg_postinst() {
	if ! use devbuild; then
		ewarn "If this package exhibits random crashes, recompile ${PN} with"
		ewarn "the devbuild use flag enabled. If that fixes it, file a bug."
	fi

	elog "Please note that this ebuild installs only a working"
	elog "graphics and pad plugin, and installs null plugins for"
	elog "everything else. You will need to install other ps2emu"
	elog "plugins in order to get full functionality"
}
