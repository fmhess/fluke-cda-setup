#!/bin/bash
ANGSTROM_BRANCH=angstrom-v2017.06-yocto2.3
MAN_DIR=${ANGSTROM_BRANCH}-manifest-fluke-cda

if [ -d $MAN_DIR ]; then
	echo "$MAN_DIR exists"
	exit 1
fi

mkdir $MAN_DIR
cd $MAN_DIR

repo init -u git://github.com/Angstrom-distribution/angstrom-manifest -b ${ANGSTROM_BRANCH}

sed -i 's/^.*<project.*name="linux4sam\/meta-atmel".*$//g' .repo/manifest.xml

# use specific versions of Angstrom and openembedded if they break things on the branch HEAD
#sed -i 's/revision="angstrom-v2017.06-yocto2.3"/revision="8e2f5bb1d814396b0487fe52e94d4ebd6a3634c5"/' .repo/manifest.xml
#sed -i 's|\(name="openembedded/openembedded-core"\)|\1 revision="ac2aad028daca6ea3aa0c0ccea8d528e896f8349"|' .repo/manifest.xml
#sed -i 's|\(name="openembedded/meta-openembedded"\)|\1 revision="dfbdd28d206a74bf264c2f7ee0f7b3e5af587796"|' .repo/manifest.xml

repo sync

sed -i '/meta-altera/a \ \ \$\{TOPDIR\}\/layers\/meta-fluke-cda \\' .repo/manifests/conf/bblayers.conf

sed -i '/^.*meta-atmel.*$/d' .repo/manifests/conf/bblayers.conf
sed -i '/^.*meta-uav.*$/d' .repo/manifests/conf/bblayers.conf

cp ../local.conf .repo/manifests/conf/local.conf

git clone https://github.com/fmhess/meta-fluke-cda.git layers/meta-fluke-cda

MACHINE=fluke-cda-nighthawk . ./setup-environment

# Change download and cache dirs
sed -i '/DL_DIR/d' conf/site.conf
#sed -i '/SSTATE_DIR/d' conf/site.conf
echo "DL_DIR = \"\${TOPDIR}/../${ANGSTROM_BRANCH}-manifest-downloads\"" >> conf/site.conf
echo "SSTATE_DIR = \"\${TOPDIR}/../${ANGSTROM_BRANCH}-manifest-sstate-cache\"" >> conf/site.conf

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


