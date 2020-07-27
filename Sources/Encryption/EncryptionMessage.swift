//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation
import CommonCrypto

public struct EncryptionMessage {
    
    public   let isEncrypted: Bool
    internal let data: Data
    internal let encoding: String.Encoding

    // Initialization
    
    /// param decryptedString: Clear text, before encryption
    public init(decryptedString: String, encoding: String.Encoding = .utf8) throws {
        guard let data = decryptedString.data(using: encoding) else { throw AESEncryptionError.stringToDataConversionFailed }
        self.init(data: data, isEncrypted: false, encoding: encoding)
    }

    /// param encryptedString: Base64 encoded string after encryption was applied/
    public init(encryptedString: String, encoding: String.Encoding = .utf8) throws {
        guard let data = Data(base64Encoded: encryptedString) else { throw AESEncryptionError.invalidBase64String }
        self.init(data: data, isEncrypted: true, encoding: encoding)
    }
    
    public init(encryptedData data: Data, encoding: String.Encoding = .utf8) throws {
        self.init(data: data, isEncrypted: true, encoding: encoding)
    }

    public init(decryptedData data: Data, encoding: String.Encoding = .utf8) throws {
        self.init(data: data, isEncrypted: false, encoding: encoding)
    }
        
    internal init(data: Data, isEncrypted: Bool, encoding: String.Encoding) {
        self.encoding = encoding
        self.data = data
        self.isEncrypted = isEncrypted
    }

    // Encryption/decryption

    public func encrypted(using encryption: Encryption) throws -> EncryptionMessage {
        return try encryption.encryptedMessage(self)
    }

    public func encrypt(using encryption: Encryption) throws -> String {
        return try encryption.encryptMessage(self)
    }

    public func encrypt(using encryption: Encryption) throws -> Data {
        return try encryption.encryptMessage(self)
    }
    
    public func decrypted(using decryption: Decryption) throws -> EncryptionMessage {
        return try decryption.decryptedMessage(self)
    }

    public func decrypt(using decryption: Decryption) throws -> String {
        return try decryption.decryptMessage(self)
    }

    public func decrypt(using decryption: Decryption) throws -> Data {
        return try decryption.decryptMessage(self)
    }

    /// Returns either decrypted message or encrypted message in form of Base64, depending on isEncrypted flag.
    public func string() throws -> String {
        if isEncrypted { return data.base64EncodedString() }
        else {
            guard let string = String(data: data, encoding: encoding) else { throw AESEncryptionError.dataToStringConversionFailed }
            return string
        }
    }

}
