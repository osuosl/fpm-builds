#!/bin/bash
NAME="packer"
VERSION="0.5.2"
URL="http://www.packer.io/"
VENDOR="OSU Open Source Lab"
LICENSE="MPL2"
DESCRIPTION="Packer is a tool for creating identical machine images for multiple platforms from a single source configuration."

set -x

TOPDIR=`dirname $( readlink -f $0 )`
BUILDDIR=${TOPDIR}/build
PREPAREDIR=${BUILDDIR}/prepare
FPM="fpm"

# clean buildroot
[ -n "${BUILDDIR}" -a "${BUILDDIR}" != / ] && rm -rf ${BUILDDIR}
mkdir -p ${BUILDDIR} ${PREPAREDIR}

# unpack packer
pushd ${BUILDDIR}
wget https://dl.bintray.com/mitchellh/packer/${VERSION}_linux_amd64.zip
unzip ${VERSION}_linux_amd64.zip
mv packer* ${PREPAREDIR}/
popd

# create rpm package
${FPM} -f -s dir -t rpm -n ${NAME} -v ${VERSION} --rpm-sign --url ${URL} \
    -m repos@osuosl.org --vendor "${VENDOR}" --license ${LICENSE} \
    --description "${DESCRIPTION}" --prefix /usr/bin -C ${PREPAREDIR} .

# create deb package
${FPM} -f -s dir -t deb -n ${NAME} -v ${VERSION} --url ${URL} \
    -m repos@osuosl.org --vendor "${VENDOR}" --license ${LICENSE} \
    --description "${DESCRIPTION}" --prefix /usr/bin -C ${PREPAREDIR} .
