//
//  KakaoLogInWebView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation
import SwiftUI
@preconcurrency import WebKit

// MARK: - 상수 정의
private struct KakaoConstants {
    static let authURL = "https://kauth.kakao.com"
    static let accountURL = "https://accounts.kakao.com"
    static let middleURL = "https://logins.daum.net"
    static let redirectURL: String = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REDIRECT_URL") as! String
    
    // BuildConfig 대신 실제 키 값으로 변경 필요
    static let restAPIKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as! String
    static let jsKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_JS_KEY") as! String
    
    static var baseURL: String {
        return "\(authURL)/oauth/authorize" +
        "?response_type=code" +
        "&client_id=\(restAPIKey)" +
        "&redirect_uri=\(redirectURL)" +
        "&prompt=login"
    }
    
    static let allowedPrefixes = [
        authURL,
        accountURL,
        redirectURL,
        middleURL,
        "https://talk-apps"
    ]
}

// MARK: - KakaoWebView (UIViewRepresentable)
struct KakaoWebView: UIViewRepresentable {
    let onAuthSuccess: (String) -> Void
    let onAuthError: (Error) -> Void
    @Environment(LogInViewModel.self) var logInViewModel
    @State private var inAppLoaded = false
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        config.defaultWebpagePreferences = WKWebpagePreferences()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        // 초기 URL 로드
        if let url = URL(string: KakaoConstants.baseURL) {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // 필요한 경우 업데이트 로직
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: KakaoWebView
        private var inAppLoaded = false
        
        init(_ parent: KakaoWebView) {
            self.parent = parent
        }
        
        // MARK: - WKNavigationDelegate
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            let urlString = url.absoluteString
            
            
            // 카카오톡 URL Scheme 처리
            if urlString.hasPrefix("kakao") && !inAppLoaded {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url) { success in
                        if success {
                            self.inAppLoaded = true
                        }
                    }
                    decisionHandler(.cancel)
                    return
                }
            }
            
            // 허용된 URL 체크
            let isAllowed = KakaoConstants.allowedPrefixes.contains { prefix in
                urlString.hasPrefix(prefix)
            }
            
            if !isAllowed {
                parent.onAuthError(KakaoAuthError.unauthorizedURL)
                decisionHandler(.cancel)
                return
            }
            
            // 리다이렉트 URL 처리
            if urlString.hasPrefix(KakaoConstants.redirectURL) {
                handleRedirectURL(urlString)
                decisionHandler(.cancel)
                return
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let currentURL = webView.url?.absoluteString else { return }
            
            // 카카오 계정 페이지에서 카카오톡 앱 연동 시도
            if currentURL.hasPrefix(KakaoConstants.accountURL) && isKakaoTalkInstalled() && !inAppLoaded {
                injectKakaoSDK(webView)
            }
            
            // 입력 필드 커서 위치 설정
            setupInputCursorPosition(webView)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.onAuthError(error)
        }
        
        // MARK: - Private Methods
        private func handleRedirectURL(_ urlString: String) {
            guard let urlComponents = URLComponents(string: urlString) else {
                parent.onAuthError(KakaoAuthError.invalidRedirectURL)
                return
            }
            
            let queryItems = urlComponents.queryItems ?? []
            if let errorParam = queryItems.first(where: { $0.name == "error" })?.value {
                parent.onAuthError(KakaoAuthError.authFailed(errorParam))
            } else if let code = queryItems.first(where: { $0.name == "code" })?.value {
                parent.onAuthSuccess(code)
            } else {
                parent.onAuthError(KakaoAuthError.noAuthCode)
            }
        }
        
        private func isKakaoTalkInstalled() -> Bool {
            guard let kakaoURL = URL(string: "kakaokompassauth://") else { return false }
            return UIApplication.shared.canOpenURL(kakaoURL)
        }
        
        private func injectKakaoSDK(_ webView: WKWebView) {
            let jsCode = """
            (function(){
                if (!window.Kakao) {
                    var script = document.createElement('script');
                    script.src = 'https://t1.kakaocdn.net/kakao_js_sdk/2.7.5/kakao.min.js';
                    script.integrity = 'sha384-dok87au0gKqJdxs7msEdBPNnKSRT+/mhTVzq+qOhcL464zXwvcrpjeWvyj1kCdq6';
                    script.crossOrigin = 'anonymous';
                    script.onload = function(){ 
                        Kakao.init('\(KakaoConstants.jsKey)');
                        Kakao.Auth.authorize({redirectUri:'\(KakaoConstants.redirectURL)'});
                        Kakao.Auth.login();
                    };
                    document.head.appendChild(script);
                }
            })();
            """
            
            webView.evaluateJavaScript(jsCode) { result, error in
                if let error = error {
                    assertionFailure("JS 코드 이식 문제: \(error.localizedDescription)")
                } else {
                    
                }
            }
        }
        
        private func setupInputCursorPosition(_ webView: WKWebView) {
            let jsCode = """
            (function(){
                document.querySelectorAll('input').forEach(input => {
                    let prevPos = 0;
                    
                    // 입력 직전의 커서 위치 기록
                    input.addEventListener('beforeinput', e => {
                        prevPos = input.selectionStart;
                    });
                    
                    // 실제 값이 바뀐 뒤, 커서를 prevPos+입력문자수 위치로 이동
                    input.addEventListener('input', e => {
                        const inserted = e.data || '';
                        const newPos = prevPos + inserted.length;
                        input.setSelectionRange(newPos, newPos);
                    });
                });
            })();
            """
            
            webView.evaluateJavaScript(jsCode) { result, error in
                if let error = error {
                    print("커서 위치 설정 실패: \(error)")
                }
            }
        }
    }
}

// MARK: - 에러 정의
enum KakaoAuthError: LocalizedError {
    case unauthorizedURL
    case invalidRedirectURL
    case authFailed(String)
    case noAuthCode
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedURL:
            return "허용되지 않은 URL로의 이동이 차단되었습니다."
        case .invalidRedirectURL:
            return "잘못된 리다이렉트 URL입니다."
        case .authFailed(let error):
            return "카카오 로그인 실패: \(error)"
        case .noAuthCode:
            return "인가코드를 받지 못했습니다."
        }
    }
}

