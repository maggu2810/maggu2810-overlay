#
# file: vdr-xineliboutput-cvs-0.ebuild
#
inherit vdr-plugin eutils multilib cvs

DESCRIPTION="Video Disk Recorder Xinelib PlugIn"
HOMEPAGE="http://sourceforge.net/projects/xineliboutput"
KEYWORDS=""
SLOT="0"

ECVS_SERVER="xineliboutput.cvs.sourceforge.net:/cvsroot/xineliboutput"
ECVS_MODULE="vdr-xineliboutput"

RDEPEND=">=media-video/vdr-1.3.42
	>=media-libs/xine-lib-1.1.1
	media-libs/jpeg
	|| ( (
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
		x11-proto/xproto
	)
	virtual/x11
)"

DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	|| ( (
		x11-libs/libX11
		x11-libs/libXv
		x11-libs/libXext
	)
	virtual/x11
)"

S="${WORKDIR}/${ECVS_MODULE}"

pkg_setup() {
	vdr-plugin_pkg_setup
	XINE_LIB_VERSION=$(awk -F'"' '/XINE_VERSION/ {print $2}' /usr/include/xine.h)
}

src_unpack() {
	cvs_src_unpack
	
	vdr-plugin_src_unpack add_local_patch patchmakefile
	
	cd ${S}
	einfo "Enabling all configuration options"
	sed -i.orig Makefile -e 's:^#XINELIBOUTPUT:XINELIBOUTPUT:'
	
	# patching makefile to work with this
	# $ rm ${outdir}/file; cp file ${outdir}/file
	# work in the sandbox
	sed -i.orig Makefile -e 's:XINEPLUGINDIR.*=.*:XINEPLUGINDIR = '"${WORKDIR}/lib:"
	mkdir -p ${WORKDIR}/lib
	
	MY_PV=$(awk -F'"' '/static const char \*VERSION/ {print $2}' xineliboutput.c)
}

src_install() {
	vdr-plugin_src_install
	
	dobin vdr-fbfe vdr-sxfe

	insinto ${VDR_PLUGIN_DIR}
	doins *.so.${MY_PV}

	insinto /usr/$(get_libdir)/xine/plugins/${XINE_LIB_VERSION}
	doins xineplug_inp_xvdr.so
}
