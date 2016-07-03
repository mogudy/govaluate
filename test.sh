#!/bin/bash

# Script that runs tests, code coverage, and benchmarks all at once.
# Builds a symlink in /tmp, mostly to avoid messing with GOPATH at the user's shell level.

TEMPORARY_PATH="/tmp/govaluate_test"
SRC_PATH="${TEMPORARY_PATH}/src"
FULL_PATH="${TEMPORARY_PATH}/src/govaluate"

# set up temporary directory
rm -rf "${FULL_PATH}"
mkdir -p "${SRC_PATH}"

ln -s $(pwd) "${FULL_PATH}"
export GOPATH="${TEMPORARY_PATH}"

pushd "${TEMPORARY_PATH}/src/govaluate"

# run teh actual tests.
go test -coverprofile coverage.out
status=$?

if [ "${status}" != 0 ];
then
	exit $status
fi

go tool cover -func=coverage.out
go test -bench=.

popd
