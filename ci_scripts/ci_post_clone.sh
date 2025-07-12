#!/bin/sh
set -e
echo "❗️ Shell Script - Start Directory: $(pwd)"

cd ..


curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# Output the current PATH for debugging
echo "❗️Current PATH: $PATH"

chmod +x ./ci_scripts/ci_post_clone_sub_scripts/app_settings.sh
sh ./ci_scripts/ci_post_clone_sub_scripts/app_settings.sh

# echo "❗️ Make Secrets.xcconfig"
# touch ./Projects/App/Resources/Secrets.xcconfig

# chmod 644 ./Projects/App/Resources/Secrets.xcconfig
# echo "FIREBASE_API_KEY = $FIREBASE_API_KEY" >> ./Projects/App/Resources/Secrets.xcconfig

# chmod +x ./Projects/App/scripts/run_crashlytics.sh
# chmod +x ./Projects/App/scripts/set_firebase_api_key.sh

# echo "❗️ Secrets.xcconfig 파일 내용:"
# cat ./Projects/App/Resources/Secrets.xcconfig


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