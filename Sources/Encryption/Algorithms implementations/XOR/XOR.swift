//
//  File.swift
//  
//
//  Created by Home Dudycz on 28/07/2020.
//

import Foundation

public struct XOR: Encryption, Decryption {
    
    public init(key: String) {
        self.key = key
    }
    
    let key: String
    
    public func encryptedData(_ message: DecryptedMessage) throws -> Data {
        convertXORDataBytes(data: message.data, using: key)
    }
        
    public func decryptedData(_ message: EncryptedMessage) throws -> Data {
        convertXORDataBytes(data: message.data, using: key)
    }

    private func cipher(for key: String, length: Int) -> [UInt8] {
        let keyChars = key.utf8
        let repeats = Int((Double(length) / Double(keyChars.count)).rounded(.up))
        return Array(((0..<repeats).flatMap { _ in keyChars })[0..<length])
    }

    private func convertXORDataBytes(data: Data, using key: String) -> Data {
        let cipher = self.cipher(for: key, length: data.count)
        let encryptedArray = data.enumerated().map { (index, element) in
            element ^ cipher[index]
        }
        return Data(encryptedArray)
    }

}
