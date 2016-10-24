#!/bin/bash

set -e -u -o pipefail

_main() {
	local -a SHELLCHECK_OPTS
	SHELLCHECK_OPTS=("$@")

	# Per BASH documentation, ARR=() is considered unset
	shell_scripts | xargs shellcheck --shell bash "${SHELLCHECK_OPTS[@]+${SHELLCHECK_OPTS[@]}}"
}

shell_scripts() {
	find jobs packages -name '*.bash' -perm -001
	find packages -name 'packaging' -or -name 'pre_packaging'
}

_main "$@"
