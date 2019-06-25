#!/bin/bash

[ "$1" ] || {
	echo "Syntax: $0 <type of proto>"
	exit 1
}

eouc=`grep -n "END-OF-USER-CONFIG $1" proto-$1.ebuild | cut -d ":" -f 1`

for pkg in `find -mindepth 2 -maxdepth 2 -type d -not -name ".svn" -printf "%P\n"`; do
	if grep -q "END-OF-USER-CONFIG $1" $pkg/*.ebuild 2>/dev/null; then
		echo "Checking $pkg"
		first=`ls $pkg/*.ebuild`
		first=${first%%.ebuild*}.ebuild
		lastline=`diff -n proto-$1.ebuild $first | grep "^[ad]" | tail -n1 | sed "s:[ad]\([0-9]*\).*:\1:"`
		if [ $lastline -ge $[ $eouc -3 ] ]; then
			line=`grep -n "END-OF-USER-CONFIG $1" $first | cut -d ":" -f 1`
			tail -n $[ `cat proto-$1.ebuild | wc -l` - $eouc - 1 ] proto-$1.ebuild > /tmp/pck1.tmp
			tail -n $[ `cat $first | wc -l` - $line - 1 ] $first > /tmp/pck2.tmp
			diff -u /tmp/pck[12].tmp | colordiff
			echo "Error in $pkg: ebuild has modified lines after END-OF-USER-CONFIG $1"
			echo -n "Correct (y/N)? "
			read asw
			if [ "$asw" = "y" ]; then
				line=`grep -n "END-OF-USER-CONFIG $1" $first | cut -d ":" -f 1`
				head -n $[ $line + 1 ] $first > /tmp/pck.tmp
				tail -n $[ `cat proto-$1.ebuild | wc -l` - $eouc - 1 ] proto-$1.ebuild >> /tmp/pck.tmp
				mv /tmp/pck.tmp $first
			fi
		fi
		for ebuild in $pkg/*.ebuild; do
			diff -u proto-$1.ebuild $ebuild | colordiff
			if [ $first != $ebuild ]; then
				if ! diff -q $first $ebuild >/dev/null; then
					diff -u $first $ebuild | colordiff
					echo "Error in $pkg: ebuilds differ"
					echo -n "Correct (y/N)? "
					read asw
					if [ "$asw" = "y" ]; then
						cp -f $first $ebuild
					fi
				fi
			fi
		done
	fi
done

