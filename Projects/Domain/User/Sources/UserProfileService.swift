//
//  UserProfileService.swift
//  DomainUser
//
//  Created by Greem on 7/26/25.
//

import Foundation
import DomainUserInterface
import Core

extension UserProfileService: @retroactive UserProfileProtocol {
    
    public func setUserNickname(_ nickname: String) async throws {
        
        let setMemberNameRequest = SetMemberNameRequest(nickname: nickname)
        let userNameEndPoint = BrakeRouter.MemberEndPoint<MemberInfoResponse>.setName(setMemberNameRequest)
        let userMemberInfoResponse: MemberInfoResponse = try await networkProvider.request(userNameEndPoint)
        
        guard let memberStateType: MemberStateType = MemberStateType(
            rawValue: userMemberInfoResponse.state
        ) else {
            assertionFailure("알 수 없는 멤버 상태")
            return
        }
        
        userStorage.saveNickName(userMemberInfoResponse.nickname)
        onboardingState.setMemberState(memberStateType)
    }
    
    public func getUserNickName() async throws -> String {
        if let nickName = self.userStorage.getNickName() { return nickName }
        
        let memberInfoEndPoint = BrakeRouter.MemberEndPoint<MemberInfoResponse>.getInfo
        let userMemberInfoResponse: MemberInfoResponse = try await networkProvider.request(memberInfoEndPoint)
        
        let nickname = userMemberInfoResponse.nickname
        
        guard let memberStateType: MemberStateType = MemberStateType(
            rawValue: userMemberInfoResponse.state
        ) else {
            assertionFailure("알 수 없는 멤버 상태")
            return nickname
        }
        
        
        self.userStorage.saveNickName(nickname)
        self.onboardingState.setMemberState(memberStateType)
        
        return nickname
    }
}
