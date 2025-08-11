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