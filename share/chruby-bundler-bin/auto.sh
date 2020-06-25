
function chruby_bundler_bin_preexec() {
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
  trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chruby_bundler_bin_preexec' DEBUG
fi
