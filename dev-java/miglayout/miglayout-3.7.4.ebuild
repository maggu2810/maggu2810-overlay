# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit java-pkg-2

DESCRIPTION="Java Swing layout manager that's powerful and easy to use"

HOMEPAGE="http://www.miglayout.com/"
SRC_URI="http://www.migcalendar.com/miglayout/versions/${PV}/${P}-sources.jar"

# licensed under "BSD or GPL" (according to homepage...)
LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.5
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	mkdir classes api
}

src_compile() {
	ejavac -d classes net/miginfocom/swing/*.java || die "failed to compile sources in directory swing"
	jar -cf miglayout.jar -C classes net || die "failed to create .jar"
	if use doc; then
		javadoc -author -version -d api net/miginfocom/layout/*.java \
			|| die "javadoc failed"
	fi
}

src_install() {
	java-pkg_dojar ${PN}.jar
	if use doc; then
		java-pkg_dojavadoc api
	fi
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins net/miginfocom/examples/*
	fi
	use source && java-pkg_dosrc net/miginfocom/layout
}
