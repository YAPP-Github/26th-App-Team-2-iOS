//
//  ContentView.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/20/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import CoreAppScreenTimeInterface
import CoreAppScreenTime
import CoreLocalStorageInterface
import CoreLocalStorage
import Observation
import DeviceActivity

struct ContentView: View {

    @Environment(BlockingViewModel.self) var viewModel
    @State private var currentSchedule: BlockSchedule?

    @Environment(\.scenePhase) var phase

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Spacer()
                        appSelectionButton
                        Spacer()
                        
                        // 액션 버튼들
                        VStack(spacing: 10) {
                            Button(action: blockApps) {
                                Text("앱 차단")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: unblockApps) {
                                Text("앱 차단 해제")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
                            
                            // 차단창 테스트 버튼들
                            Button(action: testBlockingStatus) {
                                Text("차단창 테스트 (Blocking)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: testExtensionPrompt) {
                                Text("연장 프롬프트 테스트")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.orange)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: testCooldownActive) {
                                Text("쿨다운 테스트")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.purple)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: clearAllStatus) {
                                Text("상태 초기화")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.gray)
                                    .cornerRadius(8)
                            }

                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                requestAuthorization()
            }
            .sheet(isPresented: .init(get: {
                viewModel.isPresentedTimerSettingView
            }, set: { newValue in
                viewModel.isPresentedTimerSettingView = newValue
            })) {
                TimerSettingView { selectedTime in
                    do {
                        try viewModel.breakTimeManager.createBreakTime(minutes: selectedTime)
                        viewModel.appScheduleStorage.saveExtensionCount(0) // 초기화 필요
                        viewModel.appScheduleStorage.saveSelectNotificationTrigger(false)
                    } catch DeviceActivityCenterError.intervalTooShort {
                        print("휴식 시간이 너무 짧습니다. 최소 15분 이상 설정해주세요.")
                    } catch {
                        print("휴식 시간 설정 실패: \(error)")
                    }
                }
            }
            .onChange(of: phase, { oldValue, newValue in
                switch newValue {
                case .active:
                    viewModel.blockViewOnAppeared()
                case .inactive:
                    break
                case .background:
                    break
                default:
                    break
                }
            })
            .navigationTitle("앱 차단 관리")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - UI Components

    private var appSelectionButton: some View {
        Button(action: {
            viewModel.isPresented = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                Text("앱 선택")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .familyActivityPicker(
            isPresented: .init(get: {
                viewModel.isPresented
            }, set: { newValue in
                viewModel.isPresented = newValue
            }),
            selection: .init(get: {
                viewModel.newSelection
            }, set: { newValue in
                viewModel.newSelection = newValue
            })
        )
    }

    // MARK: - Actions

    private func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            } catch {
        
            }
        }
    }

    private func blockApps() {
        do {
            let schedule = BlockSchedule(
                id: UUID().uuidString,
                title: "차단된 앱",
                blockList: viewModel.newSelection,
                startTime: BlockTime(hour: 00, minute: 00),
                endTime: BlockTime(hour: 23, minute: 59)
            )
            self.currentSchedule = schedule

            try viewModel.blockScheduleManager.create(schedule)
        } catch {
            
        }
    }

    private func unblockApps() {
        guard let currentSchedule = currentSchedule else { return }
        viewModel.blockScheduleManager.delete(currentSchedule)
    }
    
    // MARK: - 차단창 테스트 메서드들
    
    private func testBlockingStatus() {
        // 기본 차단 상태 설정
        viewModel.appScheduleStorage.saveBlockingStatus(.blocking(tokenName: "테스트 앱"))
        print("✅ 차단 상태 설정 완료: blocking")
    }
    
    private func testExtensionPrompt() {
        // 연장 프롬프트 상태 설정
        viewModel.appScheduleStorage.saveBlockingStatus(.extensionPrompt(tokenName: "", time: 15, count: 1, startDate: .now, endDate: .now.addingTimeInterval(15 * 60)))
        print("✅ 연장 프롬프트 상태 설정 완료: extensionPrompt(time: 5, count: 1)")
    }
    
    private func testCooldownActive() {
        // 쿨다운 활성 상태 설정
        viewModel.appScheduleStorage.saveBlockingStatus(
            .cooldownActive(
                tokenName: "테스트앱",
                time: 15,
                groupName: "SNS 앱",
                startDate: .now,
                endDate: .now.addingTimeInterval(15 * 60)
            )
        )
        print("✅ 쿨다운 상태 설정 완료: cooldownActive")
    }
    
    private func clearAllStatus() {
        // 모든 상태 초기화
        viewModel.appScheduleStorage.saveBlockingStatus(.unlockedTemporarily)
        print("✅ 상태 초기화 완료: unlockedTemporarily")
    }

}
