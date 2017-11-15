#!/bin/bash
MAN_DIR=angstrom-manifest-krogoth-fluke-cda

if [ -d $MAN_DIR ]; then
	echo "$MAN_DIR exists"
	exit 1
fi

mkdir $MAN_DIR
cd $MAN_DIR

repo init -u git://github.com/Angstrom-distribution/angstrom-manifest -b angstrom-v2017.06-yocto2.3

sed -i 's/^.*<project.*name="linux4sam\/meta-atmel".*$//g' .repo/manifest.xml

repo sync

git clone https://github.com/fmhess/meta-fluke-cda.git layers/meta-fluke-cda

sed -i '/meta-altera/a \ \ \$\{TOPDIR\}\/layers\/meta-fluke-cda \\' .repo/manifests/conf/bblayers.conf
sed -i '/^.*meta-atmel.*$/d' .repo/manifests/conf/bblayers.conf

cp ../local.conf .repo/manifests/conf/local.conf

MACHINE=fluke-cda-nighthawk . ./setup-environment

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


