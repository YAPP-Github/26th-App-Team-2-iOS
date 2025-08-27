
import Foundation
import Firebase
import FirebaseCrashlytics
import FirebaseAnalytics
import Testing

@Suite(.serialized)
struct FirebaseConfigureTest {
    
    @Test func firebaseConfigurationFile() {
        var configPath: String? = nil
        
        if let mainPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            configPath = mainPath
        }
        
        if configPath == nil {
            for bundle in Bundle.allBundles {
                if let path = bundle.path(forResource: "GoogleService-Info", ofType: "plist") {
                    configPath = path
                    break
                }
            }
        }
        
        #expect(configPath != nil, "GoogleService-Info.plist 파일이 번들에 포함되어야 합니다")
        
        if let path = configPath {
            let configData = NSDictionary(contentsOfFile: path)
            #expect(configData != nil, "GoogleService-Info.plist 파일이 유효한 형식이어야 합니다")
            
            #expect(configData?["BUNDLE_ID"] != nil, "BUNDLE_ID가 설정되어야 합니다")
            #expect(configData?["PROJECT_ID"] != nil, "PROJECT_ID가 설정되어야 합니다")
            #expect(configData?["API_KEY"] != nil, "API_KEY가 설정되어야 합니다")
        }
    }

    @Test func configure() {
        let appsBefore = FirebaseApp.allApps?.count ?? 0
        
        FirebaseApp.configure()

        #expect(FirebaseApp.app() != nil, "Firebase 기본 앱이 구성되어야 합니다")
        
        let appsAfter = FirebaseApp.allApps?.count ?? 0
        #expect(appsAfter >= appsBefore, "Firebase 앱이 구성된 후 앱 수가 증가하거나 유지되어야 합니다")
    }


    @Test func analyticsAvailability() {
        #expect(FirebaseApp.app() != nil, "Firebase가 먼저 구성되어야 합니다")
        
        
        let analyticsAvailable = type(of: Analytics.self) == Analytics.Type.self
        #expect(analyticsAvailable, "Analytics 클래스에 접근할 수 있어야 합니다")
    }
    
    @Test func crashlyticsAvailability() {
        #expect(FirebaseApp.app() != nil, "Firebase가 먼저 구성되어야 합니다")

        let crashlytics = Crashlytics.crashlytics()
        #expect(crashlytics != nil, "Crashlytics 인스턴스에 접근할 수 있어야 합니다")
        
    }
    
}



