#! /bin/bash

# 스크립트 실행 위치를 고정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/../.."

# GoogleService-Info.plist 파일 생성
touch ./Projects/App/Resources/GoogleService-Info.plist
chmod 644 ./Projects/App/Resources/GoogleService-Info.plist
cat <<EOF > ./Projects/App/Resources/GoogleService-Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string>$FIREBASE_API_KEY</string>
	<key>BUNDLE_ID</key>
	<string>yapp.breake</string>
	<key>GCM_SENDER_ID</key>
	<string>1081222324979</string>
	<key>GOOGLE_APP_ID</key>
	<string>1:1081222324979:ios:dffa58d4e4b46fe4934d86</string>
	<key>IS_ADS_ENABLED</key>
	<false/>
	<key>IS_ANALYTICS_ENABLED</key>
	<false/>
	<key>IS_APPINVITE_ENABLED</key>
	<true/>
	<key>IS_GCM_ENABLED</key>
	<true/>
	<key>IS_SIGNIN_ENABLED</key>
	<true/>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>PROJECT_ID</key>
	<string>brake-61b4d</string>
	<key>STORAGE_BUCKET</key>
	<string>brake-61b4d.firebasestorage.app</string>
</dict>
</plist>
EOF

echo "🎉 GoogleService-Info.plist configuration completed successfully!"