### 🎯 주요 목표
Xcode Cloud 배포 과정에서 발생하는 shell script 실행 실패 문제 해결

### 🐛 발생한 문제
- **에러 위치**: `ci_post_clone.sh` 스크립트 실행 중
- **에러 원인**: `mise` 설치 과정에서 Tuist 4.17.0 다운로드 실패
- **에러 메시지**: 
  ```
  asdf-tuist: Could not download https://github.com/tuist/tuist/releases/download/4.17.0/tuist.zip
  mise ERROR Failed to install tool: tuist@4.17.0
  ```

### 🔧 해결 방법

#### 1. **mise 설치 방식 변경**
- **변경 전**: `brew install mise`
- **변경 후**: `curl https://mise.run | sh`
- **이유**: brew 방식에서 발생하는 설치 오류를 회피하기 위해 공식 설치 방법으로 변경

#### 2. **PATH 환경 변수 개선**
```bash
# 기존
export PATH="$HOME/.local/share/mise/shims:$PATH"

# 변경 후  
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
```

#### 3. **mise 활성화 설정 추가**
```bash
echo 'eval "$($HOME/.local/bin/mise activate bash)"' >> ~/.bashrc
```

#### 4. **Extension 앱들에 CFBundleDisplayName 추가**
- DeviceActivityMonitorExtension
- NotificationExtension  
- ShieldActionConfigurationExtension
- ShieldConfigurationExtension
- 각 Extension의 Info.plist에 CFBundleDisplayName 속성 추가



### 📁 주요 변경 파일들

#### CI/CD 스크립트
- `ci_scripts/ci_post_clone.sh` - mise 설치 방식 변경
- `ci_scripts/ci_post_clone_sub_scripts/app_settings.sh` - 스크립트 개선
+ Release 용 xcconfig 파일 수정

#### Extension 관련
- `Projects/App/Extensions/*/Info.plist` - CFBundleDisplayName 추가
- `Projects/App/Extensions/*/Sources/*.swift` - Extension 구현 개선

#### 기타
- 다양한 프로젝트 설정 파일들 및 빌드 스키마 수정
- Workspace 빌드 오류 해결을 위한 코드 정리

### 🎉 결과
- **TestFlight 업로드 성공** ✅
- Xcode Cloud 배포 파이프라인 정상 작동
- Extension 앱들의 표시명 정상 설정

### 📊 커밋 통계
- **총 커밋 수**: 22개 커밋
- **주요 작업**: CI/CD 스크립트 수정, Extension 설정 개선, 빌드 오류 해결
- **최종 상태**: TestFlight 업로드 성공으로 배포 문제 완전 해결

이 브랜치는 Xcode Cloud 배포 실패 문제를 체계적으로 해결하여 성공적인 TestFlight 업로드를 달성한 중요한 수정사항들을 포함하고 있습니다.