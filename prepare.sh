#!/bin/bash

# Download the "root" directory from the latest version of the repository linuxserver/docker-duplicati
mkdir -p root
curl -L https://github.com/linuxserver/docker-duplicati/tarball/master | tar xz --strip=1 --wildcards "*/root/*" -C root
# replace 8200 in file "root/etc/s6-overlay/s6-rc.d/svc-duplicati/run"  with "${WEBUI}"
TARGET_FILE="root/etc/s6-overlay/s6-rc.d/svc-duplicati/run"
sed -i 's/8200/${WEBUI}/g' "$TARGET_FILE"
# add a option " --webservice-port=${WEBUI}" to the file "root/etc/s6-overlay/s6-rc.d/svc-duplicati/run" at last
OPTION=" --webservice-port=\${WEBUI}"
sed -i "\$s/\$/${OPTION}/" "$TARGET_FILE"

# Download the "Dockerfile"
curl -L https://raw.githubusercontent.com/linuxserver/docker-duplicati/master/Dockerfile -o Dockerfile
# add a line "ENV WEBUI=8200" to the file "Dockerfile" after the line "ENV HOME="/config""
sed -i 's/8200/${WEBUI}/g' Dockerfile
sed -i '/ENV HOME="\/config"/a ENV WEBUI=8200' Dockerfile