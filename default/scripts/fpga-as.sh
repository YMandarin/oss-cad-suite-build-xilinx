# install script source: https://github.com/openXC7/toolchain-installer/blob/main/toolchain-sources-builder.sh

OS="$(uname -s)"
BAZEL_VERSION=8.5.0

install_bazel() {
	local platform sha256 url target actual
	case "$OS/$(uname -m)" in
		Linux/x86_64) platform=linux-x86_64 sha256=18255229d933b8da10151bdef223a302744296b09af8af1988c93faa1ea3c71f ;;
		Linux/aarch64) platform=linux-arm64 sha256=0c455abf42814ac53539ddd8147249a11b9e05c7dc83dbd6c8dfac1aec243d85 ;;
		Darwin/x86_64) platform=darwin-x86_64 sha256=84e1b822b6d076151a9a5b7a962e8230f565a17207196056bfe35303077b8147 ;;
		Darwin/arm64) platform=darwin-arm64 sha256=a89f446641ab1cce603691cb7030865d1fb014e260ee5710615516e3cacd2414 ;;
		*)
			echo "Error: no pinned Bazel $BAZEL_VERSION for $OS/$(uname -m)." >&2
			return 1
			;;
	esac
	mkdir -p "bin"
	target="./bin/bazel"
	# Skip the download when the pinned version is already there; a previous
	# run with another BAZEL_VERSION is replaced rather than reused.
	if [[ -x "$target" ]] && [[ "$("$target" --version 2>/dev/null)" == "bazel $BAZEL_VERSION" ]]; then
		return 0
	fi
	url="https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-$platform"
	echo "Installing Bazel $BAZEL_VERSION ($platform)"
	curl -fsSL -o "$target.tmp" "$url"
	# shasum on macOS: brew does not install coreutils unless asked.
	if command -v sha256sum >/dev/null 2>&1; then
		actual=$(sha256sum "$target.tmp" | cut -d' ' -f1)
	else
		actual=$(shasum -a 256 "$target.tmp" | cut -d' ' -f1)
	fi
	if [[ "$actual" != "$sha256" ]]; then
		rm -f "$target.tmp"
		echo "Error: Bazel $BAZEL_VERSION checksum mismatch: expected $sha256, got $actual." >&2
		return 1
	fi
	mv "$target.tmp" "$target"
	chmod 755 "$target"
}

cd fpga-as
install_bazel

JOBS="${NPROC:-$(nproc 2>/dev/null || echo 4)}"
export BAZEL_USER_ROOT="${BUILD_DIR}/.bazel-user-root"

"./bin/bazel" --output_user_root="$BAZEL_USER_ROOT" \
    build //fpga:fpga-as -c opt --curses=no --jobs="$JOBS"

mkdir -p "${OUTPUT_DIR}${INSTALL_PREFIX}/bin"
install -m755 -s bazel-bin/fpga/fpga-as "${OUTPUT_DIR}${INSTALL_PREFIX}/bin/fpga-as"