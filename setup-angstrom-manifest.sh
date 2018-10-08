#!/bin/bash
ANGSTROM_BRANCH=angstrom-v2017.06-yocto2.3-fluke-cda
MAN_DIR=${ANGSTROM_BRANCH}-manifest

if [ -d $MAN_DIR ]; then
	echo "$MAN_DIR exists"
	exit 1
fi

mkdir $MAN_DIR
cd $MAN_DIR

repo init -u git://github.com/fmhess/angstrom-manifest -b ${ANGSTROM_BRANCH}
repo sync

MACHINE=fluke-cda-nighthawk . ./setup-environment

# Change download and cache dirs
sed -i "s/DL_DIR.*/DL_DIR = \"\$\{TOPDIR\}\/..\/${ANGSTROM_BRANCH}-manifest-downloads\/\"/" conf/site.conf
sed -i "s/SSTATE_DIR.*/SSTATE_DIR = \"\$\{TOPDIR\}\/..\/${ANGSTROM_BRANCH}-manifest-sstate-cache\/\"/" conf/site.conf



