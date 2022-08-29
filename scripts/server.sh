#!/usr/bin/env bash

project_directory="$(dirname $(dirname ${0}))"
cd "${project_directory}"

# Utility Functions ------------------------------------------------------------

# Usage: readEnvironmentFile <file>
# Read environment variables from a file.
readEnvironmentFile() {
  set -a
  . "${1}"
  set +a
}

# Usage: checkEnvironmentVariable <variable>
# Check if an environment variable is set.
checkEnvironmentVariable() {
  if [[ -z "${!1}" ]]; then
    error "${1} must be set."
    exit 128
  fi
}

# Usage: log <message>
# Log a message.
log() {
  printf "%s\n" "${1}"
}

# Usage: warning <message>
# Log a warning message.
warning() {
  printf "\e[33m%s\e[m\n" "${1}"
}

# Usage: error <message>
# Log an error message.
error() {
  printf "\e[31m%s\e[m\n" "${1}"
}

# Main Functions ---------------------------------------------------------------

# Usage: help
# Log help.
help() {
  log "Usage $(basename ${0}) [options]"
  log '  -h Log help.'
  log '  -e Read environment file.'
  log '  -d Download server.'
  log '  -E Extract server.'
  log '  -r Run server.'
}

downloadServer() {
  checkEnvironmentVariable SERVER_VERSION
  checkEnvironmentVariable SERVER_ARCHIVE_URL

  if [[ ! -f "./archives/server-${SERVER_VERSION}.zip" ]]; then
    mkdir -p ./archives
    curl "${SERVER_ARCHIVE_URL}" -o "./archives/server-${SERVER_VERSION}.zip"
  fi
}

extractServer() {
  checkEnvironmentVariable SERVER_VERSION

  if [[ ! -d "./servers/server-${SERVER_VERSION}" ]]; then
    mkdir -p "./servers/server-${SERVER_VERSION}"
    unzip "./archives/server-${SERVER_VERSION}.zip" -d "./servers/server-${SERVER_VERSION}"
  fi
}

initializeServer() {
  checkEnvironmentVariable SERVER_VERSION

  if [[ ! -d "./servers/server-${PREVIOUS_SERVER_VERSION}" ]] \
    && [[ -d "./servers/server-${SERVER_VERSION}" ]] \
    && [[ ! -f "./servers/server-${SERVER_VERSION}/initialized" ]]; then

    # TODO initialize server
    # touch "./servers/server-${SERVER_VERSION}/initialized"

    warning 'initializeServer is unimplemented'
  fi
}

updateServer() {
  checkEnvironmentVariable SERVER_VERSION

  if [[ -d "./servers/server-${PREVIOUS_SERVER_VERSION}" ]] \
    && [[ -d "./servers/server-${SERVER_VERSION}" ]] \
    && [[ ! -f "./servers/server-${SERVER_VERSION}/updated" ]]; then

    # TODO update server
    # touch "./servers/server-${SERVER_VERSION}/updated"

    warning 'updateServer is unimplemented'
  fi
}

runServer() {
  checkEnvironmentVariable SERVER_VERSION

  if [[ -d "./servers/server-${SERVER_VERSION}" ]]; then
    cd "./servers/server-${SERVER_VERSION}"
    ./bedrock_server
  fi
}

while getopts 'he:dEr' OPT; do
  case "${OPT}" in
    h)
      help
      ;;
    e)
      readEnvironmentFile "${OPTARG}"
      ;;
    d)
      downloadServer
      ;;
    E)
      extractServer
      ;;
    r)
      initializeServer
      updateServer
      runServer
      ;;
    *)
      help
      exit 128
      ;;
  esac
done

if [[ -z "${1}" ]]; then
  help
  exit 128
fi
