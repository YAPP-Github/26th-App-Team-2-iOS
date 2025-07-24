// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription
   let packageSettings = PackageSettings(
       productTypes: [
        "FirebaseAnalytics": .staticFramework,
        "FirebaseCrashlytics": .staticFramework,
       ]
   )
#endif

let package = Package(
   name: "BrakePackage",
   dependencies: [
    .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.15.0"),
   ]
)

