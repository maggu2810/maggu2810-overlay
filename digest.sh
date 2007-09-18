#!/bin/bash

for ebuild in */*/*.ebuild; do
	if grep -q "END-OF-USER-CONFIG" $ebuild; then
		ebuild $ebuild fetch
		ebuild $ebuild digest
	fi
done
