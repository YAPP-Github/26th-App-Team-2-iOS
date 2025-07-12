echo "❗️ Find GoogleService-Info.plist API_KEY in Secrets.xcconfig"
FIREBASE_API_KEY=$(grep "FIREBASE_API_KEY" ./Resources/Secrets.xcconfig | cut -d "=" -f 2 | tr -d ' ')
plutil -replace API_KEY -string $FIREBASE_API_KEY ./Resources/GoogleService-Info.plist 