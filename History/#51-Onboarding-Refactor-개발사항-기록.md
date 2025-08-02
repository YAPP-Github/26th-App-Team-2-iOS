# #51 Onboarding Refactor 개발사항 기록

## 브랜치 정보
- **브랜치명**: `refactor/#51-onboarding-refactor`
- **작업 기간**: 2025.07.30 ~ 2025.07.31
- **주요 목표**: 온보딩 플로우 리팩토링 및 로그인 취소 기능 구현

## 주요 커밋 내역

### 1. [Feat] Constant 파일 Shared > Util Layer로 이동 (12e2dfe)
- **날짜**: 2025.07.31
- **핵심 기능**: 상수 파일들을 Shared > Util 레이어로 이동하여 재사용성 향상

#### 🔧 Architecture 개선
- **Constant 파일 이동**: 
  - 온보딩 관련 상수들을 `Shared/Util/Sources/Constant/Constant.swift`로 이동
  - URL 상수, 권한 관련 상수 등 중앙 집중화

#### 🎯 리팩토링 효과
- **재사용성 향상**: 다른 모듈에서도 상수 사용 가능
- **유지보수성 개선**: 상수 관리 포인트 단일화
- **일관성 확보**: 프로젝트 전체에서 동일한 상수 사용

---

### 2. [Feat] 탭바 뷰 Shared 모듈 추가 및 Example 뷰 작성 (3153a07)
- **날짜**: 2025.07.31
- **핵심 기능**: 탭바 뷰를 Shared 모듈로 분리하고 Example 뷰 작성

#### 🎨 Design System 확장
- **BrakeTabBarView** Shared 모듈로 이동
- **TabItemType** 모델 추가
- **Example 뷰 작성**: `TabBarView_ex.swift`
  - 탭바 컴포넌트 사용 예시 제공
  - 개발자 가이드 역할

#### 🔧 모듈 구조 개선
- **Shared 모듈 활용**: 재사용 가능한 UI 컴포넌트 분리
- **Example 프로젝트**: 컴포넌트 사용법 문서화

---

### 3. [Feat] 로그인 디자인 수정 및 로그인 취소 유즈케이스 리팩토링 (89fdac0)
- **날짜**: 2025.07.31
- **핵심 기능**: 로그인 UI 개선 및 로그인 취소 로직 최적화

#### 🎨 UI 개선
- **로그인 화면 디자인 수정**:
  - 레이아웃 및 스타일링 개선
  - 사용자 경험 향상을 위한 UI 요소 조정

#### 🔧 UseCase 리팩토링
- **LogInCancelUseCase 최적화**:
  - 로직 개선 및 성능 향상
  - 에러 처리 강화
  - 메모리 관리 개선

---

### 4. [Feat] 웹 뷰 수정 및 개인정보 처리 및 권한 URL Constant 처리 (f065f01)
- **날짜**: 2025.07.31
- **핵심 기능**: 웹뷰 개선 및 URL 상수화

#### 🌐 WebView 개선
- **KakaoLogInWebView 수정**:
  - 웹뷰 성능 및 안정성 개선
  - 로딩 상태 처리 개선

#### 🔧 URL 상수화
- **개인정보 처리방침 URL**: Constant로 관리
- **권한 관련 URL**: 중앙 집중화
- **유지보수성 향상**: URL 변경 시 한 곳에서만 수정

---

### 5. [Feat] 온보딩 중 로그인 취소 구현 (81e3c40)
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

### 6. [Feat] 알림 권한 디자인 및 완료 디자인 구성 (d602e7b)
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

### 7. [Feat] 로그인 디자인 적용 (f35041b)
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

### 8. [Feat] 로그인 에셋 추가 (6f3a860)
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

4. **모듈화 및 재사용성 향상**:
   - Shared 모듈을 통한 컴포넌트 재사용
   - Constant 파일 중앙 집중화
   - Example 프로젝트를 통한 문서화

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

### Performance 최적화
1. **웹뷰 성능 개선**:
   - 로딩 상태 처리 최적화
   - 메모리 사용량 최적화

2. **UI 렌더링 최적화**:
   - 불필요한 리렌더링 방지
   - 효율적인 상태 업데이트

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

✅ **모듈화 및 재사용성**
- Shared 모듈을 통한 컴포넌트 분리
- Constant 파일 중앙 집중화
- Example 프로젝트 문서화

✅ **웹뷰 및 URL 관리**
- 웹뷰 성능 최적화
- URL 상수화로 유지보수성 향상

---

## 🔄 리팩토링 효과

1. **코드 가독성 향상**: 각 화면별 책임 분리
2. **유지보수성 개선**: UseCase 패턴으로 비즈니스 로직 분리
3. **확장성 확보**: 새로운 온보딩 단계 추가 용이
4. **사용자 경험 개선**: 직관적인 플로우와 친화적 에러 메시지
5. **재사용성 향상**: Shared 모듈을 통한 컴포넌트 재사용
6. **개발 효율성 증대**: Example 프로젝트를 통한 빠른 개발 가이드

---

## 📊 작업 통계

- **총 커밋 수**: 8개
- **변경된 파일 수**: 200+ 개
- **새로 추가된 파일**: 50+ 개
- **리팩토링된 모듈**: 5개 (Onboarding, OAuth, Shared, Util, DesignSystem)
- **새로 추가된 기능**: 3개 (로그인 취소, 탭바 컴포넌트, URL 상수화)
