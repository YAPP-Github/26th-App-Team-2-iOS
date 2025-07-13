#!/bin/sh
set -e
echo "❗️ Shell Script - Start Directory: $(pwd)"

cd ..


curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# Output the current PATH for debugging
echo "❗️Current PATH: $PATH"

chmod 644 ./ci_scripts/ci_post_clone_sub_scripts/app_settings.sh
sh ./ci_scripts/ci_post_clone_sub_scripts/app_settings.sh
chmod 644 ./ci_scripts/ci_post_clone_sub_scripts/googleservice-info.sh
sh ./ci_scripts/ci_post_clone_sub_scripts/googleservice-info.sh

echo "❗️mise version"
mise --version
echo "❗️mise install"
mise install # Installs the version from .mise.toml
eval "$(mise activate bash --shims)"

echo "❗️mise doctor"
mise doctor # verify the output of mise is correct on CI
echo "❗️tuist install"
tuist install
echo "❗️tuist generate"
tuist generate # Generate the Xcode Project using Tuist