#!/usr/bin/env bash
# stop on all errors
set -e

# set default nchart configuration directory
if [ -z "${NCHART_CONF+x}" ]; then
    export NCHART_CONF="${HOME}/.nchart"
fi

# parse first line of each file
export NCHART_FULLNAME="$(head -n1 "${NCHART_CONF}/fullname")"
export NCHART_ACCOUNT="$(head -n1 "${NCHART_CONF}/account")"
export NCHART_DOMAIN="$(head -n1 "${NCHART_CONF}/domain")"
export NCHART_SCRATCH="$(head -n1 "${NCHART_CONF}/scratch")"
export NCHART_GOLDEN="$(head -n1 "${NCHART_CONF}/golden")"

# look for valid SSH string
export NCHART_USE_SSH="0"
# ssh:// style string
if expr "${NCHART_GOLDEN}" : ".*://" > /dev/null; then
    if expr "${NCHART_GOLDEN}" : "ssh://" > /dev/null; then
        export NCHART_USE_SSH="1"
    else
        echo "non-ssh protocols not currently supported"; exit 1
    fi
# scp-like syntax is also valid
elif expr "${NCHART_GOLDEN}" : "[^/]*:" > /dev/null; then
    export NCHART_USE_SSH="1"
fi

export NCHART_SSH_PRIVATE_KEY="${NCHART_CONF}/id_rsa"
export NCHART_SSH_PUBLIC_KEY="${NCHART_CONF}/id_rsa.pub"

if [ "${NCHART_USE_SSH}" = 1 ]; then
    # start ssh-agent
    # i.e. source ./scripts/ssh_agent.sh
    . ./scripts/ssh_agent.sh
    # force git to use available key
    # make sure ${NCHART_SSH_PRIVATE_KEY} is properly escaped
    # TODO check if this is actually safe
    export GIT_SSH_COMMAND="ssh -i \"${NCHART_SSH_PRIVATE_KEY}\" -o \"IdentitiesOnly yes\" -o \"AddKeysToAgent yes\""
fi

# git config core.askPass

