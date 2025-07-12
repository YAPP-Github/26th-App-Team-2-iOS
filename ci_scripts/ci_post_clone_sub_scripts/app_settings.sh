#!/bin/sh

# 스크립트 실행 위치를 고정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/../.."

# xcconfigs 디렉토리 생성 (존재하지 않을 경우)
mkdir -p ./Projects/App/xcconfigs
chmod -R 777 ./Projects/App/xcconfigs

# 필수 환경 변수 확인
check_env_var() {
    if [ -z "${!1}" ]; then
        echo "❌ ERROR: Environment variable $1 is not set"
        exit 1
    fi
}

# Projects > App xcconfig 구성

echo "❗️ Make DEV xcconfig"
touch ./Projects/App/xcconfigs/DEV.xcconfig
chmod 644 ./Projects/App/xcconfigs/DEV.xcconfig
cat <<EOF > ./Projects/App/xcconfigs/DEV.xcconfig
#include "./Shared.xcconfig"
EOF

echo "❗️ Make PROD xcconfig"
touch ./Projects/App/xcconfigs/PROD.xcconfig
chmod 644 ./Projects/App/xcconfigs/PROD.xcconfig
cat <<EOF > ./Projects/App/xcconfigs/PROD.xcconfig
#include "./Shared.xcconfig"
EOF

echo "❗️ Make Secrets.xcconfig"
touch ./Projects/App/xcconfigs/Secrets.xcconfig
chmod 644 ./Projects/App/xcconfigs/Secrets.xcconfig
cat <<EOF > ./Projects/App/xcconfigs/Secrets.xcconfig
DEVELOPMENT_TEAM_ID = $DEVELOPMENT_TEAM_ID

FIREBASE_API_KEY = $FIREBASE_API_KEY

KAKAO_NATIVE_APP_KEY_PROD = $KAKAO_NATIVE_APP_KEY_PROD
KAKAO_NATIVE_APP_KEY_DEV = $KAKAO_NATIVE_APP_KEY_DEV
EOF

echo "❗️ Make Shared.xcconfig"
touch ./Projects/App/xcconfigs/Shared.xcconfig
chmod 644 ./Projects/App/xcconfigs/Shared.xcconfig
cat <<EOF > ./Projects/App/xcconfigs/Shared.xcconfig
#include "./KakaoSecretKeys.xcconfig"
#include "./TokenKeys.xcconfig"
#include "./Secrets.xcconfig"

OTHER_SWIFT_FLAGS[config=PROD][sdk=*] = \$(inherited) -DPROD
BASE_SERVER_URL_PROD = $BASE_SERVER_URL_PROD

OTHER_SWIFT_FLAGS[config=DEV][sdk=*] = \$(inherited) -DDEV
BASE_SERVER_URL_DEV = $BASE_SERVER_URL_DEV
EOF

echo "❗️ Make TokenKeys.xcconfig"
touch ./Projects/App/xcconfigs/TokenKeys.xcconfig
chmod 644 ./Projects/App/xcconfigs/TokenKeys.xcconfig

echo "❗️ Set execute permission for App Target Scripts"
chmod +x ./Projects/App/Scripts/run_crashlytics.sh
chmod +x ./Projects/App/Scripts/set_firebase_api_key.sh

echo "🎉 App settings configuration completed successfully!"