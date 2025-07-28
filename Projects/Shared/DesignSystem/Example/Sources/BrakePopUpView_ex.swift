//
//  BrakePopUpView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/28/25.
//

import SwiftUI
import SharedDesignSystem

struct BrakePopUpView_ex: View {
    @State private var showAppUsageAlert = false
    @State private var showWithdrawalAlert = false
    @State private var showGroupDeleteAlert = false
    @State private var showLogoutAlert = false
    @State private var showSuccessAlert = false
    @State private var showCustomAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("BrakeAlertView Examples")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                
                // 앱 사용 종료 알림
                VStack(spacing: 15) {
                    Text("앱 사용 종료 알림")
                        .font(.subheadline)
                        .foregroundStyle(Color.grey700)
                    
                    Button("앱 사용 종료") {
                        showAppUsageAlert = true
                    }
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.insightBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // 탈퇴 확인 알림
                VStack(spacing: 15) {
                    Text("탈퇴 확인 알림")
                        .font(.subheadline)
                        .foregroundStyle(Color.grey700)
                    
                    Button("탈퇴하기") {
                        showWithdrawalAlert = true
                    }
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.error)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // 그룹 삭제 알림
                VStack(spacing: 15) {
                    Text("그룹 삭제 알림")
                        .font(.subheadline)
                        .foregroundStyle(Color.grey700)
                    
                    Button("그룹 삭제") {
                        showGroupDeleteAlert = true
                    }
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.brakeYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // 로그아웃 알림
                VStack(spacing: 15) {
                    Text("로그아웃 알림")
                        .font(.subheadline)
                        .foregroundStyle(Color.grey700)
                    
                    Button("로그아웃") {
                        showLogoutAlert = true
                    }
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.grey600)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // 성공 알림
                VStack(spacing: 15) {
                    Text("성공 알림")
                        .font(.subheadline)
                        .foregroundStyle(Color.grey700)
                    
                    Button("성공 메시지") {
                        showSuccessAlert = true
                    }
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.guideGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // 커스텀 알림
                VStack(spacing: 15) {
                    Text("커스텀 알림")
                        .font(.subheadline)
                        .foregroundStyle(Color.grey700)
                    
                    Button("커스텀 알림") {
                        showCustomAlert = true
                    }
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.grey500)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("BrakeAlertView Example")
        .navigationBarTitleDisplayMode(.inline)
        .brakePopUp(
            isPresented: $showAppUsageAlert,
            title: "앱 사용을 종료할까요?",
            message: "예정보다 일찍 마무리하셨네요. 멋진 선택이에요!",
            icon: Image.iconConfetti,
            primaryButtonTitle: "종료하기"
        ) {
            showAppUsageAlert = false
            print("앱 사용 종료됨")
        }
        .brakePopUp(
            isPresented: $showWithdrawalAlert,
            title: "정말 탈퇴하시겠어요?",
            message: "탈퇴하면 모든 계정 정보와 이용 기록이 삭제되며, 복구할 수 없습니다.",
            icon: Image.iconConfettiThunder,
            alertType: .doubleButton,
            primaryButtonTitle: "탈퇴",
            secondaryButtonTitle: "취소"
        ) {
            showWithdrawalAlert = false
            print("탈퇴 완료")
        } secondaryAction: {
            showWithdrawalAlert = false
            print("탈퇴 취소")
        }
        .brakePopUp(
            isPresented: $showGroupDeleteAlert,
            title: "그룹을 삭제할까요?",
            message: "삭제한 그룹은 복구할 수 없습니다.",
            alertType: .doubleButton,
            primaryButtonTitle: "삭제",
            secondaryButtonTitle: "취소"
        ) {
            showGroupDeleteAlert = false
            print("그룹 삭제 완료")
        } secondaryAction: {
            showGroupDeleteAlert = false
            print("그룹 삭제 취소")
        }
        .brakePopUp(
            isPresented: $showLogoutAlert,
            title: "로그아웃 하시겠습니까?",
            alertType: .doubleButton,
            primaryButtonTitle: "로그아웃",
            secondaryButtonTitle: "취소"
        ) {
            showLogoutAlert = false
            print("로그아웃 완료")
        } secondaryAction: {
            showLogoutAlert = false
            print("로그아웃 취소")
        }
        .brakePopUp(
            isPresented: $showSuccessAlert,
            title: "성공적으로 완료되었습니다!",
            message: "모든 작업이 정상적으로 처리되었습니다.",
            icon: Image(systemName: "hands.sparkles.fill"),
            primaryButtonTitle: "확인"
        ) {
            showSuccessAlert = false
            print("성공 알림 닫기")
        }
        .brakePopUp(
            isPresented: $showCustomAlert,
            title: "커스텀 알림",
            message: "이것은 사용자가 직접 만든 커스텀 알림입니다.",
            icon: Image(systemName: "star.fill"),
            alertType: .doubleButton,
            primaryButtonTitle: "확인",
            secondaryButtonTitle: "취소"
        ) {
            showCustomAlert = false
            print("커스텀 알림 확인")
        } secondaryAction: {
            showCustomAlert = false
            print("커스텀 알림 취소")
        }
    }
}

#Preview {
    NavigationStack {
        BrakePopUpView_ex()
    }
} 
