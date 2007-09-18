#!/bin/bash

set -e

HAS_C=0
HAS_CXX=0

function create_makefile_src() { # skip
	echo "Creating source Makefile.am ..."
	SOURCES=""
	for f in *.[ch] *.cpp *.cxx *.hh; do
		if [ -f "$f" ]; then
			[ "$f" != "${f%.c}" ] && HAS_C=1
			[ "$f" != "${f%.cpp}" ] && HAS_CXX=1
			[ "$f" != "${f%.cxx}" ] && HAS_CXX=1
			SOURCES="$SOURCES $f"
		fi
	done
	if [ "$1" == "skip" ]; then
		echo "Skipped"
		return
	fi
	echo "if COLORGCC" >> Makefile.am
	echo "override CXX = /usr/lib/colorgcc/bin/g++" >> Makefile.am
	echo "endif" >> Makefile.am
	echo >> Makefile.am
	echo "bin_PROGRAMS = $PROGNAME" >> Makefile.am
	echo >> Makefile.am
	echo "${PROGNAME}_SOURCES =$SOURCES" >> Makefile.am
	echo >> Makefile.am
	echo "${PROGNAME}_LDADD = " >> Makefile.am
	echo >> Makefile.am
	echo "INCLUDES = -Wall -Wextra -Wformat-y2k -Wformat-nonliteral -Wformat-security -Winit-self \\" >> Makefile.am
	echo "  -Wmissing-include-dirs -Wswitch-default -Wswitch-enum -Wunused-parameter -Wunknown-pragmas \\" >> Makefile.am
	echo "  -Wstrict-aliasing=2 -Wstrict-overflow=5 -Wfloat-equal -Wundef -Wunsafe-loop-optimizations \\" >> Makefile.am
	echo "  -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wconversion -Wmissing-noreturn \\" >> Makefile.am
	echo "  -Wmissing-format-attribute -Wnormalized=nfkc -Wpacked -Wpadded -Wredundant-decls \\" >> Makefile.am
	echo "  -Winvalid-pch -Wvolatile-register-var -Wdisabled-optimization -Wstack-protector -Wcomments \\" >> Makefile.am
	echo -n "  -Wundef -Wunused-macros" >> Makefile.am
	if [ "$HAS_C" == "1" ]; then
		echo " \\" >> Makefile.am
		echo "    -Wbad-function-cast -Wstrict-prototypes -Wold-style-definition \\" >> Makefile.am
		echo -n "    -Wmissing-prototypes -Wmissing-declarations -Wnested-externs" >> Makefile.am
	fi
	if [ "$HAS_CXX" == "1" ]; then
		echo " \\" >> Makefile.am
		echo "    -Wctor-dtor-privacy -Weffc++ -Wstrict-null-sentinel -Wold-style-cast \\" >> Makefile.am
		echo -n "    -Woverloaded-virtual -Wsign-promo" >> Makefile.am
	fi
	echo >> Makefile.am
}

function create_makefile_main() { # subdir skip
	echo "Creating main Makefile.am ..."
	if [ "$2" == "skip" ]; then
		echo "Skipped"
		return
	fi
	[ "$1" ] && echo "SUBDIRS = $1" >> Makefile.am
	[ -f "test.sh" ] && echo "TESTS = test.sh" >> Makefile.am
	:
}

function create_configure() { #subdir
	echo "Creating configure.in ..."
	echo "AC_PREREQ(`autoconf --version | head -n 1 | cut -d " " -f 4`)" >> configure.in
	echo "AC_INIT([$PROGNAME], [0.1], [oliver.hoffmann@uni-ulm.de])" >> configure.in
	echo "AM_INIT_AUTOMAKE([`automake --version | head -n 1 | cut -d " " -f 4` foreign])" >> configure.in
	echo "AM_CONDITIONAL(COLORGCC, test -e /usr/lib/colorgcc/bin/g++ )" >> configure.in

	[ $HAS_C == 1 ] && echo "AC_PROG_CC" >> configure.in
	[ $HAS_CXX == 1 ] && echo "AC_PROG_CXX" >> configure.in

	echo "AC_CONFIG_FILES([Makefile`[ "$1" ] && echo " $1/Makefile"`])" >> configure.in 
	echo "AC_OUTPUT" >> configure.in
}

function merge_configure_scan() {
	echo "Updating configure.in ..."
	sed -i "s/FULL-PACKAGE-NAME/$PROGNAME/g" configure.scan
	sed -i "s/VERSION/0.1/g" configure.scan
	sed -i "s/BUG-REPORT-ADDRESS/oliver.hoffmann@uni-ulm.de/g" configure.scan
	line=`grep -n "^AC_INIT(" configure.scan | cut -d ":" -f 1`
	len=`cat configure.scan | wc -l`
	head -n $line configure.scan > configure.in
	echo "AM_INIT_AUTOMAKE([`automake --version | head -n 1 | cut -d " " -f 4` foreign])" >> configure.in
	echo "AM_CONDITIONAL(COLORGCC, test -e /usr/lib/colorgcc/bin/g++ )" >> configure.in
	tail -n $[ $len - $line ] configure.scan >> configure.in
	rm -f configure.scan autoscan-*.log
}

function create_cvs_ignore() {
echo ".deps
Makefile
Makefile.in
aclocal.m4
autom4te.cache
config.h
config.h.in
config.log
config.status
configure
stamp-h1
$PROGNAME
" >> .cvsignore
}

function create_bootstrap() {
echo "#!/bin/bash
set -e
echo \"Running aclocal ...\"
aclocal
echo \"Running autoheader ...\"
autoheader
echo \"Running automake ...\"
automake --gnu --add-missing
echo \"Running autoconf ...\"
autoconf
echo \"Bootstrapping finished\"" > bootstrap
chmod 755 bootstrap
}

[ "$1" == "remove" ] && {
	rm -f -r autom4te.cache .deps
	rm -f aclocal.m4 autoscan-*.log bootstrap config.h config.h.in config.log config.status configure
	rm -f configure.in configure.scan depcomp install-sh missing stamp-h1
	rm -f Makefile.am Makefile.in Makefile
	[ -d "src" ] && {
		rm -f -r src/.deps 
		rm -f src/Makefile.am src/Makefile.in src/Makefile
	}
	exit 
}

[ "$1" != "prep" ] && {
	echo "Syntax: $0 prep|remove"
	echo "prep:   prepare a C or C++ project with existing source files in . or in src/"
	echo "        for autotools usage."
	echo "remove: remove all autotools relevant files from the current directory and"
	echo "        the src/ subdirectory."
	exit 1
}


WD=`pwd`
PROGNAME=`basename $WD`
rm -f makefile Makefile configure.in
[ -e "Makefile.am" ] && skip="skip" || skip=""
if [ -d "src" ]; then
	create_makefile_main "src" $skip
	cd src
	create_makefile_src $skip
	cd ..	
	create_configure "src"
else
	create_makefile_main "" $skip
	create_makefile_src $skip
	create_configure
fi

echo "Running AutoTools..."
aclocal
autoconf
automake --gnu --add-missing
autoscan
merge_configure_scan

echo "Running bootstrap ..."
create_bootstrap
./bootstrap

echo "Running configure and make ..."
./configure --prefix=/usr
make clean all || :

echo "Updating .cvsignore and adding files to CVS/SVN ..."
create_cvs_ignore
svn add bootstrap Makefile.am configure.in .cvsignore || :
mv Makefile Makefile.temprenamed
svn delete makefile Makefile || :
mv Makefile.temprenamed Makefile
if [ -d "src" ]; then 
	echo "Makefile
Makefile.in
$PROGNAME" >> src/.cvsignore
	svn add src/Makefile.am src/.cvsignore || :
fi
