//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation
import CommonCrypto

public struct AES: Encryption, Decryption {
    
    public init(key: AESKey, options: CCOptions) {
        self.key = key
        self.options = options
    }
    
    let key: AESKey
    let options: CCOptions
    
    public func encryptedMessage(_ message: EncryptionMessage) throws -> EncryptionMessage {
        guard message.isEncrypted == false else { throw AESEncryptionError.messageIsAlreadyEncrypted }
        return try convertAESBytes(message: message, key: key, options: options, action: .encrypt)
    }
        
    public func decryptedMessage(_ message: EncryptionMessage) throws -> EncryptionMessage {
        guard message.isEncrypted else { throw AESEncryptionError.messageIsNotEncrypted }
        return try convertAESBytes(message: message, key: key, options: options, action: .decrypt)
    }
    
    private func convertAESBytes(message: EncryptionMessage, key: AESKey, options: CCOptions, action: Action) throws -> EncryptionMessage {
        let cryptLength = size_t(message.data.count + key.size)
        let keyLength   = size_t(key.size)
        var numBytesConverted: size_t = 0
        var convertedBytes = Data(count: cryptLength)
        
        let cryptStatus = convertedBytes.withUnsafeMutableBytes { cryptBytes in
            message.data.withUnsafeBytes { dataBytes in
                key.initialVector.withUnsafeBytes { ivBytes in
                    key.secret.withUnsafeBytes { keyBytes in
                        CCCrypt(CCOperation(action: action), CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, message.data.count, cryptBytes.baseAddress, cryptLength, &numBytesConverted)
                    }
                }
            }
        }
        
        switch Int(cryptStatus) {
        case kCCSuccess: convertedBytes.removeSubrange(numBytesConverted..<convertedBytes.count)
        default: throw AESEncryptionError.encryptionOrDecryptionFailed(status: cryptStatus)
        }
        
        return EncryptionMessage(data: convertedBytes, isEncrypted: action == .encrypt, encoding: message.encoding)
    }
    
}

private extension CCOperation {
    
    init(action: Action) {
        switch action {
        case .encrypt: self = CCOperation(kCCEncrypt)
        case .decrypt: self = CCOperation(kCCDecrypt)
        }
    }
    
}
