#!/bin/bash

set -e

function check_make_conf() {
	USE=""
	source /etc/make.profile/make.defaults
	DEFUSE=" $USE "

	USE=""
	source /etc/make.conf

	res1=""
	res2=""
	for use in $USE; do
		if [ "$DEFUSE" != "${DEFUSE/ $use /}" ]; then
			printf "%-30s: already contained in the list of default USE flags\n" $use
			continue
		fi
		if [ "$use" != "${use#-}" -a "$DEFUSE" == "${DEFUSE/ ${use#-} /}" ]; then
			printf "%-30s: not contained in the list of default USE flags, no need to negate\n" $use
			continue
		fi
		usename=${use#-}
		usedinst=`eix --installed --use $usename --only-names | wc -l`
		usedall=`eix --use $usename --only-names | wc -l`
		printf "%-30s: used in %3d installed package(s) (%3d available package(s))\n" $use $usedinst $usedall
		if [ $usedall -gt 0 ]; then
			if [ $usedinst -eq 0 -o $usedall -le 2 ]; then
				echo "Flag used by only 2 available or no installed packages."
				[ $1 -eq 1 ] && {
					for pack in `eix --installed --use $usename --only-names`; do
						[ "$res2" ] && res2="$res2\n"
						res2="$res2$pack $use"
					done
				} || res1="$res1 $use"
			else
				res1="$res1 $use"
			fi
		fi
	done
	tmp1=`mktemp`
	tmp2=`mktemp`
	echo "Resulting USE list for make.conf is in $tmp1:"
	res1="`echo $res1`"
	USE="`echo $USE`"
	echo -e "${res1// /\n}" | sort | uniq > $tmp2
	echo -e "${USE// /\n}" | diff -u -s - $tmp2 | colordiff
	res_sort="`cat $tmp2`"
	res_sort="`echo $res_sort`"
	echo "USE=\"$res_sort\"" > $tmp1
	rm -f $tmp2
}

function check_package_use() {
	USE=""
	source /etc/make.conf
	GLOBUSE=" $USE "

	USE=""
	source /etc/make.profile/make.defaults
	DEFUSE=" $USE "

	cat /etc/portage/package.use | while true; do
		if ! read -r package flags; then
			tmp2=`mktemp`
			echo -e "$res2" | sort | uniq > $tmp2
			echo "Resulting portage.use file is in $tmp2:"
			diff -u -s /etc/portage/package.use $tmp2 | colordiff
			echo
			echo "Done."
			echo "Paste $tmp1 into /etc/make.conf to accept USE flag changes."
			echo "Copy file from $tmp2 to /etc/portage/package.use to accept package.use changes."
			echo "Do as root:"
			echo -e "\tcat $tmp1 >> /etc/make.conf"
			echo -e "\tcat $tmp2 > /etc/portage/package.use"
			echo
			echo "Packages may be listed twice with different USE flags in package.use."
			echo
			echo "emerge -upvDN world should not list anything new compared to before making the above changes."
			break
		fi
		pack=$package
		if [ $pack != ${pack#=} -o $pack != ${pack#<=} -o $pack != ${pack#>=} ]; then
			#TODO we remove all version information so the found package may not be the correct one
			pack=${pack#=}
			pack=${pack#<=}
			pack=${pack#>=}
			pack=${pack%-*}
		fi
		installed=`eix --installed --exact $pack --only-names | wc -l`
		exists=`eix  --exact $pack --only-names | wc -l`
		if [ $exists -eq 0 ]; then
			printf "%-40s doesn\'t exist in portage\n" $package
		else
			if [ $installed -eq 0 ]; then
				printf "%-40s is not installed\n" $package
				[ $3 -eq 1 ] && continue
			fi
			availflags1=" `FORMAT='<availableversionslong>' eix --exact $pack | sed -e "s/[^{]*//" -e "s/.*{\(.*\)}.*/\1/"` "
			if [ $installed -gt 0 ]; then
				availflags2=" `FORMAT='<installedversions:::::::@>' eix --exact $pack | grep @ | cut -d @ -f 2` "
				[ $2 -eq 1 ] && availflags1=""
			else
				availflags2=""
			fi
			availflags1="${availflags1// -/ }"
			availflags2="${availflags2// -/ }"
			notfound=""
			validflags=""
			for flag in $flags; do
				f=${flag#-}
				if [ "$availflags1" == "${availflags1/ $f /}" -a "$availflags2" == "${availflags2/ $f /}" ]; then
					notfound="$notfound $flag"
				else
					if [ "$GLOBUSE" != "${GLOBUSE/ $flag /}" ]; then
						echo "Flag already contained in make.conf: $flag"
						notfound="$notfound $flag"
					elif [ "$DEFUSE" != "${DEFUSE/ $flag /}" -a "$GLOBUSE" == "${GLOBUSE/ -$flag /}" ]; then
						echo "Flag already contained in default flags and not in make.conf: $flag"
						notfound="$notfound $flag"
					else
						validflags="$validflags $flag"
					fi
				fi
			done
			if [ "$notfound" ]; then
				printf "%-40s has invalid flag(s) in package.use: %s\n" $package "$notfound"
			fi
			validflags=${validflags## }
			if [ ${#validflags} -eq 0 ]; then
				echo "No valid flags remaining for package $package. Removed from portage.use."
			else
				[ "$res2" ] && res2="$res2\n"
				res2="$res2$package $validflags"
				printf "%-40s is a valid entry for package.use.\n" $package
			fi
		fi
	done
}

if [ $# -lt 3 ]; then
	echo "Syntax: $0 <make-local> <inst-only> <rem-not-inst>"
	echo "make-local:   0 or 1 => make USE flags in make.conf used by only 2 available or no"
	echo "                        installed packages local by putting them into portage.use."
	echo "inst-only:    0 or 1 => if a package is installed, remove not only invalid USE flags"
	echo "                        from portage.use but also all flags not availabe for the"
	echo "                        currently installed version."
	echo "rem-not-inst: 0 or 1 => remove all packages from portage.use which are not installed."
	echo
	echo "This script doesn't change anything in the etc directory but gives only suggestions,"
	echo "so it can safely be run as a normal user."

	exit
fi

check_make_conf $*
check_package_use $*
