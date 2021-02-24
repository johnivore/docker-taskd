#!/bin/bash

# Copyright 2021 John Begenisich

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# Create directories
mkdir -p ${TASKDDATA}/log ${TASKDDATA}/pki

# Certificate vars; these are used when generating the sync server's
# certs, such as when starting an empty container.  The 'vars' file
# is built at container boot time as a convenience when (re-)issuing certs.

# Optional vars
if [ -z $EXPIRATION_DAYS ]; then EXPIRATION_DAYS=365; fi
if [ -z $CN ]; then CN=localhost.localdomain; fi

# Configure vars for building the certificates
cat > ${TASKDDATA}/pki/vars <<EOF
BITS="4096"
EXPIRATION_DAYS="${EXPIRATION_DAYS}"
ORGANIZATION="${ORGANIZATION}"
CN=${CN}
COUNTRY="${COUNTRY}"
STATE="${STATE}"
LOCALITY="${LOCALITY}"
EOF


# If we're a fresh container, set up a basic working config
# Basiclaly following https://taskwarrior.org/docs/taskserver/configure.html
if ! test -e ${TASKDDATA}/config; then

    taskd init
    taskd config --force log ${TASKDDATA}/log/taskd.log

    # Copy cert generation stuff
    cp /usr/share/taskd/pki/generate* ${TASKDDATA}/pki

    # Generate certs
    cd ${TASKDDATA}/pki
    ./generate

    # Tell sync server to use generated certs
    taskd config --force ca.cert ${TASKDDATA}/pki/ca.cert.pem
    taskd config --force server.cert ${TASKDDATA}/pki/server.cert.pem
    taskd config --force server.key ${TASKDDATA}/pki/server.key.pem
    taskd config --force server.crl ${TASKDDATA}/pki/server.crl.pem
    taskd config --force client.cert ${TASKDDATA}/pki/client.cert.pem
    taskd config --force client.key ${TASKDDATA}/pki/client.key.pem

    # Listen on default port
    taskd config --force server 0.0.0.0:53589

fi

# Give the docker log a bit of info to assist debugging
taskd diagnostics

echo "Starting taskd..."

exec taskd server --data ${TASKDDATA}
