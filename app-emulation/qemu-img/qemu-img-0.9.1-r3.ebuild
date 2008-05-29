# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="qemu-img from the Qemu package"
HOMEPAGE="http://fabrice.bellard.free.fr/qemu/"
SRC_URI="${HOMEPAGE}${P/-img/}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-alpha amd64 ppc -sparc x86"
IUSE=""
RESTRICT="binchecks test"

DEPEND="virtual/libc
	sys-libs/zlib
	sdl? ( media-libs/libsdl )
	app-text/texi2html
	!app-emulation/qemu-softmmu"
RDEPEND="sys-libs/zlib"

S=${WORKDIR}/${P/-img/}

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-CVE-2008-0928.patch" #212351
	# Alter target makefiles to accept CFLAGS set via flag-o.
	sed -i 's/^\(C\|OP_C\|HELPER_C\)FLAGS=/\1FLAGS+=/' \
		Makefile Makefile.target tests/Makefile
	# Ensure mprotect restrictions are relaxed for emulator binaries
	[[ -x /sbin/paxctl ]] && \
		sed -i 's/^VL_LDFLAGS=$/VL_LDFLAGS=-Wl,-z,execheap/' \
			Makefile.target
	# Prevent install of kernel module by qemu's makefile
	sed -i 's/\(.\/install.sh\)/#\1/' Makefile
	# avoid strip
	sed -i 's:$(INSTALL) -m 755 -s:$(INSTALL) -m 755:' Makefile Makefile.target
}

src_compile() {
	./configure --prefix=/usr --enable-adlib --cc=$(tc-getCC) \
	--host-cc=$(tc-getCC) --disable-gcc-check || die "could not configure"
	emake qemu-img || die "make failed"
}

src_install() {
	dobin "${S}/qemu-img" || die
}
