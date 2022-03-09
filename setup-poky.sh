#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 POKY_BRANCH" >&2
  exit 1
fi

POKY_BRANCH="$1"
POKY_TOP_DIR="poky-${POKY_BRANCH}"

if [ -d $POKY_TOP_DIR ]; then
	echo "$POKY_TOP_DIR already exists, aborting."
	exit 1
fi

# the version of repo in Ubuntu 18.04.6 LTS is broken, so try to 
# bootstrap up to a working version.
mkdir -p bin
curl https://storage.googleapis.com/git-repo-downloads/repo > bin/repo
chmod a+rx bin/repo

mkdir $POKY_TOP_DIR
cd $POKY_TOP_DIR

../bin/repo init -u https://github.com/fmhess/poky-fluke-cda-manifest -b ${POKY_BRANCH} ||
    python3 ../bin/repo init -u https://github.com/fmhess/poky-fluke-cda-manifest -b ${POKY_BRANCH}
python3 .repo/repo/repo sync

mkdir -p build/conf/
ln -sr manifest/conf/local.conf build/conf/
ln -sr manifest/conf/bblayers.conf build/conf/

DEFAULT_MACHINE="fluke-cda-nighthawk"
cat <<EndOfFile > build/conf/site.conf
#MACHINE = "fluke-cda-nighthawk"
# iWave Zynq dev board
#MACHINE = "zynq-iwg28m"
MACHINE = "$DEFAULT_MACHINE"

EndOfFile

echo
echo "The subdirectory \"$POKY_TOP_DIR\" has been set up.  To begin run the commands:"
echo
echo "cd $POKY_TOP_DIR"
echo "source oe-init-build-env"
echo
echo "The MACHINE variable has been set to \"$DEFAULT_MACHINE\"."
echo "If you wish to change MACHINE, edit it in \"$POKY_TOP_DIR/build/conf/site.conf\"."
echo
