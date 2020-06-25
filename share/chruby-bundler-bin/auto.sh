unset RUBY_AUTO_BUNDLER_BIN

function chruby_bundler_bin_preexec() {
  if [[ "$AUTO_BUNDLER_BIN_RUN_CHRUBY_AUTO" == yes ]]; then
    chruby_auto
  fi

  # $RUBY_ROOT is set by chruby_use().
  if [[ -n "$RUBY_ROOT" ]]; then
    auto_bundler_bin_path
    hash -r
  else
    auto_bundler_bin_path_reset
  fi
}

function auto_bundler_bin_path_reset() {
	if [[ -n "$RUBY_AUTO_BUNDLER_BIN" ]]; then
		PATH=":$PATH:"
		PATH="${PATH//:$RUBY_AUTO_BUNDLER_BIN:/:}"
		PATH="${PATH#:}"; PATH="${PATH%:}"
		unset RUBY_AUTO_BUNDLER_BIN
	fi
}

function auto_bundler_bin_path() {
	local bundler_bin_path

	eval "$("$RUBY_ROOT/bin/ruby" - <<EOF
begin
	require 'shellwords'; require 'rubygems'; require 'bundler'
	puts "bundler_bin_path=\"#{Bundler.bin_path.to_s.shellescape}\"" unless Bundler.bin_path.nil?
rescue LoadError
end
EOF
)"

  auto_bundler_bin_path_reset

	if [[ -n "$bundler_bin_path" ]]; then
		export RUBY_AUTO_BUNDLER_BIN="$bundler_bin_path"
		export PATH="$RUBY_AUTO_BUNDLER_BIN:$PATH"
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
  if [[ ! "$preexec_functions" == *chruby_bundler_bin_preexec* ]]; then
    preexec_functions+=("chruby_bundler_bin_preexec")
  fi
elif [[ -n "$BASH_VERSION" ]]; then
  # Only one trap function can be set for a given signal, and by default we
  # cannot query whether one is set for the calling shell.  Given this, if
  # chruby_auto() exists, assume it is configured for the DEBUG trap, which
  # we're about to replace with our own function.
  if declare -f chruby_auto > /dev/null; then
    export AUTO_BUNDLER_BIN_RUN_CHRUBY_AUTO=yes
  fi

  # FIXME: It's actually not possible to overwrite an existing trap function
  # in the calling show.  As a workaround, run `trap - DEBUG` before sourcing
  # this script.
  trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chruby_bundler_bin_preexec' DEBUG
fi
