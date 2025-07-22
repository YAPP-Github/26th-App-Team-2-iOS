# Network Interceptor 구현 작업 정리

## 📋 브랜치 정보
- **브랜치명**: `feat/#26-network-interceptor-making`
- **작업 기간**: 2025년 7월 20일 ~ 21일
- **주요 목표**: JWT 토큰 자동 갱신을 위한 Network Interceptor 구현

## 🎯 주요 작업 내용

### 1. TokenInterceptor 구현
- **위치**: `Projects/Core/Network/Interface/Sources/Interceptor/TokenInterceptor.swift`
- **구현체**: `Projects/Core/Network/Sources/TokenInterceptor.swift`
- **주요 기능**:
  - `adapt()`: 요청에 Bearer 토큰 자동 추가
  - `retry()`: 401 에러 시 토큰 자동 갱신 및 재시도

### 2. NetworkProvider 개선
- **위치**: `Projects/Core/Network/Sources/NetworkProvider.swift`
- **주요 개선사항**:
  - Interceptor를 통한 자동 인증 처리
  - 재귀 호출 제한 (최대 5회)
  - 401 에러 시 자동 토큰 갱신 로직

### 3. NetworkSession 구조 개선
- **위치**: `Projects/Core/Network/Interface/Sources/NetworkSession.swift`
- **주요 기능**:
  - URLRequestInterceptor 통합
  - 테스트를 위한 Mock 지원

### 4. 테스트 코드 작성
- **MockTokenInterceptor**: 테스트용 Interceptor
- **MockURLProtocol**: 네트워크 요청 모킹
- **FakeTokenStorage**: 토큰 저장소 모킹

## 💡 해결한 주요 문제들

### 1. LocalStorage > KeychainTokenStorage 테스트 실패
**문제**: 
KeyChain 값을 접근하려면 App Entitilement에서 capability 추가가 필수적이지만
테스트 모듈에는 Keychain Capability가 등록되어있지 않아
OS에서 errSecMissingEntitlement (-34018) -> 접근을 막는 문제 발생

### 2. NetworkProvider 테스트 코드 작성에 대한 고민과 NetworkSession 제작
**문제**: 
기존 NetworkProvider에 Interceptor 객체만 존재함.
실제 네트워킹을 하는 URLSession 객체가 request() 메서드 내부에 존재함
RequestInterceptor adapt, retry 로직이 제대로 작동하는지 검증하는 테스트 코드를 만들려할 때 문제가 발생
=> 실제 네트워킹을 통해서만 이 로직이 검증되어야함
가상 네트워킹이 가능한 Mock Interceptor와 URLSession으로 테스트를 빠르게 검증할 필요가 있었음
**해결**: NetworkSession 제작
URLRequestInterceptor, URLSession를 저장 파라미터로 갖는 NetworkSession 객체를 만들고 NetworkProvider가 이 객체를 갖도록 제작,
NetworkSession이 Interceptor의 adapt 처리 및 retry 처리에 필요한 urlSession을 제공하게 만듦
이를 통해 모두 공통된 urlSession으로 네트워킹을 할 수 있게 했으며, URLSession 모킹을 통해 가상의 네트워킹도 가능해져 테스트 수행 및 검증
```swift
 public struct NetworkSession {
    public let requestInterceptor: URLRequestInterceptor?
    public let urlSession: URLSession
```

### 3. 네트워크 재시도 로직 무한 루프 방지
**문제**: 토큰 갱신 실패 시 무한 재귀 호출 위험

**해결**: `limitCount` 파라미터로 최대 5회 제한
```swift
guard limitCount < 5 else {
    throw NetworkError.interceptorError("limitCount 5번 이상으로 재귀 호출되었습니다.")
}
```

### 4. JWT 디코딩 에러 처리
**문제**: JWT 토큰 디코딩 실패 시 적절한 에러 처리 부재

**해결**: 상세한 에러 분기 처리
```swift
catch DecodingError.dataCorrupted(let context) {
    throw NetworkError.interceptorError("Token Storage 디코딩을 실패했습니다. \(context.debugDescription)")
}
```

### 5. 테스트 환경에서 URLSession 모킹
**문제**: 실제 네트워크 요청 없이 테스트하는 방법 고민

**해결**: `MockURLProtocol` 구현으로 네트워크 요청 가로채기
```swift
let configuration = URLSessionConfiguration.default
configuration.protocolClasses = [MockURLProtocol.self]
return URLSession(configuration: configuration)
```
**추가로 한 경험**: 
MockURLProtocol 내부 startLoading 메서드에 내부 구현을 async-await으로 해 Task 객체로 감싼 구조임
but, 이 구조로 작성하면 여러 network session 호출 시, 여러 task가 동시에 작업을 하게 됨
이로 인한 continuation misuse 에러 발생!! => Task를 stopLoading 메서드 내부에서 명시적으로 cancel() 처리를 해서 해결함

### 6. RequestInterceptorTest 작성과 모킹 코드 구성 고민


## 📈 커밋 히스토리

### 주요 커밋들
1. **f39ec6c**: TokenInterceptor 기초 구성
2. **5e1a46e**: 인터셉터 구성을 위한 기본적인 Token 구조체 및 인터셉터 구현체 제작
3. **0bdb253**: 인터셉터 적용한 네트워크 메서드 기본 구조 제작 완료
4. **90864dc**: TokenStorage 타입 struct -> actor로 변환
5. **d359b37**: JWTDecoder 테스트 코드 작성
6. **07b7802**: interceptor 대응 네트워크 메서드 제작
7. **7de57de**: Retry 재귀 호출 횟수 방지
8. **9f8d906**: Interceptor Retry WhiteBox Test 추가 + CoreNetworkModule 폴더링 구조 개선
9. **e88f66d**: Network API 구성 Router 제작
10. **be7ced9**: TokenKeyHolder 객체명 수정
11. **7c2eac6**: 간단한 코드 오류 및 개선 사항 수정

## 🏗️ 아키텍처 개선사항

### 1. 모듈 구조 개선
```
Projects/Core/Network/
├── Interface/          # 프로토콜 및 인터페이스
├── Sources/           # 구현체
├── Testing/           # 테스트용 Mock 객체들
└── Tests/            # 단위 테스트
```

### 2. 의존성 주입 패턴 적용
- `TokenInterceptor`는 `TokenStorageProtocol`과 `TokenKeyHolderProtocol`을 주입받아 사용
- 테스트 시 Mock 객체로 쉽게 교체 가능

### 3. 에러 처리 체계화
- `NetworkError` enum으로 다양한 네트워크 오류 상황 정의
- `interceptorError(String)` 케이스로 Interceptor 관련 오류 처리

## 🧪 테스트 전략

### 1. Unit Test
- `JWTDecoderTest`: JWT 토큰 디코딩 테스트
- `TokenStorageTest`: 토큰 저장/조회 테스트
- `RequestInterceptTests`: Interceptor 동작 테스트

### 2. Integration Test
- 실제 네트워크 요청과 Interceptor 연동 테스트
- Mock을 활용한 다양한 시나리오 테스트

## 📝 향후 개선 과제

1. **토큰 갱신 실패 시 사용자 로그아웃 처리**
2. **네트워크 상태에 따른 재시도 전략 개선**
3. **토큰 만료 시간 기반 사전 갱신 로직**
4. **Interceptor 성능 최적화**

## 💡 배운 점

1. **Swift의 async/await 패턴**을 활용한 비동기 네트워크 처리
2. **Protocol Oriented Programming**을 통한 테스트 가능한 설계
3. **URLSession Interceptor** 패턴 구현 방법
4. **JWT 토큰 자동 갱신** 로직 설계
5. **Mock 객체를 활용한 네트워크 테스트** 기법

## 🔗 관련 파일들

### Core Files
- `Projects/Core/Network/Interface/Sources/Interceptor/TokenInterceptor.swift`
- `Projects/Core/Network/Sources/TokenInterceptor.swift`
- `Projects/Core/Network/Sources/NetworkProvider.swift`
- `Projects/Core/Network/Interface/Sources/NetworkSession.swift`

### Test Files
- `Projects/Core/Network/Tests/Sources/RequestInterceptTests.swift`
- `Projects/Core/Network/Testing/Sources/MockTokenInterceptor.swift`
- `Projects/Core/Network/Testing/Sources/MockURLProtocol.swift`
- `Projects/Core/Network/Testing/Sources/FakeTokenStorage.swift`

---
*작성일: 2025년 7월 21일*  
*작성자: Greem* 