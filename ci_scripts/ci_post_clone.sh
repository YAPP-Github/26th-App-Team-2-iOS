#!/bin/sh
set -e
cd ..
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
# Output the current PATH for debugging
echo ":느낌표:️Current PATH: $PATH"
echo ":느낌표:️mise version"
mise --version
echo ":느낌표:️mise install"
mise install # Installs the version from .mise.toml
eval "$(mise activate bash --shims)"
echo ":느낌표:️mise doctor"
mise doctor # verify the output of mise is correct on CI
echo ":느낌표:️tuist install"
tuist install
echo ":느낌표:️tuist generate"
tuist generate # Generate the Xcode Project using Tuist
