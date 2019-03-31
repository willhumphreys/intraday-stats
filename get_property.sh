#!/usr/bin/env bash
set -e

function getProperty {
   PROP_KEY=$1
   PROP_VALUE=`cat ${PROPERTY_FILE} | grep "$PROP_KEY" | cut -d'=' -f2`
   echo ${PROP_VALUE}
}

