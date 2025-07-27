# feat/#39-DeviceActivity-Extension-연동 기술적 도전 과제 해결 기록

## 🎯 고민하고 해결한 핵심 문제들

### 1. DeviceActivity Extension 로드 문제 → App Group 통신으로 창의적 해결

#### 문제 상황
- **현상**: Extension이 로드되지 않아 `intervalDidStart`가 호출되지 않음
- **원인**: Extension은 별도 프로세스에서 실행되어 메인 앱 콘솔에 로그가 표시되지 않음
- **추가 문제**: Extension이 실제로 빌드되지 않거나 시스템에 등록되지 않음

#### 해결책
```swift
// DeviceActivityMonitorExtension.swift - App Group 통신 방식
- Extension의 print 문 제거 (메인 앱 콘솔에 표시되지 않음)
- App Group UserDefaults를 통한 상태 전달
- Extension init, interval 시작/종료 시간을 메인 앱에 전달
- Extension 테스트 로그를 App Group으로 공유
```

**결과**: Extension 로드 상태를 정확히 추적하고 디버깅 가능

### 2. Extension 의존성 문제 → SharedUtil 모듈 연동

#### 설계 고민
- Extension에서 `SharedUtil` 모듈을 찾을 수 없다는 빌드 에러
- Tuist 멀티 모듈 환경에서 Extension의 의존성 설정
- Interface와 Implementation 분리

#### 해결한 의존성 구조
```
CoreAppScreenTime/
├── Extensions/
│   ├── DeviceActivityMonitorExtension/
│   ├── ShieldConfigurationExtension/
│   └── ShieldActionConfigurationExtension/
└── Sources/
    ├── Interface/ (SharedUtil 의존성 추가)
    └── Sources/ (SharedUtil 의존성 추가)
```

**핵심 설계 결정**:
- **Extension별 의존성 추가**: 각 Extension에 `SharedUtil` 의존성 명시
- **Interface 레벨 의존성**: `CoreAppScreenTimeInterface`에도 `SharedUtil` 추가
- **프로젝트 재생성**: Tuist generate로 의존성 반영

### 3. 스케줄 저장 및 차단 해제 로직의 복잡성

#### 기술적 도전
- BlockSchedule이 생성되지만 저장되지 않는 문제
- Extension에서 저장된 스케줄을 찾을 수 없음
- 차단 해제 시 빈 배열을 전달하여 해제되지 않음

#### 해결한 BlockScheduleManager 로직
```swift
// BlockScheduleManager.swift 핵심 수정
public func create(_ model: BlockSchedule) throws {
    // 스케줄 저장 (이전에 누락됨)
    save(model)
    
    // 모니터링 시작
    try center.startMonitoring(model)
    
    // 블록 리스트 설정
    managedSettingsManager.updateBlockList(for: model)
}
```

**기술적 포인트**:
- **저장 로직 추가**: `create` 함수에 `save(model)` 호출 추가
- **디버깅 로그**: 스케줄 생성, 저장, 모니터링 과정 추적
- **readAll 함수 개선**: 저장된 스케줄 ID와 실제 로드된 스케줄 수 확인

### 4. Extension intervalDidStart에서 차단 해제 로직

#### 복잡한 요구사항
- Extension이 실제로 차단된 앱에 접근할 때만 실행됨
- 타이머 설정만으로는 Extension이 실행되지 않음
- 저장된 모든 스케줄을 가져와서 차단 해제해야 함

#### 해결한 Extension 로직
```swift
// DeviceActivityMonitorExtension.swift 핵심 구현
override func intervalDidStart(for activity: DeviceActivityName) {
    if activity == .brake {
        // 저장된 모든 스케줄을 가져와서 차단 해제
        let allSchedules = blockScheduleManager.readAll()
        managedSettingsManager.clearAllBlockListsForRest(schedules: allSchedules)
        
        // App Group을 통해 상태 업데이트
        userDefaults?.set("Interval started: brake - cleared \(allSchedules.count) schedules", forKey: "ExtensionStatus")
    }
}
```

**기술적 도전점**:
- **실제 스케줄 전달**: 빈 배열 대신 `readAll()`로 실제 저장된 스케줄 전달
- **상태 추적**: App Group을 통해 Extension 실행 상태 확인
- **강제 실행 테스트**: Extension 로직을 수동으로 실행하는 테스트 버튼 추가

### 5. ManagedSettings 차단 해제의 비결정성

#### 기술적 도전
- `ManagedSettingsStore`의 차단 해제가 즉시 반영되지 않음
- 특정 스케줄의 store와 기본 store 모두 해제해야 함
- iOS의 특성상 여러 번의 시도가 필요할 수 있음

#### 해결한 ManagedSettingsStoreManager 로직
```swift
// ManagedSettingsStoreManager.swift 강화된 해제 로직
public func clearAllBlockListsForRest(schedules: [BlockSchedule]) {
    // 1. 각 스케줄별로 해제
    schedules.forEach { schedule in
        clearBlockList(for: schedule)
    }

    // 2. 기본 ManagedSettingsStore로도 해제 시도
    let defaultStore = ManagedSettingsStore()
    defaultStore.clearShield()
    
    // 3. 모든 Shield 설정을 강제로 해제
    defaultStore.shield.applicationCategories = .none
    defaultStore.shield.applications = []
    defaultStore.shield.webDomains = []
    
    // 4. 추가적인 해제 시도
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        let retryStore = ManagedSettingsStore()
        retryStore.clearShield()
    }
}
```

**기술적 포인트**:
- **다층 해제**: 특정 store + 기본 store + 강제 해제
- **지연 재시도**: 0.5초 후 추가 해제 시도
- **상태 확인**: 각 단계별 로그로 해제 과정 추적

### 6. 15분 미만 제한 처리 (DeviceActivity + UI)

#### 기술적 도전
- DeviceActivity의 15분 미만 제한을 사용자에게 어떻게 전달할 것인가?
- 에러 메시지 vs 사전 제한 옵션 중 어떤 방식이 더 나은 UX인가?

#### 해결한 처리 방식
```swift
// BreakTimeManager.swift - 15분 미만 검증
public func createBreakTime(minutes: Int) throws {
    guard minutes >= 15 else {
        throw DeviceActivityCenterError.intervalTooShort
    }
    // DeviceActivity 스케줄 생성...
}

// TimerSettingView.swift - UI에서 사전 제한
private let timeOptions = Array(stride(from: 15, through: 60, by: 5)) // 15분부터 시작
```

**UX 설계 결정**:
- **사전 제한**: UI에서 15분 미만 옵션을 아예 제거하여 혼란 방지
- **명확한 에러 메시지**: 혹시 모를 에러 상황에 대한 친화적인 안내
- **5분 단위**: 15, 20, 25... 60분으로 사용자 선택 편의성 확보

## 🔍 해결 과정에서 얻은 인사이트

### Extension 개발
- **Extension은 별도 프로세스**이므로 App Group을 통한 통신이 필수
- **Extension 로드 확인**은 빌드 설정과 시스템 등록 상태를 모두 확인해야 함
- **실제 앱 차단 상태**에서만 Extension이 실행되는 특성 이해

### DeviceActivity 프레임워크
- **최소 15분 이상**의 interval이 필요 (iOS 제약사항)
- **크로스데이 interval** 지원 (11:59 PM + 15분 = 12:14 AM)
- **Extension 실행 조건**이 매우 제한적 (차단된 앱 접근 시에만)

### ManagedSettings 프레임워크
- **차단 해제의 비결정성**으로 인한 다층 해제 로직 필요
- **특정 store와 기본 store** 모두 해제해야 완전한 해제
- **지연된 재시도**가 안정적인 해제에 필수

### 아키텍처 설계
- **UseCase 패턴**이 복잡한 비즈니스 로직 분리에 매우 효과적
- **의존성 주입**으로 테스트 가능성과 확장성 확보
- **Interface 분리**로 모듈 간 결합도 최소화

### 개발 프로세스
- **단계별 커밋**으로 문제 범위 빠르게 좁히기
- **디버깅 로그**로 Extension 실행 상태 정확히 추적
- **테스트 버튼**으로 기능 검증과 디버깅 효율성 증대

## 🚀 최종 결과

### 성공적으로 구현된 기능들
1. **앱 선택 및 차단**: FamilyActivityPicker를 통한 앱 선택, BlockSchedule 생성 및 저장
2. **타이머 설정**: 15-60분 휴식 시간 설정, DeviceActivity 스케줄 생성
3. **자동 차단 해제**: Extension의 intervalDidStart로 자동 차단 해제
4. **자동 차단 재적용**: Extension의 intervalDidEnd로 자동 차단 재적용
5. **상태 추적**: App Group을 통한 Extension 실행 상태 실시간 확인

### 기술적 성과
- **Extension 연동 성공**: DeviceActivityMonitorExtension 정상 로드 및 실행
- **안정적인 차단 해제**: 다층 해제 로직으로 확실한 차단 해제
- **확장 가능한 구조**: 새로운 차단 기능 추가 시 UseCase만 확장하면 됨
- **사용자 친화적 제한 처리**: 15분 미만 제한을 UI 레벨에서 사전 차단하여 혼란 방지 