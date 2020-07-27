//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation
import CommonCrypto

public struct AESKey: Codable {
    
    let size:          Int
    let secret:        Data
    let initialVector: Data
    
    public init(size: Int = kCCKeySizeAES128, secret: Data, initialVector: Data) {
        self.size          = size
        self.secret        = secret
        self.initialVector = initialVector
    }
    
    public init(size: Int = kCCAlgorithmAES128, secret: String, initialVector: String) {
        self.init(size: size, secret: secret.data(using: .utf8)!, initialVector: initialVector.data(using: .utf8)!)
    }
    
}
