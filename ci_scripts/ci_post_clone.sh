#!/bin/sh
set -e

echo "❗️ Shell Script - Start Directory: $(pwd)"

# 하위 스크립트 실행
chmod +x ./ci_scripts/ci_post_clone_sub_scripts/app_settings.sh
./ci_scripts/ci_post_clone_sub_scripts/app_settings.sh
chmod +x ./ci_scripts/ci_post_clone_sub_scripts/googleservice-info.sh
./ci_scripts/ci_post_clone_sub_scripts/googleservice-info.sh

# mise 설치 (한 번만)
# curl https://mise.run | sh
brew install mise

export PATH="$HOME/.local/share/mise/bin:$PATH"

echo "❗️Current PATH: $PATH"



echo "❗️mise version"
mise --version

echo "❗️mise install"
mise install

eval "$(mise activate sh --shims)"

echo "❗️mise doctor"
mise doctor

echo "❗️tuist install"
tuist install

echo "❗️tuist generate"
tuist generate