# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyQt4/PyQt4-4.1.1.ebuild,v 1.1 2006/12/20 14:33:50 jokey Exp $

inherit distutils

MY_P="PyQt-x11-gpl-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="PyQt is a set of Python bindings for the Qt toolkit."
HOMEPAGE="http://www.riverbankcomputing.co.uk/pyqt/"
#SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
SRC_URI="http://www.riverbankcomputing.com/Downloads/PyQt4/GPL/${MY_P}.tar.gz"
#SRC_URI="http://www.riverbankcomputing.com/Downloads/Snapshots/PyQt3/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples"

RDEPEND="=x11-libs/qt-4*
	>=dev-python/sip-4.5"
DEPEND="${RDEPEND}
	sys-devel/libtool"


src_unpack() {
	unpack ${A}
	sed -i -e "s:^[ \t]*check_license():# check_license():" ${S}/configure.py
	sed -i -e "s:join(qt_dir, \"mkspecs\":join(\"/usr/share/qt4\",	\"mkspecs\":g" ${S}/configure.py
	sed -i -e "s:\"QT_INSTALL_HEADERS\"\:   os.path.join(qt_dir, \"include\":\"QT_INSTALL_HEADERS\"\:   os.path.join(qt_dir, \"include/qt4\":g" ${S}/configure.py
	sed -i -e "s:\"QT_INSTALL_LIBS\"\:      os.path.join(qt_dir, \"lib\":\"QT_INSTALL_LIBS\"\:      os.path.join(qt_dir, \"lib/qt4\":g" ${S}/configure.py
	cd ${S}
	#epatch "${FILESDIR}"/my.patch
}

src_compile() {
	distutils_python_version
	addpredict ${QTDIR}/etc/settings

	local myconf="-d ${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/PyQt4 \
			-b ${ROOT}/usr/bin \
			-v ${ROOT}/usr/share/sip" #\
#			-n ${ROOT}/usr/include \
#			-o ${ROOT}/usr/$(get_libdir) \
#			-w -y qt-mt"
	use debug && myconf="${myconf} -u"

	python configure.py ${myconf}
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc ChangeLog LICENSE NEWS README README.Linux THANKS
	use doc && dohtml doc/PyQt.html
	if use examples ; then
		dodir /usr/share/doc/${PF}/examples
		cp -r examples/* ${D}/usr/share/doc/${PF}/examples
	fi
}
