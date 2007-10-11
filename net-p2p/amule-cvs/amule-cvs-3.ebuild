# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Based on the ebuild by 'mascanho' @ forums.gentoo.org

inherit eutils flag-o-matic wxwidgets

MY_P=${P/cvs-${PV}/cvs}
S=${WORKDIR}/${MY_P}

# Always use todays snapshot by default
DATE=$(date +%Y%m%d)
# Uncomment and edit this line to use a specific date
# Format is <Year><Month><Day>
DATE=20071011

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
SRC_URI="http://www.hirnriss.net/files/cvs/aMule-CVS-${DATE}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="amuled debug gtk nls nosystray optimize remote remote-gui stats unicode X patching"
for f in ${FILESDIR}/[0-9][0-9]-*.patch; do
	u=${f##*/}
	u=${u#*-}
	u=${u%.*}
	IUSE="${IUSE} no-$u"
done

RESTRICT="nostrip nomirror"

DEPEND="
        gtk2? ( >=x11-libs/wxGTK-2.6.0 )
        amuled? ( >=x11-libs/wxGTK-2.6.0 )
        !gtk2? ( !amuled? ( >=x11-libs/wxGTK-2.6.0 ) )
        >=sys-libs/zlib-1.2.1
        stats? ( >=media-libs/gd-2.0.26 )
        remote? ( >=media-libs/libpng-1.2.0 )
        !net-p2p/amule
        !net-p2p/xmule"

pkg_setup() {
	export WX_GTK_VER="2.8"
	if use unicode && use gtk; then
		need-wxwidgets unicode
	elif use gtk; then
		need-wxwidgets gtk2
	elif use unicode; then
		need-wxwidgets base-unicode
	else
		need-wxwidgets base
	fi

	if use optimize && use debug; then
		eerror "If you want to debug, don't optimize!!!"
		eerror "Use only one of 'optimize' or 'debug', not both "
		die "Invalid USE flags"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	if use patching; then
		for f in ${FILESDIR}/[0-9][0-9]-*.patch; do
			u=${f##*/}
			u=${u#*-}
			u=${u%.*}
			use no-$u && einfo "Skipping $(basename $f)" || epatch $f
		done
	fi
	sed -i -r "s:\\$\\(LN_S\\) (.*):\$\(LN_S\) ${D}/\1:g" docs/man/Makefile.in
}

src_compile() {
#	cd /var/tmp/portage/amule-cvs-1/work/amule-cvs/
	cd ${S}
	local myconf

	if ! use X; then
		myconf="${myconf} --disable-monolithic"
	fi

	if use nosystray || ! use X; then
		myconf="${myconf} --disable-systray"
	elif use unicode; then
		myconf="${myconf} --enable-utf8-systray"
	fi

	if use remote-gui && use stats; then
		myconf="${myconf} --enable-wxcas --enable-alc"
	else
		myconf="${myconf} --disable-wxcas --disable-alc"
	fi

	if use remote-gui && ! use remote; then
		eerror "You can't build the remote GUI apps, if you don't build also the remote apps!"
		einfo "Enabling 'remote' USE flag!!!"
		myconf="${myconf} --enable-webserver --enable-amulecmd"
	fi
	
	if use remote; then
		myconf="${myconf} --enable-webserver --enable-amulecmd"
	fi

	if use remote && use amuled; then
		myconf="${myconf} --enable-amule-gui"
	fi
	
	econf \
		--with-wx-config=${WX_CONFIG} \
		--with-wxbase-config=${WX_CONFIG} \
		`use_with gtk x` \
		`use_enable amuled amule-daemon` \
		`use_enable optimize` \
		`use_enable debug` \
		`use_enable nls` \
		`use_enable remote-gui amulecmdgui` \
		`use_enable remote-gui webservergui` \
		`use_enable stats cas` \
		`use_enable stats alcc` \
		${myconf} \
		|| die
	
	# we filter ssp until bug #74457 is closed to build on hardened
	if has_hardened; then
		filter-flags -fstack-protector -fstack-protector-all
	fi
	emake -j1 || die
}

src_install() {
#	cd /var/tmp/portage/amule-cvs-1/work/amule-cvs/
	cd ${S}
	make DESTDIR=${D} install || die

	if use amuled || use remote; then
		if ! id p2p >/dev/null; then
	        enewgroup p2p
			enewuser p2p -1 -1 /home/p2p p2p
		fi
	fi

	if use amuled; then
	        insinto /etc/conf.d; newins ${FILESDIR}/amuled.confd amuled
	        exeinto /etc/init.d; newexe ${FILESDIR}/amuled.initd amuled
	fi

	if use remote; then
	        insinto /etc/conf.d; newins ${FILESDIR}/amuleweb.confd amuleweb
	        exeinto /etc/init.d; newexe ${FILESDIR}/amuleweb.initd amuleweb
	fi
}
