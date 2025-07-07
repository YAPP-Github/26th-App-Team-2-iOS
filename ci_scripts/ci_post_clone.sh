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

# echo "❗️ Replace API_KEY in GoogleService-Info.plist"
# plutil -replace API_KEY -string $FIREBASE_API_KEY ./Projects/App/Resources/GoogleService-Info.plist

echo "❗️ Make Secrets.xcconfig"
touch ./Projects/App/Resources/Secrets.xcconfig
chmod 644 ./Projects/App/Resources/Secrets.xcconfig

echo "❗️ Add FIREBASE_API_KEY to Secrets.xcconfig"
echo "FIREBASE_API_KEY = $FIREBASE_API_KEY" >> ./Projects/App/Resources/Secrets.xcconfig

echo "❗️ Secrets.xcconfig 파일 내용:"
cat ./Projects/App/Resources/Secrets.xcconfig

echo "❗️mise doctor"
mise doctor # verify the output of mise is correct on CI
echo "❗️tuist install"
tuist install
echo "❗️tuist generate"
tuist generate # Generate the Xcode Project using Tuist

