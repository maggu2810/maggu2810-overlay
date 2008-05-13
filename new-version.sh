#/!bin/bash

[ "$1" ] || {
	echo "Syntax: `basename $0` <category>/<package-name>"
	exit 1
}

oldbuild=`ls ${1%%/}/*.ebuild | tail -n 1`
[[ "$oldbuild" =~ ^([^/]*)/[^/]*/([^/]*)-([0-9]*)\.([0-9]*)(.*)\.ebuild$ ]] || {
	echo "Cannot find a valid ebuild in '$1'"
	exit 1
}

categ=${BASH_REMATCH[1]}
pkg=${BASH_REMATCH[2]}
oldver1=${BASH_REMATCH[3]}
oldver2=${BASH_REMATCH[4]}
oldver3=${BASH_REMATCH[5]}

echo "Found $categ/$pkg with current version $oldver1.$oldver2$oldver3"

[ $oldver2 == 9 ] && {
	newver1=$[ 10#$oldver1 + 1 ]
	newver2=0
} || {
	newver1=$oldver1
	newver2=$[ 10#$oldver2 + 1 ]
}
newver3=$oldver3

echo "Creating new version $categ/$pkg-$newver1.$newver2$newver3"

patchfile="$categ/$pkg/files/$pkg-$newver1.$newver2$newver3.patch"
rm -f $patchfile

equery files $categ/$pkg | while read -r instfile; do
	[ -f "$instfile" ] || continue # skip directories etc.
	[[ "$instfile" =~ ^/etc/ ]] && continue # skip config files
	if="${instfile##*/}"
	fd="$categ/$pkg/files"
	orgfile=""
	of="$fd/$if"
	[ -f "$of" ] && orgfile="$of" || {
		of="$fd/${if%.*}"
		[ -f "$of" ] && orgfile="$of" || {
			of=`ls $fd/$if.*`
			[ -f "$of" ] && orgfile="$of" || {
				echo "Cannot find the orginal version of $instfile in $fd"
				exit 1
			}
		}
	}
	echo "$instfile => $orgfile"
	diff -u "$orgfile" "$instfile" >> "$patchfile"
done

oldbuild="$categ/$pkg/$pkg-$oldver1.$oldver2$oldver3.ebuild"
newbuild="$categ/$pkg/$pkg-$newver1.$newver2$newver3.ebuild"
cp -vf "$oldbuild" "$newbuild"
ebuild "$newbuild" digest
svn add "$newbuild" "$patchfile"
