#!/bin/bash

set -e

[ -e /etc/vdr2avi.cfg ] && source /etc/vdr2avi.cfg
[ -e ~/.vdr2avi.cfg ] && source ~/.vdr2avi.cfg
[ -e vdr2avi.cfg ] && source vdr2avi.cfg

if [ "$VDR_RECORD_STATE" = "after" ]; then
	[[ $VDR_RECORD_NAME =~ ^$VID_PATH/(.*) ]]
	rec=${BASH_REMATCH[1]}
	echo "Starting pass1 for $rec" >> $LOG_FILE
	$NICE_VDR2AVI vdr2avi 1 "$rec" >>$LOG_FILE 2>>$ERR_FILE
fi
