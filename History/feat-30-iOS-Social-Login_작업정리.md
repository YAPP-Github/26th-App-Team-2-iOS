# feat/#30-iOS-Social-Login 기술적 도전 과제 해결 기록

## 🎯 고민하고 해결한 핵심 문제들

### 1. KakaoSDK 의존성 문제 → WebView 방식으로 창의적 해결

#### 문제 상황
- **현상**: `KakaoSDKCertCore` artifact를 찾을 수 없다는 오류 발생
- **원인**: Tuist 캐시에 이전 의존성 정보가 남아있고, KakaoSDK의 복잡한 의존성 구조

#### 창의적 해결책
```swift
// KakaoLogInWebView.swift - WebView + JavaScript SDK 방식
- 네이티브 SDK 의존성 완전 제거
- JavaScript SDK 자동 주입으로 카카오 로그인 구현
- 카카오톡 앱 설치 시 자동 연동 지원
- 리다이렉트 URL 처리로 인증 완료 감지
```

**결과**: 의존성 지옥에서 벗어나면서도 동일한 사용자 경험 제공

### 2. OAuth 아키텍처의 복잡성 → Clean Architecture + UseCase 패턴

#### 설계 고민
- Apple/Kakao 각각 다른 인증 방식
- 통합 서비스 vs 분리된 서비스 설계 딜레마
- 중복 코드 최소화와 확장성 확보

#### 해결한 아키텍처
```
Domain/OAuth/
├── Interface/
│   ├── Service/
│   │   ├── OAuthServiceProtocol.swift (통합 프로토콜)
│   │   ├── AppleAuthCodeProtocol.swift (Apple 전용)
│   │   └── UserValidityProtocol.swift (검증 로직)
│   └── UseCase/
│       ├── AppleLogInUseCase.swift (Apple 전용 비즈니스 로직)
│       ├── KakaoLogInUseCase.swift (Kakao 전용 비즈니스 로직)
│       └── AutoLogInUseCase.swift (공통 자동 로그인)
└── Sources/
    └── Service/
        ├── OAuthLogInService.swift (통합 구현체)
        └── AppleAuthCodeService.swift (Apple 구현체)
```

**핵심 설계 결정**:
- **UseCase 패턴**으로 각 소셜 로그인의 비즈니스 로직 분리
- **통합 서비스**로 공통 로직 처리, **전용 서비스**로 특화 로직 처리
- **Protocol-oriented Programming**으로 테스트 가능성 확보

### 3. Token 자동 갱신 시스템의 복잡성

#### 기술적 도전
- 네트워크 요청 중 토큰 만료 감지
- 동시 요청 시 중복 토큰 갱신 방지
- 갱신 실패 시 로그아웃 처리

#### 해결한 TokenInterceptor 로직
```swift
// TokenInterceptor.swift 핵심 로직
- 요청 전 토큰 자동 첨부
- 401 응답 시 토큰 자동 갱신
- 갱신 중 다른 요청들 대기 처리
- 갱신 실패 시 자동 로그아웃
```

**기술적 포인트**:
- **동시성 제어**: 여러 요청이 동시에 토큰 갱신을 시도하지 않도록 처리
- **재귀 호출 방지**: 토큰 갱신 요청 자체에는 인터셉터 적용 제외
- **상태 관리**: 갱신 중/완료/실패 상태를 정확히 추적

### 4. 카카오 WebView 로그인의 JavaScript 연동

#### 복잡한 요구사항
- 카카오톡 앱 설치 여부에 따른 분기 처리
- JavaScript와 Swift 간 양방향 통신
- 인증 완료 시점 정확한 감지

#### 해결한 WebView 통합
```swift
// KakaoLogInWebView.swift 핵심 구현
- WKWebView + WKScriptMessageHandler로 JS-Swift 통신
- 카카오 JavaScript SDK 자동 주입
- URL 변화 모니터링으로 리다이렉트 감지
- 에러 상황별 적절한 핸들링
```

**기술적 도전점**:
- **JavaScript SDK 로딩 타이밍** 정확히 맞추기
- **앱 간 전환** (카카오톡 ↔ 우리 앱) 처리
- **다양한 에러 상황** (앱 미설치, 권한 거부 등) 핸들링

### 5. 멀티 모듈 아키텍처에서의 의존성 설계

#### 설계 복잡성
- Clean Architecture의 의존성 방향 준수
- Tuist 멀티 모듈 환경에서의 순환 의존성 방지
- Interface와 Implementation 분리

#### 해결한 의존성 구조
```
App → Feature(Onboarding) → Domain(OAuth) → Core(Network, LocalStorage)
     ↘                    ↗
       Shared(DesignSystem, Util)
```

**핵심 설계 원칙**:
- **Dependency Inversion**: 상위 레벨이 하위 레벨을 의존하지 않도록
- **Interface Segregation**: 각 모듈은 필요한 기능만 의존
- **Single Responsibility**: 각 레이어별 명확한 책임 분리

## 🔍 해결 과정에서 얻은 인사이트

### 의존성 관리
- **외부 SDK 의존성을 최소화**하고 대안 방법 모색의 중요성
- **WebView 활용**으로 네이티브 SDK 없이도 동일한 기능 구현 가능

### 아키텍처 설계
- **UseCase 패턴**이 복잡한 비즈니스 로직 분리에 매우 효과적
- **Protocol-oriented Programming**으로 테스트 가능성과 확장성 확보

### 네트워크 처리
- **자동 토큰 갱신**은 복잡하지만 사용자 경험에 필수적
- **동시성 제어**가 안정적인 네트워크 계층의 핵심

### 개발 프로세스
- **Example 앱 구성**으로 빠른 기능 검증과 디버깅 가능
- **모듈별 독립 테스트**로 문제 범위 빠르게 좁히기 