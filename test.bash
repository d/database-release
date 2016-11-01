#!/bin/bash

set -e -u -o pipefail
set -o posix

_main() {
	shell_scripts | xargs shellcheck --shell bash
	render_and_lint $(erb_shell_scripts)
}

shell_scripts() {
	find test -name '*.bash'
	find packages -name 'packaging' -or -name 'pre_packaging'
}

erb_shell_scripts() {
	find jobs -name '*.bash' -or -name '*.bash.erb'
}

render_and_lint() {
	local -a erbs=("$@")

	local -a bashes
	bashes=($(render_in_tmp "${erbs[@]}"))

	local errno
	(
	cd tmp
	if shellcheck --shell bash "${bashes[@]}"; then
		true
	else
		errno=$?
		return "${errno}"
	fi
	)
}

render_in_tmp() {
	local erb
	local bash
	local tmp_bash
	for erb in "$@"; do
		bash=${erb%.erb}
		tmp_bash="tmp/${bash}"
		mkdir -p "$(dirname "${tmp_bash}")"
		test/render.rb "${erb}" > "${tmp_bash}"
		echo "${bash}"
	done
}

_main "$@"
