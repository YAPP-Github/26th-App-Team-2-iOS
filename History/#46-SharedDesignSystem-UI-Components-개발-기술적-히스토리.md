# feat/#46-SharedDesignSystem UI Components 개발 기술적 히스토리

## 🎯 개발 배경 및 목표

### 프로젝트 요구사항
- **통일된 디자인 시스템**: 앱 전체에서 일관된 UI/UX 제공
- **재사용 가능한 컴포넌트**: 개발 효율성과 일관성 확보
- **다크 테마 기반**: 브레이크 앱의 다크 테마 디자인 가이드라인 준수
- **SwiftUI 네이티브**: 최신 iOS 개발 트렌드에 맞는 SwiftUI 컴포넌트

### 핵심 디자인 원칙
- **접근성**: 적절한 색상 대비와 폰트 크기
- **반응성**: 다양한 화면 크기에 대응하는 레이아웃
- **일관성**: 통일된 스페이싱, 색상, 타이포그래피
- **확장성**: 새로운 컴포넌트 추가 시 기존 구조와의 호환성

## 🔧 구현된 컴포넌트들

### 1. BrakeAlertView 시스템

#### 기술적 도전 과제
- **전체 화면 커버**: SwiftUI의 `.fullScreenCover` vs 커스텀 모디파이어
- **동적 높이 조정**: 콘텐츠에 따른 자동 높이 계산
- **중앙 정렬**: 화면 중앙에 정확한 위치 배치
- **애니메이션**: 부드러운 등장/사라짐 효과

#### 해결한 아키텍처 구조
```swift
// 3단계 모디파이어 구조
View
├── .brakePopUp() // View Extension
├── BrakePopUpModifier // 래퍼 모디파이어
└── BrakeAlertModifier // 전체 화면 커버 모디파이어
    └── BrakeAlertView // 실제 알림 뷰
```

**핵심 설계 결정**:
- **모디파이어 분리**: 각 레이어별 책임 분리로 유지보수성 향상
- **제네릭 타입**: `BrakeAlertModifier<Content, Background>`로 재사용성 확보
- **ViewBuilder**: 클로저 기반 콘텐츠 주입으로 유연성 확보

#### 동적 높이 조정 로직
```swift
// BrakeAlertView.swift - 동적 높이 처리
.frame(maxWidth: 320, minHeight: 0, maxHeight: 355)
.fixedSize(horizontal: false, vertical: true)
```

**기술적 포인트**:
- **minHeight: 0**: 콘텐츠가 없을 때 최소 높이 제거
- **fixedSize**: SwiftUI의 자동 크기 조정 비활성화
- **maxHeight**: 긴 콘텐츠에 대한 스크롤 대비

#### X 버튼 구현
```swift
// ZStack을 활용한 오버레이 배치
ZStack(alignment: .topTrailing) {
    VStack { /* 메인 콘텐츠 */ }
    
    if showCloseButton {
        Button { closeAction?() } label: {
            Image(systemName: "xmark")
                .frame(width: 32, height: 32)
                .background(Color.grey800)
                .clipShape(Circle())
        }
        .padding(.top, 16)
        .padding(.trailing, 16)
    }
}
```

**UI/UX 고려사항**:
- **원형 배경**: 터치 영역 확보와 시각적 구분
- **적절한 패딩**: 모달 모서리와의 안전 거리 확보
- **색상 대비**: 다크 테마에 맞는 회색 계열 사용

### 2. BrakeTextFieldView & BrakeValidatedTextFieldView

#### 기술적 도전 과제
- **유효성 검증**: 실시간 입력 검증과 시각적 피드백
- **플레이스홀더 스타일링**: 다크 테마에 맞는 색상과 가독성
- **이모지 표시**: 텍스트 필드 내부에 검증 상태 표시
- **동적 설명**: 입력 상태에 따른 설명 텍스트 표시/숨김

#### 해결한 검증 시스템
```swift
// BrakeValidatedTextFieldView.swift - 검증 로직
public struct BrakeValidatedTextFieldView: View {
    @Binding private var text: String
    private let regex: String
    private let topDescription: String?
    private let bottomDescription: String?
    
    private var isValid: Bool {
        !text.isEmpty && text.range(of: regex, options: .regularExpression) != nil
    }
}
```

**검증 로직 설계**:
- **정규표현식**: 유연한 패턴 매칭으로 다양한 검증 규칙 지원
- **실시간 검증**: `@Binding`을 통한 즉시 상태 업데이트
- **조건부 표시**: `isValid` 상태에 따른 이모지와 색상 변경

#### 플레이스홀더 스타일링
```swift
// BrakeTextFieldView.swift - 플레이스홀더 처리
TextField("", text: $text, prompt: Text(placeholder))
    .tint(Colors.grey300.swiftUIColor) // 커서 색상
    .foregroundStyle(textColor.swiftUIColor) // 텍스트 색상
```

**색상 처리 순서**:
- **tint() 먼저**: 플레이스홀더와 커서 색상 설정
- **foregroundStyle() 나중에**: 텍스트 색상 설정
- **색상 대비**: `grey300`으로 다크 테마에서 가독성 확보

### 3. BrakeTabBarView

#### 기술적 도전 과제
- **동적 콘텐츠**: 선택된 탭에 따른 콘텐츠 변경
- **아이콘 틴팅**: 선택/미선택 상태에 따른 색상 변경
- **터치 영역**: 적절한 터치 반응 영역 확보
- **애니메이션**: 부드러운 탭 전환 효과

#### 해결한 탭 시스템
```swift
// TabItemType.swift - 탭 아이템 모델
public struct TabItemType: Identifiable {
    public let id = UUID()
    public let title: String
    public let icon: Image
    public let content: AnyView
    
    public var iconImage: Image {
        icon.renderingMode(.template) // 틴팅 가능하도록 설정
    }
}
```

**모델 설계 포인트**:
- **Identifiable**: SwiftUI의 ForEach에서 사용하기 위한 고유 ID
- **AnyView**: 타입 지우기로 다양한 뷰 타입 지원
- **renderingMode(.template)**: 프로그래밍적 색상 변경 가능

#### 동적 콘텐츠 처리
```swift
// BrakeTabBarView.swift - 콘텐츠 전환
VStack(spacing: 0) {
    // 선택된 탭의 콘텐츠 표시
    selectedTab.content
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    // 탭 바
    HStack(spacing: 0) {
        ForEach(tabItems) { tab in
            TabButton(
                tab: tab,
                isSelected: selectedTab.id == tab.id,
                action: { selectedTab = tab }
            )
        }
    }
}
```

**레이아웃 설계**:
- **VStack 분리**: 콘텐츠와 탭 바를 명확히 분리
- **frame 확장**: 콘텐츠가 전체 공간을 사용하도록 설정
- **ForEach**: 동적 탭 아이템 렌더링

### 4. BrakeToastView

#### 기술적 도전 과제
- **자동 사라짐**: 일정 시간 후 자동으로 숨김 처리
- **최상단 표시**: 다른 UI 요소들 위에 오버레이 표시
- **애니메이션**: 부드러운 등장/사라짐 효과
- **터치 방지**: 토스트 표시 중 다른 UI 조작 방지

#### 해결한 토스트 시스템
```swift
// BrakeToastView.swift - 자동 사라짐 로직
public struct BrakeToastView: View {
    @Binding private var isPresented: Bool
    private let message: String
    private let duration: TimeInterval
    
    public var body: some View {
        Text(message)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isPresented = false
                    }
                }
            }
    }
}
```

**타이밍 처리**:
- **onAppear**: 뷰가 나타날 때 타이머 시작
- **DispatchQueue.main.asyncAfter**: 메인 스레드에서 지연 실행
- **withAnimation**: 부드러운 사라짐 애니메이션

#### 최상단 오버레이 구현
```swift
// BrakeToastView_ex.swift - 오버레이 배치
.overlay(
    VStack {
        if showToast {
            BrakeToastView(
                isPresented: $showToast,
                message: "토스트 메시지입니다!",
                duration: 2.0
            )
            .transition(.move(edge: .top).combined(with: .opacity))
        }
        Spacer()
    }
    .padding(.top, 60) // 상태바와 네비게이션바 고려
)
```

**레이아웃 고려사항**:
- **overlay**: 기존 콘텐츠 위에 표시
- **transition**: 슬라이드 + 페이드 효과
- **padding**: 상태바와 네비게이션바 높이 고려

### 5. BrakeNavigationView

#### 기술적 도전 과제
- **백 버튼**: 네비게이션 스택 관리와 뒤로가기
- **닫기 버튼**: 모달 닫기와 상태 초기화
- **제목 중앙 정렬**: 네비게이션 바 제목 위치
- **액션 버튼**: 우측 액션 버튼과 터치 처리

#### 해결한 네비게이션 시스템
```swift
// BrakeNavigationView.swift - 버튼 타입 처리
public enum NavigationButtonType {
    case back(action: () -> Void)
    case close(action: () -> Void)
    case custom(icon: Image, action: () -> Void)
}

public var body: some View {
    HStack {
        // 좌측 버튼
        switch leftButton {
        case .back(let action):
            Button(action: action) {
                Image.iconBack
                    .foregroundStyle(Color.grey300)
            }
        case .close(let action):
            Button(action: action) {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.grey300)
            }
        case .custom(let icon, let action):
            Button(action: action) {
                icon.foregroundStyle(Color.grey300)
            }
        }
        
        Spacer()
        
        // 제목
        Text(title)
            .font(.pretendard(size: 18, type: .semiBold))
            .foregroundStyle(Color.brakeWhite)
        
        Spacer()
        
        // 우측 버튼
        if let rightButton = rightButton {
            Button(action: rightButton.action) {
                rightButton.icon
                    .foregroundStyle(Color.grey300)
            }
        } else {
            // 우측 버튼이 없을 때 균형 맞추기
            Color.clear
                .frame(width: 24, height: 24)
        }
    }
}
```

**레이아웃 설계**:
- **HStack + Spacer**: 좌우 균형 잡힌 레이아웃
- **조건부 렌더링**: 우측 버튼이 없을 때 공간 확보
- **타입 안전성**: enum으로 버튼 타입 명확히 구분

## 🔍 개발 과정에서 얻은 인사이트

### SwiftUI 모디파이어 패턴
- **체이닝 순서**: 레이아웃 → 스타일 → 애니메이션 순서가 중요
- **성능 최적화**: 불필요한 뷰 재생성 방지를 위한 구조 설계
- **재사용성**: 제네릭과 프로토콜을 활용한 유연한 구조

### 상태 관리
- **@Binding 활용**: 부모-자식 간 상태 동기화
- **조건부 렌더링**: if-else보다는 삼항 연산자나 switch 활용
- **애니메이션**: 상태 변경과 애니메이션의 자연스러운 연결
