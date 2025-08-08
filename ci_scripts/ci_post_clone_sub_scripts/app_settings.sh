#!/bin/sh

# 스크립트 실행 위치를 고정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/../.."

# xcconfigs 디렉토리 생성 (존재하지 않을 경우)
mkdir -p ./Projects/App/xcconfigs
chmod -R 777 ./Projects/App/xcconfigs

# 필수 환경 변수 확인
# 환경 변수가 설정되어 있는지 확인하는 함수
check_env_var() {
    # -z: 문자열이 비어있으면 true
    # ${!1}: 간접 참조로 $1에 담긴 변수명의 실제 값을 가져옴
    # 예: $1이 "MY_VAR"이면 ${!1}은 $MY_VAR의 값을 반환
    if [ -z "${!1}" ]; then
        echo "❌ ERROR: Environment variable $1 is not set"
        exit 1
    fi
}


# Projects > App xcconfig 구성

echo "❗️ Make Debug xcconfig"
touch ./Projects/App/xcconfigs/Debug.xcconfig
chmod 644 ./Projects/App/xcconfigs/Debug.xcconfig
cat <<EOF > ./Projects/App/xcconfigs/Debug.xcconfig
#include "./Shared.xcconfig"

DEVELOPMENT_TEAM_ID = $DEVELOPMENT_TEAM_ID

KAKAO_REST_API_KEY_DEBUG = $KAKAO_REST_API_KEY_DEBUG
KAKAO_REST_API_KEY_RELEASE = $KAKAO_REST_API_KEY_RELEASE

KAKAO_JS_KEY_DEBUG = $KAKAO_JS_KEY_DEBUG
KAKAO_JS_KEY_RELEASE = $KAKAO_JS_KEY_RELEASE
APP_GROUP_NAME = $APP_GROUP_NAME

EOF

echo "❗️ Make Release xcconfig"
touch ./Projects/App/xcconfigs/Release.xcconfig
chmod 644 ./Projects/App/xcconfigs/Release.xcconfig
cat <<EOF > ./Projects/App/xcconfigs/Release.xcconfig
#include "./Shared.xcconfig"
DEVELOPMENT_TEAM_ID = $DEVELOPMENT_TEAM_ID

KAKAO_REST_API_KEY_RELEASE = $KAKAO_REST_API_KEY_RELEASE

KAKAO_JS_KEY_RELEASE = $KAKAO_JS_KEY_RELEASE


APP_GROUP_NAME = $APP_GROUP_NAME 
EOF

echo "❗️ Make Shared.xcconfig"
touch ./Projects/App/xcconfigs/Shared.xcconfig
chmod 644 ./Projects/App/xcconfigs/Shared.xcconfig

cat <<EOF > ./Projects/App/xcconfigs/Shared.xcconfig
#include "./TokenKeys.xcconfig"

OTHER_SWIFT_FLAGS[config=Debug][sdk=*] = $(inherited) -DDEBUG
BASE_SERVER_URL_DEBUG = $BASE_SERVER_URL_DEBUG


OTHER_SWIFT_FLAGS[config=Release][sdk=*] = $(inherited) -DRELEASE
BASE_SERVER_URL_RELEASE = $BASE_SERVER_URL_RELEASE

KAKAO_REDIRECT_URL = $KAKAO_REDIRECT_URL


EOF


echo "❗️ Make TokenKeys.xcconfig"
touch ./Projects/App/xcconfigs/TokenKeys.xcconfig
chmod 644 ./Projects/App/xcconfigs/TokenKeys.xcconfig

echo "❗️ Set execute permission for App Target Scripts"
chmod +x ./Projects/App/Scripts/run_crashlytics.sh

echo "🎉 App settings configuration completed successfully!"