#!/bin/bash
set -e

appid3get="id3 read"
appid3cp="id3 copy"
appdec="lame --decode"
appenc="lame --vbr-new -h"
appgain="mp3gain --auto"
tmpdirectory="/var/tmp"
movedir=""
quality="-V6"

replchars="s:[/\\]:_:g" # all characters are ok except slash and backslash

function recodefile() { #srcfile
	clear
	if [ $donecnt -gt 0 ]; then
		secs=$[ (`date +%s` - $starttime) * ($filecnt - $donecnt) / $donecnt ]
		echo "$[ $secs / 3600 ]:$[ $secs / 60 % 60 ]:$[ $secs % 60 ] remaining."
	fi
	donecnt=$[ $donecnt + 1 ]
	echo -e "Processing file $donecnt of $filecnt."

	srcfile="$1"
	$appid3get --short TALB TPE1 TIT2 TDRC TRCK TCON TCMP "$srcfile" | sed "$replchars" > "$tmptagfile"
	album=` head "$tmptagfile" -n 1 | tail -n 1`
	artist=`head "$tmptagfile" -n 2 | tail -n 1`
	title=` head "$tmptagfile" -n 3 | tail -n 1`
	year=`  head "$tmptagfile" -n 4 | tail -n 1`
	track=` head "$tmptagfile" -n 5 | tail -n 1`
	genre=` head "$tmptagfile" -n 6 | tail -n 1` # if it doesn't exist, it equals $track
	tcmp=`  head "$tmptagfile" -n 7 | tail -n 1` # if it doesn't exist, it equals $genre

	[ "$album" -a "$artist" -a "$title" -a "$year" -a "$genre" ] || {
		echo "Could not retrieve all fields of the input file:"
		echo "$srcfile"
		exit 1
	}

	[ "$genre" = "$track" ] && genre="Unknown"

	# If the genre is a number, we have to convert it to a name
	[ "`echo $genre | sed "s:[0-9]*::"`" ] || genre=`lame --genre-list | grep "^ *$genre" | cut -c 5-`

	# If the track number is less than 10, we have to add a zero
	track=${track%%_*}
	[ $track -lt 10 ] && track="0$track"

	if [ "$tcmp" == "1" ]; then
		subdir="$trgdir/$genre/Various Artists" # Format for Various Artists directory
		trgfile="$subdir/$year - $album - $track - $artist - $title.mp3" # Format for Various Artists filename
	else
		subdir="$trgdir/$genre/$artist" # Format for directory
		trgfile="$subdir/$year - $album - $track - $title.mp3" # Format for filename
	fi

	echo -e "Encoding $srcfile\nto $trgfile ...\n\n"

	if [ -e "$trgfile" ]; then
		echo "Target exists => File skipped"
		return
	fi

	if [ "$quality" == "copy" ]; then
		cp -f "$srcfile" "$tmptrgfile"
	else
		$appdec "$srcfile" "$tmpsrcfile" || { rm -f "$tmpsrcfile"; exit 1; }
		$appenc "$quality" "$tmpsrcfile" "$tmptrgfile" || { rm -f "$tmpsrcfile" "$tmptrgfile"; exit 1; }
		echo -n > "$tmpsrcfile"
	fi
	$appid3cp "$srcfile" "$tmptrgfile"
	$appgain "$tmptrgfile"

	# Finished with this file
	mkdir -p "$subdir"
	cp -f "$tmptrgfile" "$trgfile"
	echo -n > "$tmptrgfile"
	touch "$trgfile" --reference="$srcfile" || echo "Touching target file failed"

	if [ "$movedir" ]; then
		[ "$movedir" == "/dev/null" ] && rm -f "$srcfile" || mv -f "$srcfile" "$movedir"
	fi
}

function getfilecount() { #source
	source="$1"
	if [ -f "$source" ]; then
		filecnt=$[ $filecnt + 1 ]; else
		filecnt=$[ $filecnt + `find "$source" -iname "*.mp3" -type f | wc -l` ]
	fi
}

function recode() { #source
	source="$1"
	if [ -f "$source" ]; then recodefile "$source"; else
		tmplistfile=`mktemp`
		find "$source" -iname "*.mp3" -type f | sort > "$tmplistfile"
		while read -r f; do
			recodefile "$f"
		done < "$tmplistfile" || exit 1
		rm -f "$tmplistfile"
	fi
}

if [ $# -lt 2 ]; then
	echo "Syntax: $0 [Options...] <MP3-Sourcefile> <Target-Directory>"
	echo "Options: --move <Dir-For-Finished-Source-Files (default: don't move)"
	echo "         --quality -Vn with n=0..9 or --quality copy (default -V6)"
	echo "Examples:"
	echo " Copy all mp3 in current directory to /target/dir with new names according to id3 tags"
	echo "    $0 --quality copy *.mp3 /target/dir"
	echo " Reencode all mp3 in current directory with highest quality to /target/dir with new names according "
	echo " to id3 tags and move the original files to /old/files"
	echo "    $0 --quality -V9 --move /old/files *.mp3 /target/dir"
	echo " Rename all mp3 in current directory (and update their id3 tags and gain levels)"
	echo "    $0 --quality copy --move /dev/null *.mp3 ."
	exit 1
fi

while true; do
	if [ "$1" == "--move" ]; then
		movedir="$2"
		[ "$movedir" != "/dev/null" ] && mkdir -p "$movedir"
		shift 2
	elif [ "$1" == "--quality" ]; then
		quality="$2"
		shift 2
	else
		break
	fi
done

cnt=0
while [ $# -gt 0 ]; do
	sources[$cnt]="$1"
	trgdir="$1"
	cnt=$[ $cnt + 1 ]
	shift
done
cnt=$[ $cnt - 1 ] # Last one was the target directory

if [ ! -d $trgdir ]; then
	echo "Target directory $trgdir does not exist."
	exit 1
fi

tmpfile=`mktemp --tmpdir=$tmpdirectory`
rm -f "$tmpfile"
tmpsrcfile="$tmpfile.wav"
tmptrgfile="$tmpfile.mp3"
tmptagfile="$tmpfile.tag"

# only a few characters are allowed on FAT and NTFS
trgFS=`df -PT "$trgdir" | tail -n1 | sed "s/[^ ]* *\([^ ]*\).*/\1/"`
[ "$trgFS" == "fat" -o "$trgFS" == "ntfs" -o "$trgFS" == "vfat" -o "$trgFS" == "msdos" ] && \
	replchars="s:[^(){} 0-9a-zA-ZäüöÄÜÖ$%_@~!^#&-]:_:g"

filecnt=0
for ((i = 0; $i < $cnt; i++)); do
	getfilecount "${sources[$i]}"
done

donecnt=0
starttime=`date +%s`
for ((i = 0; $i < $cnt; i++)); do
	recode "${sources[$i]}"
done

rm -f "$tmpsrcfile" "$tmptrgfile"
echo "Finished."
