# #51 Onboarding Refactor 개발사항 기록

## 브랜치 정보
- **브랜치명**: `refactor/#51-onboarding-refactor`
- **작업 기간**: 2025.07.30 ~ 2025.07.31
- **주요 목표**: 온보딩 플로우 리팩토링 및 로그인 취소 기능 구현

## 주요 커밋 내역

### 1. [Feat] 온보딩 중 로그인 취소 구현 (5d0a965)
- **날짜**: 2025.07.31 02:03:18
- **핵심 기능**: 온보딩 중 사용자가 로그인을 취소할 수 있는 기능 구현

#### 🔧 Domain Layer 변경사항
- **새로운 UseCase 추가**: `LogInCancelUseCase.swift`
  - 로그인 취소 로직을 캡슐화
  - OAuth 서비스를 통해 토큰 삭제 및 상태 초기화
  
- **OAuth Service 확장**:
  - `OAuthServiceProtocol`에 `logInCancel()` 메서드 추가
  - `OAuthLogInService`에서 로그인 취소 구현
    - Access Token 및 Refresh Token 삭제
    - 멤버 상태를 `.hold`로 재설정
  
- **새로운 서비스**: `OAuthLogOutService.swift`
  - 로그아웃 기능과 로그인 취소를 분리하여 구현

#### 🎨 UI Layer 변경사항
- **SetNickNameView 개선**:
  - 뒤로가기 버튼 탭 시 로그인 취소 확인 팝업 표시
  - "로그인을 취소하시겠어요?" 확인 다이얼로그 추가
  
- **SetNicknameViewModel 확장**:
  - `LogInCancelUseCase` 의존성 추가
  - 로그인 취소 완료 시 콜백 처리
  
- **StartUpViewModel 업데이트**:
  - `logInCancelCompleted()` 메서드 추가
  - 로그인 취소 후 자동 로그인 재실행 로직

#### 🔗 Network Layer 업데이트
- **AuthLogInRequest** DTO 수정
- **BrakeResponse** 응답 모델 개선

#### 🎨 Design System
- **카카오 옐로우 컬러** 추가 (`kakaoYellow.colorset`)

---

### 2. [Feat] 알림 권한 디자인 및 완료 디자인 구성 (0bf3377)
- **날짜**: 2025.07.30 23:19:10
- **핵심 기능**: 온보딩 플로우의 권한 요청 및 완료 화면 디자인 적용

#### 🎨 UI Components 개선
- **모든 온보딩 뷰 디자인 업데이트**:
  - `OnboardingCompletedView`: 완료 화면 디자인 적용
  - `OnboardingInfoView`: 정보 화면 레이아웃 개선
  - `ScreenTimeAuthView`: 스크린타임 권한 요청 화면
  - `UserNotificationAuthView`: 알림 권한 요청 화면
  - `SetNickNameView`: 닉네임 설정 화면 개선

#### 🖼️ 새로운 에셋 추가
- **알림 권한 이미지**: `onboarding-auth-notification`
  - 다양한 해상도 지원 (@1x, @2x, @3x)
  - 알림 권한 요청 화면용 일러스트레이션
  
- **스크린타임 권한 이미지**: `onboarding-auth-screentime`
  - 스크린타임 권한 요청 화면용 일러스트레이션

#### 🎨 Design System 컴포넌트 개선
- **BrakeNavigationView** 업데이트
- **LargeButtonView** 개선
- **Images.swift** 리소스 매핑 추가

---

### 3. [Feat] 로그인 디자인 적용 (7eec911)
- **날짜**: 2025.07.30 15:11:47
- **핵심 기능**: 로그인 화면 디자인 시스템 적용

#### 🎨 Login UI 리팩토링
- **LoginView** 디자인 개선
- **새로운 컴포넌트**: `TappableText.swift`
  - 탭 가능한 텍스트 UI 컴포넌트
  - 링크나 버튼 형태의 텍스트 처리용

#### 🔄 Component 구조 개선
- **FooterView → LoginFooterView**로 리네이밍
- 기존 `FooterView.swift` 삭제 후 `LoginFooterView.swift`로 대체

#### 🖼️ 에셋 정리
- **이미지 파일명 수정**: `conboarding-cooldown` → `onboarding-cooldown`
  - 오타 수정 및 일관성 확보

#### 🎨 Design System 확장
- **카카오 옐로우 컬러** 추가 (`Colors.swift`)
- **Images.swift** 리소스 매핑 업데이트

---

### 4. [Feat] 로그인 에셋 추가 (5e12aa4)
- **날짜**: 2025.07.30
- **핵심 기능**: 로그인 관련 이미지 에셋 추가

---

## 🔧 기술적 개선사항

### Architecture 개선
1. **의존성 주입 패턴 적용**:
   - DIContainer를 통한 UseCase 주입
   - 각 ViewModel에서 필요한 UseCase만 주입받도록 설계

2. **State Management 개선**:
   - `@Observable` 매크로 활용한 상태 관리
   - StartUpViewModel을 통한 전체 온보딩 상태 관리

3. **Navigation 구조 개선**:
   - `OnboardingManager`를 통한 네비게이션 로직 중앙집중화
   - `NavigationStack` 기반의 선언적 네비게이션

### Error Handling 강화
1. **권한 요청 에러 처리**:
   - 스크린타임 권한: 7가지 에러 케이스 처리
   - 알림 권한: 4가지 에러 케이스 처리
   - 사용자 친화적 에러 메시지 제공

2. **네트워크 에러 처리**:
   - 로그인/로그아웃 실패 시 적절한 폴백 로직
   - 토큰 관리 에러 처리

### Security 개선
1. **토큰 관리**:
   - Keychain 기반 안전한 토큰 저장
   - 로그인 취소 시 완전한 토큰 정리

2. **상태 초기화**:
   - 로그인 취소 시 모든 관련 상태 초기화
   - 메모리 누수 방지를 위한 weak self 사용

---

## 🎯 개발 완료 항목

✅ **로그인 취소 기능**
- 온보딩 중 언제든 로그인 취소 가능
- 토큰 및 상태 완전 초기화
- 사용자 확인 다이얼로그 제공

✅ **권한 요청 플로우**
- 스크린타임 권한 요청
- 알림 권한 요청
- 각 권한별 에러 처리 및 안내

✅ **UI/UX 개선**
- 모든 온보딩 화면 디자인 적용
- 일관된 디자인 시스템 적용
- 반응형 레이아웃 구현

✅ **에셋 관리**
- 권한 요청용 일러스트레이션 추가
- 파일명 일관성 확보
- 다양한 해상도 지원

---

## 🔄 리팩토링 효과

1. **코드 가독성 향상**: 각 화면별 책임 분리
2. **유지보수성 개선**: UseCase 패턴으로 비즈니스 로직 분리
3. **확장성 확보**: 새로운 온보딩 단계 추가 용이
4. **사용자 경험 개선**: 직관적인 플로우와 친화적 에러 메시지
