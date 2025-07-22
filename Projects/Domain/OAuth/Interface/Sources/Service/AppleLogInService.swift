//
//  AppleLogInService.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation


public final class AppleLogInService: NSObject {
    public var identityContinuation: AsyncStream<Result<String, Error>>.Continuation?
    
    public override init() {
        super.init()
    }
}
