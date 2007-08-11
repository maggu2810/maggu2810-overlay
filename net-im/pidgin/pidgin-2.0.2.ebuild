# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvsd/root/portage/net-im/pidgin/pidgin-2.0.2.ebuild,v 1.1 2007/07/25 20:45:56 oliver Exp $

WANT_AUTOMAKE=1.9

inherit flag-o-matic eutils toolchain-funcs multilib autotools perl-app gnome2

MY_PV=${P/_beta/beta}

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="http://pidgin.im/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="avahi bonjour crypt dbus debug doc eds gadu gnutls gstreamer meanwhile networkmanager nls perl silc startup-notification tcl tk xscreensaver spell qq gadu"
IUSE="${IUSE} gtk sasl ncurses groupwise prediction zephyr" # mono"

RDEPEND="
	bonjour? ( !avahi? ( net-misc/howl )
		   avahi? ( net-dns/avahi ) )
	dbus? ( >=dev-libs/dbus-glib-0.71
		>=dev-python/dbus-python-0.71
		>=sys-apps/dbus-0.90
		>=dev-lang/python-2.4 )
	gtk? (
		spell? ( >=app-text/gtkspell-2.0.2 )
		>=x11-libs/gtk+-2.0
		startup-notification? ( >=x11-libs/startup-notification-0.5 )
		xscreensaver? (	x11-libs/libXScrnSaver )
		eds? ( gnome-extra/evolution-data-server ) 	)
	>=dev-libs/glib-2.0
	gstreamer? ( =media-libs/gstreamer-0.10*
		     =media-libs/gst-plugins-good-0.10* )
	perl? ( >=dev-lang/perl-5.8.2-r1 )
	gadu?  ( net-libs/libgadu )
	gnutls? ( net-libs/gnutls )
	!gnutls? ( >=dev-libs/nss-3.11 )
	meanwhile? ( net-libs/meanwhile )
	silc? ( >=net-im/silc-toolkit-0.9.12-r3 )
	zephyr? ( >=app-crypt/mit-krb5-1.3.6-r1 )
	tcl? ( dev-lang/tcl )
	tk? ( dev-lang/tk )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	doc? ( app-doc/doxygen )
	dev-libs/libxml2
	networkmanager? ( net-misc/networkmanager )
	prediction? ( =dev-db/sqlite-3* )"
	#mono? ( dev-lang/mono )"

DEPEND="$RDEPEND
	dev-lang/perl
	dev-perl/XML-Parser
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_PV}"

# Enable Default protocols
DYNAMIC_PRPLS="irc,jabber,oscar,yahoo,zephyr,simple,msn"

# List of plugins yet to be ported (will be removed at some point)
#   net-im/gaim-bnet
#   net-im/gaim-snpp (will soon be net-im/pidgin-snpp)
#   x11-plugins/autoprofile
#   x11-plugins/gaim-otr
#   x11-plugins/gaim-xfire
#   x11-plugins/gaim-galago
#   x11-themes/gaim-smileys (get liquidx to fix it)

# Abandonned
#   x11-plugins/ignorance
#   x11-plugins/bangexec
#   x11-plugins/gaim-assistant
# Last release in 2004
#   net-im/gaim-blogger
#   x11-plugins/gaimosd
# Last release in 2005
#   app-accessibility/festival-gaim
# Merged into something else
#   net-im/gaim-meanwhile (integrated in gaim)
#   x11-plugins/gaim-libnotify (integrated into pidgin)
#   x11-plugins/gaim-slashexec (integrated into plugin pack)

# List of plugins
#   net-im/librvp
#   x11-plugins/gaim-rhythmbox
#   x11-plugins/guifications
#   x11-plugins/pidgin-encryption
#   x11-plugins/pidgin-extprefs
#   x11-plugins/pidgin-hotkeys
#   x11-plugins/pidgin-latex
#   x11-plugins/purple-plugin_pack

print_pidgin_warning() {
	ewarn
	ewarn "We strongly recommend that you backup your ~/.gaim directory"
	ewarn "before running Pidgin for the first time. Things you should be"
	ewarn "on the lookout for include problems with preferences being lost"
	ewarn "or forgotten, buddy icons not working as you expect, plugins or"
	ewarn "other external files not properly being found."
	ewarn
	ewarn "If you are merging ${MY_P} from an earlier version of gaim,"
	ewarn "you may need to re-merge any plugins like gaim-encryption or"
	ewarn " gaim-snpp (when they are ported to pidgin!)."
	ewarn
	ewarn "If you experience problems with pidgin, file them as bugs with"
	ewarn "Gentoo's bugzilla, http://bugs.gentoo.org.  DO NOT report them"
	ewarn "as bugs with pidgin's bug tracker, and by all means DO NOT"
	ewarn "seek help in #pidgin."
	ewarn
	ewarn "Be sure to USE=\"debug\" and include a backtrace for any seg"
	ewarn "faults, see http://developer.pidgin.im/wiki/GetABacktrace for details on"
	ewarn "backtraces."
	ewarn
	ewarn "Please read the pidgin FAQ at http://developer.pidgin.im/wiki/FAQ"
	ewarn
}

pkg_setup() {
	print_pidgin_warning

	if use bonjour && use avahi && ! built_with_use net-dns/avahi howl-compat ; then
	eerror
	eerror "You need to rebuild net-dns/avahi with USE=howl-compat in order"
	eerror  "to enable howl support for the bonjour protocol in pidgin."
	eerror
	die "Configure failed"
	fi

	if use gadu && built_with_use net-libs/libgadu ssl ; then
	eerror
	eerror "You need to rebuild net-libs/libgadu with USE=-ssl in order"
	eerror "enable gadu gadu support in pidgin."
	eerror
	die "Configure failed"
	fi

	if use ncurses &&  ! built_with_use sys-libs/ncurses unicode; then
		eerror
		eerror "You need to rebuild sys-libs/ncurses with USE=unicode in order"
		eerror "to build finch the console client of pidgin."
		eerror
		die "Configure failed"
	fi

	if ! use gtk && ! use ncurses ; then
		einfo
		elog "As you did not pick gtk or ncurses use flag, building"
		elog "console only."
		einfo
	fi

	if use zephyr && ! built_with_use app-crypt/mit-krb5 krb4 ; then
		eerror
		eerror "You need to rebuild app-crypt/mit-krb5 with USE=krb4 in order to"
		eerror "enable krb4 support for the zephyr protocol in pidgin"
		eerror
		die "Configure failed"
	fi

}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-2.0.0-cchar_t-undeclared.patch"
}

src_compile() {
	# Stabilize things, for your own good
	strip-flags
	replace-flags -O? -O2

	# -msse2 doesn't play nice on gcc 3.2
	[[ "`gcc-version`" == "3.2" ]] && filter-flags -msse2

	local myconf

	if use gadu; then
		DYNAMIC_PRPLS="${DYNAMIC_PRPLS},gg"
			myconf="${myconf} --with-gadu-includes=."
			myconf="${myconf} --with-gadu-libs=."
	fi

	if use silc; then
		DYNAMIC_PRPLS="${DYNAMIC_PRPLS},silc"
	fi

	if use qq; then
		DYNAMIC_PRPLS="${DYNAMIC_PRPLS},qq"
	fi

	if use meanwhile; then
		DYNAMIC_PRPLS="${DYNAMIC_PRPLS},sametime"
	fi

	if use bonjour; then
		DYNAMIC_PRPLS="${DYNAMIC_PRPLS},bonjour"
	fi

	if use groupwise; then
		DYNAMIC_PRPLS="${DYNAMIC_PRPLS},novell"
	fi

	if use zephyr; then
		DYNAMIC_PRPLS="${DYNAMIC_PRPLS},zephyr"
	fi

	if use gnutls ; then
		einfo "Disabling NSS, using GnuTLS"
		myconf="${myconf} --enable-nss=no --enable-gnutls=yes"
		myconf="${myconf} --with-gnutls-includes=/usr/include/gnutls"
		myconf="${myconf} --with-gnutls-libs=/usr/$(get_libdir)"
	else
		einfo "Disabling GnuTLS, using NSS"
		myconf="${myconf} --enable-gnutls=no --enable-nss=yes"
	fi

	if use xscreensaver ; then
			myconf="${myconf} --x-includes=/usr/include/X11"
	fi

	if ! use ncurses && ! use gtk; then
		myconf="${myconf} --enable-consoleui --disable-gtkui"
	else
		myconf="${myconf} $(use_enable ncurses consoleui) $(use_enable gtk gtkui)"
	fi

	econf \
		$(use_enable nls) \
		$(use_enable perl) \
		$(use_enable startup-notification) \
		$(use_enable tcl) \
		$(use_enable gtk sm) \
		$(use_enable spell gtkspell) \
		$(use_enable tk) \
		$(use_enable xscreensaver screensaver) \
		$(use_enable debug) \
		$(use_enable dbus) \
		$(use_enable meanwhile) \
		$(use_enable eds gevolution) \
		$(use_enable gstreamer) \
		$(use_enable sasl cyrus-sasl ) \
		$(use_enable doc doxygen) \
		$(use_enable prediction cap) \
		$(use_enable networkmanager nm) \
		$(use_with zephyr krb4) \
		"--with-dynamic-prpls=${DYNAMIC_PRPLS}" \
		--disable-mono \
		${myconf} || die "Configuration failed"
		#$(use_enable mono) \

		emake || die "make failed"
}

src_install() {
	gnome2_src_install
	use perl && fixlocalpod
	dodoc AUTHORS COPYING HACKING INSTALL NEWS README ChangeLog
}

pkg_postinst() {
	gnome2_pkg_postinst
	print_pidgin_warning
}
