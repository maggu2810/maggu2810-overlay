#!/bin/bash

for ebuild in */*/*.ebuild; do
	if grep -q "END-OF-USER-CONFIGURATION" $ebuild; then
		ebuild $ebuild fetch
		ebuild $ebuild digest
	fi
done
