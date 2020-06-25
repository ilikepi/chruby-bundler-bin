
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

