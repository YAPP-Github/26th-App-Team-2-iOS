# #65 계정관련 API 기능개선

## 📋 작업 개요
계정 관련 API 기능의 안정성과 사용자 경험 개선을 위한 종합적인 리팩토링 작업

## 🔧 주요 개선사항

### 1. ResetLocalStorage 프로토콜 제작 및 적용
- **목적**: 로그아웃 및 회원 탈퇴 시 일관된 로컬 데이터 초기화 처리
- **구현 내용**:
  - `ResetLocalStorageProtocol` 프로토콜 신규 제작
  - 토큰, 앱 그룹, 쿨다운, 회원 상태 등 모든 로컬 데이터 일괄 초기화 기능
  - `OAuthLogoutService`와 `UserProfileService`에 프로토콜 적용

```swift
public protocol ResetLocalStorageProtocol {
    var tokenStorage: TokenStorageProtocol { get }
    var tokenKeyHolder: TokenKeyHolderProtocol { get }
    var appGroupStorage: AppGroupStorageProtocol? { get }
    var appScheduleStorage: AppScheduleStorageProtocol { get }
    var breakTimeStorage: BreakTimeStorageProtocol { get }
    var cooldownStorage: CooldownStorageProtocol { get }
    var memberStateStorage: MemberStateStorageProtocol { get }
    var userDefaultsUserStorage: UserStorageProtocol { get }
    func localStorageReset() async throws
}
```

### 2. NetworkProvider EmptyData 응답 처리 개선
- **문제**: API 응답이 빈 데이터일 때 파싱 에러 발생
- **해결책**: 
  - `EmptyData` 타입에 대한 특별 처리 로직 추가
  - 빈 객체, 배열, 유효하지 않은 JSON 응답에 대한 안정적 처리
  - JSON 파싱 실패 시 `EmptyData` 반환으로 앱 크래시 방지

```swift
// EmptyData 타입인 경우 특별 처리
if Item.self == EmptyData.self {
    if data.isEmpty { return EmptyData() as! Item }
    
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        if let dict = jsonObject as? [String: Any], dict.isEmpty {
            return EmptyData() as! Item
        }
        if let array = jsonObject as? [Any], array.isEmpty {
            return EmptyData() as! Item
        }
    } catch {
        return EmptyData() as! Item
    }
}
```

### 3. 유저 프로필 서비스 개선
- **API 응답 타입 개선**: `MemberInfoResponse` → `BrakeResponse<MemberInfoResponse>`
- **토큰 인터셉터 적용**: 인증이 필요한 API 호출 시 자동 토큰 갱신 처리
- **ServiceDIContainer 의존성 주입 개선**: 토큰 인터셉터가 적용된 네트워크 프로바이더 사용

### 4. MyInfo 설정 화면 UI/UX 개선
- **TabBar 개선**: 
  - `report` 탭 제거 (사용하지 않는 기능)
  - 탭바 표시/숨김 상태 관리 개선
- **설정 화면 재구성**:
  - 섹션별 뷰 컴포넌트 분리 (`AccountSectionView`, `FeedbackSectionView`, `LegalSectionView`)
  - 재사용 가능한 설정 셀 컴포넌트 제작 (`MyInfoMainSettingCell`)
- **닉네임 변경 기능 개선**:
  - `@Bindable` 도입으로 반응형 UI 구현
  - 키보드 자동 숨김 기능 추가
  - 사용자 경험 향상

## 🏗️ 아키텍처 개선

### DI Container 구조 개선
- **CoreDIContainer**: 로컬 스토리지 관련 의존성 통합 관리
- **ServiceDIContainer**: 도메인 서비스 의존성 주입 최적화
- 토큰 인터셉터 적용 여부에 따른 네트워크 프로바이더 분리 제공

### 에러 처리 개선
- **AppGroupStorageError**: 앱 그룹 스토리지 관련 에러 타입 추가
- **네트워크 에러**: EmptyData 응답에 대한 안정적 처리로 예외 상황 최소화

## 📱 사용자 경험 개선
1. **로그아웃/회원탈퇴**: 모든 로컬 데이터가 완전히 초기화되어 보안 강화
2. **설정 화면**: 직관적인 UI와 부드러운 인터랙션
3. **네트워크 안정성**: API 응답 에러로 인한 앱 크래시 방지
4. **닉네임 변경**: 실시간 반영과 사용자 친화적 인터페이스

## 🔄 변경된 파일들
- **Core Layer**: NetworkProvider, LocalStorage 프로토콜들
- **Domain Layer**: OAuth, User 서비스들
- **Feature Layer**: MyInfo 관련 뷰와 뷰모델
- **App Layer**: DI Container 구조
- **Shared Layer**: DesignSystem TabBar 컴포넌트

## 🎯 기대효과
- 계정 관련 기능의 안정성 향상
- 일관된 데이터 초기화로 보안 강화
- 사용자 친화적인 설정 화면 제공
- 네트워크 에러 상황에서의 앱 안정성 확보
