#!/bin/bash

eouc=`grep -n "END-OF-USER-CONFIGURATION" proto.ebuild | cut -d ":" -f 1`

for pkg in `find -mindepth 2 -maxdepth 2 -type d -not -name "CVS" -printf "%P\n"`; do
	if grep -q "END-OF-USER-CONFIGURATION" $pkg/*.ebuild; then
		first=""
		for ebuild in $pkg/*.ebuild; do
			if [ ${#first} -eq 0 ]; then
				first=$ebuild
			else
				if ! diff -q $first $ebuild >/dev/null; then
					echo "Error in $pkg: ebuilds differ:"
					diff -u $first $ebuild
				fi
			fi
		done
		lastline=`diff -n proto.ebuild $first | grep "^[ad]" | tail -n1 | sed "s:[ad]\([0-9]*\).*:\1:"`
		if [ $lastline -ge $[ $eouc - 3 ] ]; then
			echo "Error in $pkg: ebuild has modified lines after END-OF-USER-CONFIGURATION:"
			diff -u proto.ebuild $first
		fi
	fi
done
