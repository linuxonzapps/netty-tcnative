#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Extract DISTRO details for tagging
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID-$VERSION_ID"
    if [ "$VERSION_CODENAME" != "" ]; then
        DISTRO="$ID-$VERSION_CODENAME"
    fi
fi
current_dir="$PWD"
echo $DISTRO > .distro_zab.txt
# Ensure sudo is installed
apt-get update && apt-get install sudo -y
bash /tmp/linux-on-ibm-z-scripts/netty-tcnative/${version}/build_netty.sh -y
find $PWD/netty-tcnative -path $PWD/netty-tcnative/.mvn -prune -o -name *.jar -print0 | tar -czvf netty-tcnative-${version}-linux-s390x.tar.gz --null  --files-from - --transform='s!^.*/!!'
exit 0
