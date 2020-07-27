//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation

public struct RSA: Encryption, Decryption {
   
    private let encryption: RSAEncryption
    private let decryption: RSADecryption

    public init(publicKey: RSAKey, privateKey: RSAKey, padding: SecPadding) {
        self.encryption = RSAEncryption(publicKey:  publicKey,  padding: padding)
        self.decryption = RSADecryption(privateKey: privateKey, padding: padding)
    }
    
    public func encryptedMessage(_ message: EncryptionMessage) throws -> EncryptionMessage {
        try encryption.encryptedMessage(message)
    }
    
    public func decryptedMessage(_ message: EncryptionMessage) throws -> EncryptionMessage {
        try decryption.decryptedMessage(message)
    }
    
}

public struct RSAEncryption: Encryption {

    public init(publicKey key: RSAKey, padding: SecPadding) {
        self.key     = key
        self.padding = padding
    }
    
    let key:     RSAKey
    let padding: SecPadding
    
    public func encryptedMessage(_ message: EncryptionMessage) throws -> EncryptionMessage {
        guard message.isEncrypted == false else { throw AESEncryptionError.messageIsAlreadyEncrypted }
        return try convertRSADataBytes(message: message, key: key.secureKey, padding: padding, action: .encrypt)
    }
    
}

public struct RSADecryption: Decryption {

    public init(privateKey key: RSAKey, padding: SecPadding) {
        self.key     = key
        self.padding = padding
    }
    
    let key:     RSAKey
    let padding: SecPadding
    
    public func decryptedMessage(_ message: EncryptionMessage) throws -> EncryptionMessage {
        guard message.isEncrypted else { throw AESEncryptionError.messageIsNotEncrypted }
        return try convertRSADataBytes(message: message, key: key.secureKey, padding: padding, action: .decrypt)
    }
    
}

private func convertRSADataBytes(message: EncryptionMessage, key: SecKey, padding: SecPadding, action: Action) throws -> EncryptionMessage {
    let dataArray = [UInt8](message.data)
    let blockSize = SecKeyGetBlockSize(key)
    var convertedBytes = [UInt8]()
    for idx in stride(from: 0, to: dataArray.count, by: blockSize) {
        let idxEnd = min(idx + blockSize, dataArray.count)
        let chunkData = [UInt8](dataArray[idx..<idxEnd])
        
        var dataBuffer = [UInt8](repeating: 0, count: blockSize)
        var dataLength = blockSize
        
        switch action {
        case .encrypt:
            let status = SecKeyEncrypt(key, padding, chunkData, chunkData.count, &dataBuffer, &dataLength)
            guard status == noErr else { throw RSAEncryptionError.chunkEncryptFailed(status: status) }
        case .decrypt:
            let status = SecKeyDecrypt(key, padding, chunkData, idxEnd-idx, &dataBuffer, &dataLength)
            guard status == noErr else { throw RSAEncryptionError.chunkDecryptFailed(status: status) }
        }
        
        convertedBytes.append(contentsOf: dataBuffer[0..<dataLength])
    }
    let data = Data(bytes: convertedBytes, count: convertedBytes.count)
    return EncryptionMessage(data: data, isEncrypted: action == .encrypt, encoding: message.encoding)
}
