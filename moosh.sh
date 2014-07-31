#!/bin/bash
NAME="moosh"
REMOTEVERSION="0.15.2-2"
VERSION=$REMOTEVERSION'osl1'
URL="http://moosh-online.com/"
VENDOR="OSU Open Source Lab"
LICENSE="GPLv3"
DESCRIPTION="Moodle Shell is a Drush inspired commandline tool to perform most common Moodle tasks."

set -x

TOPDIR=`dirname $( readlink -f $0 )`
FPM="fpm"

# download deb we intend to convert
wget http://ppa.launchpad.net/zabuch/ppa/ubuntu/pool/main/m/${NAME}/${NAME}_${REMOTEVERSION}_all.deb

# create rpm package
${FPM} -f -s deb -t rpm -n ${NAME} -v ${VERSION} --url ${URL} \
    -m repos@osuosl.org --vendor "${VENDOR}" --license ${LICENSE} \
    --description "${DESCRIPTION}" --prefix /usr/bin --depends "php-cli" \
    --depends "php53u-process" --no-auto-depends ${NAME}_${REMOTEVERSION}_all.deb
