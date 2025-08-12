## 기존 뷰 구조

``` swift
public struct UserNotificationAuthView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(UserNotificationAuthViewModel.self) var userNotificationAuthViewModel
    public init() { }
    
    public var body: some View {
        @Bindable var viewModel = userNotificationAuthViewModel
        ZStack(alignment: .bottom) {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 0) {
                BrakeNavigationView(title: {
                    EmptyView()
                }, leading: {
                    BrakeNavigationButton(type: .back) {
                        dismiss()
                    }
                })
                
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("알림 타임 권한을").frame(height: 33)
                        Text("허용해주세요.").frame(height: 33)
                    }
                    .foregroundStyle(.white)
                    .font(.pretendard(size: 22, type: .semiBold))
                    Text("정확한 타이머 알림을 받아보세요.")
                        .foregroundStyle(Color.grey200)
                        .font(.pretendard(size: 16, type: .medium))
                }
                .padding(.top, 47)
                Spacer()
            }
            
            GeometryReader { proxy in
                ZStack {
                    Color.clear
                    Image.onboarding.notification
                        .resizable()
                        .frame(width: proxy.size.width * 0.8373)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            LargeButtonView(
                buttonType: .confirm,
                title: "허용하기",
                isActive: true
            ) {
                userNotificationAuthViewModel.authorizationButtonTapped()
            }
            .padding(.bottom, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
        .brakePopUp(
            isPresented: $viewModel.notificationAuthDeniedPresent,
            title: userNotificationAuthViewModel.notoficationAuthFailedResult?.alertTitle ?? "",
            message: "설정에서 알람을 [ 즉시 전달 ]으로 설정해주세요.",
            icon: .iconConfetti,
            alertType: .confirmDoubleButton,
            primaryButtonTitle: "설정으로 이동",
            secondaryButtonTitle: "취소",
            primaryAction: {
                viewModel.notificationAuthDeniedPresent = false
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            },
            secondaryAction: {
                viewModel.notificationAuthDeniedPresent = false
            }
        )
        .brakePopUp(
            isPresented: $viewModel.notificationAuthFiledPresent,
            title: viewModel.notoficationAuthFailedResult?.alertTitle ?? "",
            message: viewModel.notoficationAuthFailedResult?.alertDescription ?? "",
            primaryButtonTitle: "확인",
            primaryAction: {
                viewModel.notificationAuthFiledPresent = false
            }
        )
    }
}
```

## 개선 뷰 - 인스턴스 의존성 제거

> 1. 의존성 프로퍼티를 제거한 뷰 제작
``` swift
public struct UserNoficationAuth: View {
    @Environment(\.dismiss) private var dismiss
    let showNaivgation: Bool
    let authorizationButtonAction: () -> Void
    let notoficationAuthFailedResult: NotificationAuthorizationResult?
    @Binding var notificationAuthDeniedPresent: Bool
    @Binding var notificationAuthFailedPresent: Bool
    
    public init(
        showNaivgation: Bool,
        authorizationButtonAction: @escaping () -> Void,
        notoficationAuthFailedResult: NotificationAuthorizationResult?,
        notificationAuthDeniedPresent: Binding<Bool>,
        notificationAuthFailedPresent: Binding<Bool>
    ) {
        self.showNaivgation = showNaivgation
        self.authorizationButtonAction = authorizationButtonAction
        self.notoficationAuthFailedResult = notoficationAuthFailedResult
        self._notificationAuthDeniedPresent = notificationAuthDeniedPresent
        self._notificationAuthFailedPresent = notificationAuthFailedPresent
    }
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 0) {
                if showNaivgation {
                    BrakeNavigationView(title: {
                        EmptyView()
                    }, leading: {
                        BrakeNavigationButton(type: .back) {
                            dismiss()
                        }
                    })
                } else {
                    Rectangle().fill(Color.clear).frame(height: 56)
                }
                
                
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("알림 타임 권한을").frame(height: 33)
                        Text("허용해주세요.").frame(height: 33)
                    }
                    .foregroundStyle(.white)
                    .font(.pretendard(size: 22, type: .semiBold))
                    Text("정확한 타이머 알림을 받아보세요.")
                        .foregroundStyle(Color.grey200)
                        .font(.pretendard(size: 16, type: .medium))
                }
                .padding(.top, 47)
                Spacer()
            }
            
            GeometryReader { proxy in
                ZStack {
                    Color.clear
                    Image.onboarding.notification
                        .resizable()
                        .frame(width: proxy.size.width * 0.8373)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            LargeButtonView(
                buttonType: .confirm,
                title: "허용하기",
                isActive: true
            ) {
                authorizationButtonAction()
            }
            .padding(.bottom, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
        .brakePopUp(
            isPresented: $notificationAuthDeniedPresent,
            title: notoficationAuthFailedResult?.alertTitle ?? "",
            message: "설정에서 알람을 [ 즉시 전달 ]으로 설정해주세요.",
            icon: .iconConfetti,
            alertType: .confirmDoubleButton,
            primaryButtonTitle: "설정으로 이동",
            secondaryButtonTitle: "취소",
            primaryAction: {
                notificationAuthDeniedPresent = false
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            },
            secondaryAction: {
                notificationAuthDeniedPresent = false
            }
        )
        .brakePopUp(
            isPresented: $notificationAuthFailedPresent,
            title: notoficationAuthFailedResult?.alertTitle ?? "",
            message: notoficationAuthFailedResult?.alertDescription ?? "",
            primaryButtonTitle: "확인",
            primaryAction: {
                notificationAuthFailedPresent = false
            }
        )
    }
}
```


> 2. 의존성 주입 뷰 적용
``` swift
public struct UserNotificationAuthView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(UserNotificationAuthViewModel.self) var userNotificationAuthViewModel
    public init() { }
    
    public var body: some View {
        @Bindable var viewModel = userNotificationAuthViewModel
        UserNoficationAuth(
            showNaivgation: true,
            authorizationButtonAction: {
                userNotificationAuthViewModel.authorizationButtonTapped()
            },
            notoficationAuthFailedResult: viewModel.notoficationAuthFailedResult,
            notificationAuthDeniedPresent: $viewModel.notificationAuthDeniedPresent,
            notificationAuthFailedPresent: $viewModel.notificationAuthFiledPresent
        )
    }
}
```

## 🎯 앱 최상단 권한 변경 대응 시스템 구축

### 핵심 문제: 권한 변경 감지 및 실시간 대응

#### 기존 문제점
- 사용자가 설정에서 권한을 취소해도 앱이 이를 감지하지 못함
- 특정 화면에서만 권한 체크가 이루어져 일관성 부족
- 앱 포그라운드 진입 시 권한 상태 변경에 대한 대응 부재

#### 해결한 앱 최상단 권한 감지 시스템

```swift
// MainAppView.swift - 앱 최상단에서 권한 상태 관리
struct MainAppView: View {
    @State private var mainAppViewModel = MainAppViewModel()
    
    var body: some View {
        MainTabView()
            .environment(mainAppViewModel)
            .modifier(MainAuthModifier(viewModel: mainAppViewModel))  // 🔥 핵심: 앱 전체에 권한 체크 적용
            .onAppear {
                mainAppViewModel.checkAllPermissions()  // 앱 시작 시 권한 확인
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                mainAppViewModel.checkAllPermissions()  // 포그라운드 진입 시 권한 재확인
            }
    }
}
```

### 실시간 권한 상태 추적 시스템

```swift
// MainAppViewModel.swift - 권한 상태 중앙 관리
@Observable
public final class MainAppViewModel {
    public var authState: AuthState = .checking
    
    public func checkAllPermissions() {
        Task { @MainActor in
            let isNotificationAuthorized = await fetchUserNotificationAuthUseCase.execute()
            let isScreenTimeAuthorized = await fetchScreenTimeAuthUseCase.execute()
            
            // 🔥 핵심: 권한 상태 변경 즉시 UI 업데이트
            updateAuthState(notification: isNotificationAuthorized, screenTime: isScreenTimeAuthorized)
        }
    }
    
    private func updateAuthState(notification: Bool, screenTime: Bool) {
        switch (notification, screenTime) {
        case (false, _):
            authState = .notificationRequired
        case (true, false):
            authState = .screenTimeRequired  
        case (true, true):
            authState = .authorized
        }
    }
}
```

### fullScreenCover를 통한 전역 권한 요청 시스템

```swift
// MainAuthModifier.swift - 앱 어디서든 권한 요청 화면 표시
struct MainAuthModifier: ViewModifier {
    @Bindable var viewModel: MainAppViewModel
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: .constant(shouldShowAuthScreen)) {
                // 🔥 핵심: 권한 상태에 따라 적절한 화면 자동 표시
                switch viewModel.authState {
                case .notificationRequired:
                    UserNoficationAuth(showNaivgation: false, ...)
                case .screenTimeRequired:
                    MainScreenTimeAuthView(showNaivgation: false, ...)
                default:
                    EmptyView()
                }
            }
    }
}
```

### 기존 AppGroupView 의존성 제거

#### Before: 특정 화면에서만 권한 체크
```swift
// AppGroupMainView.swift - 기존 방식
.modifier(AppGroupAuthModifier(viewModel: viewModel))  // 특정 화면에서만 동작
```

#### After: 앱 최상단에서 전역 관리
```swift
// MainAppView.swift - 개선된 방식
.modifier(MainAuthModifier(viewModel: mainAppViewModel))  // 앱 전체에서 동작
```

## 🚀 구현 결과: 완전한 권한 변경 대응 시스템

### 1. **실시간 권한 감지**
- 앱 시작 시 자동 권한 확인
- 포그라운드 진입 시 권한 재확인  
- 설정에서 권한 변경 시 즉시 감지

### 2. **전역 권한 요청 플로우**
- 앱 어느 화면에서든 권한 부족 시 자동으로 권한 요청 화면 표시
- fullScreenCover로 사용자 주의 집중
- 권한 획득 후 자동으로 원래 화면 복귀

### 3. **아키텍처 개선**
- 기존: 특정 화면별 권한 체크 → 개선: 앱 최상단 통합 관리
- 기존: 수동 권한 확인 → 개선: 자동 권한 상태 추적
- 기존: 화면별 권한 UI → 개선: 재사용 가능한 권한 컴포넌트
