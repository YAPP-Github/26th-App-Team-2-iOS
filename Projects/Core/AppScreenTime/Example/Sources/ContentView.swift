//
//  ContentView.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/20/25.
//

import SwiftUI
import FamilyControls
import CoreAppScreenTimeInterface
import ManagedSettings

struct ContentView: View {
    @State private var model = BlockingViewModel.shared
    @State private var isPresented = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    private let blocker = ApplicationBlocker()

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()
                appSelectionButton
                Spacer()
                selectedAppsList
                Spacer()
                buttonStack
            }
        }
        .onAppear {
            requestAuthorization()
        }
        .alert("알림", isPresented: $showingAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - UI Components

    private var appSelectionButton: some View {
        Button(action: { isPresented.toggle() }) {
            Text("차단할 앱 목록 확인하기 🤗")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.blue)
                .cornerRadius(8)
        }
        .familyActivityPicker(isPresented: $isPresented, selection: $model.newSelection)
    }

    private var selectedAppsList: some View {
        let selectedAppsTokens = Array(model.selectedAppsTokens)
        let selectedCategoryTokens = Array(model.newSelection.categoryTokens)

        return Group {
            if !selectedAppsTokens.isEmpty || !selectedCategoryTokens.isEmpty {
                SelectedAppsListView(selectedAppsTokens: selectedAppsTokens, selectedCategoryTokens: selectedCategoryTokens)
            } else {
                // 빈 상태일 때도 공간을 차지하도록
                VStack {
                    Text("선택된 앱이 없습니다")
                        .foregroundColor(.gray)
                        .padding()
                }
                .frame(height: 100)
            }
        }
    }

    private struct SelectedAppsListView: View {
        let selectedAppsTokens: [ApplicationToken]
        let selectedCategoryTokens: [ActivityCategoryToken]

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("선택된 앱:")
                    .font(.headline)
                    .foregroundColor(.black)

                ForEach(selectedAppsTokens.indices) { index in
                    Text("selectedCategoryTokens - \(index)")
                        .font(.headline)
                        .foregroundColor(.black)
                }

                ForEach(selectedCategoryTokens.indices) { index in
                    Text("selectedCategoryTokens - \(index)")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }

    private var buttonStack: some View {
        VStack(spacing: 10) {
            Button(action: blockApps) {
                Text("차단하기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .cornerRadius(8)
            }

            Button(action: unblockApps) {
                Text("해제하기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 60)
    }

    // MARK: - Actions

    private func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            } catch {
                await MainActor.run {
                    alertMessage = "권한 요청 실패: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }

    private func blockApps() {
        blocker.block { result in
            Task { @MainActor in
                switch result {
                case .success():
                    alertMessage = "차단 성공"
                    showingAlert = true
                case .failure(let error):
                    alertMessage = "차단 실패: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }

    private func unblockApps() {
        blocker.clearShield()
        alertMessage = "차단 해제 완료"
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
