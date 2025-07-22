//
//  AppleLogInService.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation
import AuthenticationServices
import DomainOAuthInterface

extension AppleLogInService: @retroactive OAuthServiceProtocol {
    public func login() async throws -> OAuthType {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        self.identityContinuation?.finish()
        self.identityContinuation = nil
        let identityStream = AsyncStream<Result<String, Error>> { [weak self] continuation in
            guard let self else {
                assertionFailure("잘못된 유저를 부릅니다!!")
                return
            }
            self.identityContinuation = continuation
        }
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        for await userIdentity in identityStream {
            switch userIdentity {
            case .success(let success):
                print("성공한 login", success)
                return .apple
            case .failure(let failure): throw failure
            }
        }
        
        throw AuthError.invalidToken
    }
}

extension AppleLogInService: @retroactive ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        self.identityContinuation?.yield(.failure(AuthError.invalidToken))
        self.identityContinuation?.finish()
        return
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential: ASAuthorizationAppleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.identityContinuation?.yield(.failure(AuthError.invalidToken))
            return
        }
        
        guard let identityTokenData: Data = appleIDCredential.identityToken else {
            self.identityContinuation?.yield(.failure(AuthError.invalidToken))
            return
        }
        
        let identityToken: String = String(decoding: identityTokenData, as: UTF8.self)
        
        identityContinuation?.yield(.success(identityToken))
        identityContinuation?.finish()
    }
    
}

extension AppleLogInService: @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return UIWindow()
        }
        
        return window
    }
}
