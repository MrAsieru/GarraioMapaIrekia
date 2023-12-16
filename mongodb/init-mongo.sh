#!/bin/bash
mongosh <<EOF
use gtfs
db.createUser({user: "${MONGODB_SERVER_USER}", pwd: "${MONGODB_SERVER_USER_PASSWORD}", roles: [{role: 'readWrite', db: "gtfs"}, {role: 'dbAdmin', db: "gtfs"}]})
db.createUser({user: "${MONGODB_API_USER}", pwd: "${MONGODB_API_USER_PASSWORD}", roles: [{role: 'read', db: "gtfs"}]})

db.paradas.createIndex({"paradaPadre": 1})
db.posiciones.createIndex({"fecha": 1, "idAgencia": 1})
db.posiciones.createIndex({"idAgencia": 1})
EOF