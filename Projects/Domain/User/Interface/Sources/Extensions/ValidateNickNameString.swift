//
//  ValidateNickNameString.swift
//  DomainUserInterface
//
//  Created by Greem on 8/3/25.
//

import Foundation

public extension String {
    // 모든 언어의 문자, 숫자만 허용 (공백, 특수문자 불가)
    var isValidNickName: Bool {
        if let _ = self.range(of:  "^[\\p{L}\\p{N}]{2,10}$", options: [.regularExpression]),
           self.count <= 10 {
            return true
        } else {
            return false
        }
    }
}
