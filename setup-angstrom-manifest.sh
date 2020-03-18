#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 ANGSTROM_BRANCH" >&2
  exit 1
fi

ANGSTROM_BRANCH="$1"
MAN_DIR="${ANGSTROM_BRANCH}-manifest"

if [ -d $MAN_DIR ]; then
	echo "$MAN_DIR exists"
	exit 1
fi

mkdir $MAN_DIR
cd $MAN_DIR

repo init -u git://github.com/fmhess/angstrom-manifest -b ${ANGSTROM_BRANCH}
python3 .repo/repo/repo sync

MACHINE=fluke-cda-nighthawk source ./setup-environment ""

# Change download and cache dirs
sed -i "s/DL_DIR.*/DL_DIR = \"\$\{TOPDIR\}\/..\/${ANGSTROM_BRANCH}-manifest-downloads\/\"/" conf/site.conf
sed -i "s/SSTATE_DIR.*/SSTATE_DIR = \"\$\{TOPDIR\}\/..\/${ANGSTROM_BRANCH}-manifest-sstate-cache\/\"/" conf/site.conf

cat <<EndOfFile >> conf/site.conf
#uncomment to generate source tarballs under the deploy directory
#INHERIT += "archiver"
#ARCHIVER_MODE[src] = "patched"
EndOfFile
