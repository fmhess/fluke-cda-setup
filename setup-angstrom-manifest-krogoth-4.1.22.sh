#!/bin/bash
MAN_DIR=angstrom-manifest-krogoth-fluke-cda

if [ -d $MAN_DIR ]; then
	echo "$MAN_DIR exists"
	exit 1
fi

mkdir $MAN_DIR
cd $MAN_DIR

repo init -u git://github.com/Angstrom-distribution/angstrom-manifest -b angstrom-v2016.06-yocto2.1

sed -i 's/\(^.*<project name="linux4sam\/meta-atmel".*revision="df10071966a78f0a808216bd02cf961b171cbb0c" upstream=\)"master"\(.*$\)/\1"morty"\2/g' .repo/manifest.xml
#sed -i 's/^.*meta-altera.*$/\ \ \<project name="kraj\/meta-altera" path="layers\/meta-altera" remote="github" revision="b5fe6b230fcd2e70dd4662778aadc318eb097678"\/\>/g' .repo/manifest.xml
#sed -i 's/^.*meta-altera.*$/\ \ \<project name="\/data\/dwesterg\/github\/meta-altera-1" path="layers\/meta-altera" revision="master"\/\>/g' .repo/manifest.xml

#sed -i '/git.yoctoproject.org/a \ \ \<remote fetch="ssh+git:\/\/sj-ice-nx2.altera.com" name="internal"\/\>' .repo/manifest.xml

#sed -i '/meta-altera/a \ \ <project name="data/fae/dwesterg/public/git/meta-altera-atlas-sockit.git" path="layers/meta-altera-atlas-sockit" remote="internal" revision="master" upstream="master"/>' .repo/manifest.xml

repo sync

cp -a ../meta-fluke-cda layers

MACHINE=fluke-cda-nighthawk . ./setup-environment

sed -i '/meta-altera/a \ \ \$\{TOPDIR\}\/layers\/meta-fluke-cda \\' conf/bblayers.conf

# get rid of layers that cause conflicts
#sed -i '/meta-photography/d' conf/bblayers.conf
#sed -i '/meta-atmel/d' conf/bblayers.conf
#sed -i '/meta-kde4/d' conf/bblayers.conf
#sed -i '/meta-uav/d' conf/bblayers.conf
#sed -i '/meta-edison/d' conf/bblayers.conf

# Change download and cache dirs
sed -i '/DL_DIR/d' conf/site.conf
#sed -i '/SSTATE_DIR/d' conf/site.conf
echo "DL_DIR = \"\${TOPDIR}/../angstrom-manifest-downloads\"" >> conf/site.conf
echo "SSTATE_DIR = \"\${TOPDIR}/../angstrom-manifest-sstate-cache\"" >> conf/site.conf

echo '# SOURCE_MIRROR_URL ?= "file:///data/angstrom-builds/downloads/krogoth"' >> conf/site.conf
echo '# INHERIT += "own-mirrors"' >> conf/site.conf
echo 'BB_GENERATE_MIRROR_TARBALLS = "1"' >> conf/site.conf
echo '# BB_NO_NETWORK = "1"' >> conf/site.conf

#echo "PREFERRED_PROVIDER_virtual/kernel = \"linux-altera-ltsi\"" >> conf/local.conf
#echo "PREFERRED_VERSION_linux-altera-ltsi = \"4.1%\"" >> conf/local.conf
#echo "PREFERRED_PROVIDER_virtual/bootloader = \"u-boot-socfpga\"" >> conf/local.conf
#echo "PREFERRED_VERSION_u-boot-socfpga = \"2016.03%\"" >> conf/local.conf
#echo "UBOOT_CONFIG = \"de0-nano-soc\"" >> conf/local.conf
#echo "GCCVERSION = \"linaro-4.9%\"" >> conf/local.conf
