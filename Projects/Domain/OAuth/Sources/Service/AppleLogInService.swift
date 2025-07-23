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
        let identityStream = AsyncStream<Result<String, AuthError>> { [weak self] continuation in
            guard let self else {
                assertionFailure("잘못된 weak self 부릅니다!!")
                return
            }
            self.identityContinuation = continuation
        }
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        for await userIdentityResult in identityStream {
            switch userIdentityResult {
            case .success(let userIdentity):
                
                
                return .apple
            case .failure(let failure): throw failure
            }
        }
        
        throw AuthError.invalidToken
    }
}

extension AppleLogInService: @retroactive ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        let appleOAuthError: AppleOAuthError = switch (error as NSError).code {
        case 1000: .unknown
        case 1001: .canceled
        case 1002: .invalidResponse
        case 1003: .notHandled
        case 1004: .failed
        case 1005: .notInteractive
        default: .otherError(error)
        }
        self.identityContinuation?.yield(.failure(.appleOAuthError(appleOAuthError)))
        self.identityContinuation?.finish()
        return
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential: ASAuthorizationAppleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.identityContinuation?.yield(.failure(.appleOAuthError(.unknown)))
            identityContinuation?.finish()
            return
        }
        
        // guard let _ : Data = appleIDCredential.identityToken else {
        //     self.identityContinuation?.yield(.failure(.appleOAuthError(.tokenMissing)))
        //     identityContinuation?.finish()
        //     return
        // }
        
        guard let authorizationCodeData: Data = appleIDCredential.authorizationCode else {
            self.identityContinuation?.yield(.failure(.appleOAuthError(.authorizationCodeMissing)))
            identityContinuation?.finish()
            return
        }
        
        let authorizationCode = String(decoding: authorizationCodeData, as: UTF8.self)
        identityContinuation?.yield(.success(authorizationCode))
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
