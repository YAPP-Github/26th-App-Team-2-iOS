#!/bin/sh
set -e

echo "❗️ Shell Script - Start Directory: $(pwd)"

# 하위 스크립트 실행
chmod +x ./ci_post_clone_sub_scripts/app_settings.sh
./ci_post_clone_sub_scripts/app_settings.sh
chmod +x ./ci_post_clone_sub_scripts/googleservice-info.sh
./ci_post_clone_sub_scripts/googleservice-info.sh

# mise 설치 (한 번만)
# curl https://mise.run | sh
curl https://mise.run | sh

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

echo 'eval "$($HOME/.local/bin/mise activate bash)"' >> ~/.bashrc

echo "❗️Current PATH: $PATH"

echo "❗️mise version"
mise --version

echo "❗️mise install"
mise install

eval "$(mise activate sh --shims)"

echo "❗️mise doctor"
mise doctor

mise use -g tuist
# mise 설정이 끝남
cd "$CI_WORKSPACE_PATH/repository" || {
  echo "❌ CI_WORKSPACE_PATH로 이동 실패: $CI_WORKSPACE_PATH"
  exit 1
}

echo "❗️tuist install"
tuist install

echo "❗️tuist generate"
tuist generate