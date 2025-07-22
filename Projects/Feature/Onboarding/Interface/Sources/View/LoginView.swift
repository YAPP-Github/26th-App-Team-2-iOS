//
//  LoginView.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//
import SwiftUI

struct LoginView: View {
    
    @Environment(LogInViewModel.self) var logInViewModel
    
    var body: some View {
        VStack {
            Button {
                logInViewModel.appleLogInBtnTapped()
            } label: {
                Text("Apple로 로그인")
            }
            
            Button {
                logInViewModel.kakaoLogInBtnTapped()
            } label: {
                Text("카카오로 로그인")
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(LogInViewModel())
}
