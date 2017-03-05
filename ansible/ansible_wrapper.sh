#!/bin/bash

BASEDIR=$(cd "$(dirname "$0")"; pwd)
INVENTORY_PATH="${BASEDIR}/inventories/web_servers.ini"

help() {
  echo "  Synopsis"
  echo ""
  echo "  ./ansible_wrapper [playbook] (tag)"
  echo ""
  echo "  playbook ...................... : provision|deploy"
  echo "  tag (optional) ................ : (whatever role you like to run)"
  echo ""
}

fail() {
  echo "**** ERROR: "
  echo "  $1"
  echo ""

  exit 9
}

playbook=$1

# checks
if [ "${playbook}" = "" ]; then
  fail "Playbook cannot be empty"
fi

# build command
# cmd="ansible-playbook -i \"${INVENTORY_PATH}\" \"${BASEDIR}/${playbook}\""
cmd="ansible-playbook -i ${INVENTORY_PATH} ${BASEDIR}/${playbook} --ask-vault-pass"

# --ask-vault-pass server/${playbook}.yml

echo "Executing '${cmd}'"

${cmd}
