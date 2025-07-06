#!/bin/sh
set -e
cd ..

curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# Output the current PATH for debugging
echo "❗️Current PATH: $PATH"

echo "❗️mise version"
mise --version
echo "❗️mise install"
mise install # Installs the version from .mise.toml
eval "$(mise activate bash --shims)"


echo "❗️ Setting GoogleService-Info.plist API_KEY : $API_KEY"

echo "❗️ Print GoogleService-Info.plist files:"
echo ./Projects/App/Resources/GoogleService-Info.plist

# echo "❗️ Replace API_KEY in GoogleService-Info.plist"
#  plutil -replace API_KEY -string $API_KEY ./Projects/App/Resources/GoogleService-Info.plist

# GoogleService-Info.plist 파일 내용 출력
# plutil -p ./Projects/App/Resources/GoogleService-Info.plist

echo "❗️mise doctor"
mise doctor # verify the output of mise is correct on CI
echo "❗️tuist install"
tuist install
echo "❗️tuist generate"
tuist generate # Generate the Xcode Project using Tuist