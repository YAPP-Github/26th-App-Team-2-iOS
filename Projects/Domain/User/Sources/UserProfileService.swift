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
            throw MemberStateError.unknownType
        }
        
        userStorage.saveNickname(userMemberInfoResponse.nickname)
        onboardingState.setMemberState(memberStateType)
    }
    
    public func getUserNickname() async throws -> String {
        if let nickname = self.userStorage.getNickname() { return nickname }
        
        let memberInfoEndPoint = BrakeRouter.MemberEndPoint<BrakeResponse<MemberInfoResponse>>.getInfo
        let userMemberInfoResponse: BrakeResponse<MemberInfoResponse> = try await networkProvider.request(memberInfoEndPoint)
        
        let nickname = userMemberInfoResponse.data.nickname
        
        guard let memberStateType: MemberStateType = MemberStateType(
            rawValue: userMemberInfoResponse.data.state
        ) else {
            assertionFailure("알 수 없는 멤버 상태")
            throw MemberStateError.unknownType
        }
        
        
        self.userStorage.saveNickname(nickname)
        self.onboardingState.setMemberState(memberStateType)
        
        return nickname
    }
    
    public func deleteUser() async throws {
        let deleteEndPoint = BrakeRouter.MemberEndPoint<BrakeResponse<EmptyData>>.delete
        let _: BrakeResponse<EmptyData> = try await networkProvider.request(deleteEndPoint)
        
        // 회원탈퇴 성공 시 로컬 데이터 정리
        userStorage.deleteNickname()
        try await tokenStorage.deleteAllTokens()
    }

}
