//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation
import CommonCrypto
//
//public protocol EncryptionMessageProtocol {
//    var data: Data { get }
//    var encoding: String.Encoding { get }
//}
//
//public struct DecryptedMessage: EncryptionMessageProtocol {
//
//    public let data: Data
//    public let encoding: String.Encoding
//
//    public init(decryptedString: String, encoding: String.Encoding = .utf8) throws {
//        guard let data = decryptedString.data(using: encoding) else { throw EncryptionError.stringToDataConversionFailed }
//        self.init(decryptedData: data, encoding: encoding)
//    }
//
//    public init(decryptedData data: Data, encoding: String.Encoding = .utf8) {
//        self.encoding = encoding
//        self.data = data
//    }
//
////    public func encrypted(using encryption: Encryption) throws -> EncryptionMessage {
////        let data: Data = try encrypt(using: encryption)
////        return EncryptionMessage(data: data, isEncrypted: true, encoding: encoding)
////    }
//
//    public func encrypt(using encryption: Encryption) throws -> Data {
//        try encryption.encryptedData(self)
//    }
//
//    public func encrypt(using encryption: Encryption) throws -> String {
//        let data: Data = try encrypt(using: encryption)
//        guard let string = String(data: data, encoding: encoding) else { throw EncryptionError.dataToStringConversionFailed }
//        return string
//    }
//
//}

public struct EncryptionMessage {
    
    public   let isEncrypted: Bool
    internal let data:        Data
    internal let encoding:    String.Encoding

    // Initialization
    
    /// param decryptedString: Clear text, before encryption
    public init(decryptedString: String, encoding: String.Encoding = .utf8) throws {
        guard let data = decryptedString.data(using: encoding) else { throw EncryptionError.stringToDataConversionFailed }
        self.init(data: data, isEncrypted: false, encoding: encoding)
    }

    public init(decryptedData data: Data, encoding: String.Encoding = .utf8) throws {
        self.init(data: data, isEncrypted: false, encoding: encoding)
    }

    /// param encryptedString: Base64 encoded string after encryption was applied/
    public init(encryptedString: String, encoding: String.Encoding = .utf8) throws {
        guard let data = Data(base64Encoded: encryptedString) else { throw EncryptionError.dataToStringConversionFailed }
        self.init(data: data, isEncrypted: true, encoding: encoding)
    }
    
    public init(encryptedData data: Data, encoding: String.Encoding = .utf8) throws {
        self.init(data: data, isEncrypted: true, encoding: encoding)
    }
    
    private init(data: Data, isEncrypted: Bool, encoding: String.Encoding) {
        self.encoding    = encoding
        self.data        = data
        self.isEncrypted = isEncrypted
    }

    // Encryption/decryption

    public func encrypted(using encryption: Encryption) throws -> EncryptionMessage {
        guard isEncrypted == false else { throw EncryptionError.messageIsAlreadyEncrypted }
        let data: Data = try encrypt(using: encryption)
        return EncryptionMessage(data: data, isEncrypted: true, encoding: encoding)
    }

    public func decrypted(using decryption: Decryption) throws -> EncryptionMessage {
        guard isEncrypted else { throw EncryptionError.messageIsNotEncrypted }
        let data: Data = try decrypt(using: decryption)
        return EncryptionMessage(data: data, isEncrypted: false, encoding: encoding)
    }
    
    // Helper methods for encryption/decryption
        
    public func encrypt(using encryption: Encryption) throws -> Data {
        try encryption.encryptedData(self)
    }
    
    public func encrypt(using encryption: Encryption) throws -> String {
        let data: Data = try encrypt(using: encryption)
        guard let string = String(data: data, encoding: encoding) else { throw EncryptionError.dataToStringConversionFailed }
        return string
    }

    public func decrypt(using decryption: Decryption) throws -> Data {
        try decryption.decryptedData(self)
    }

    public func decrypt(using decryption: Decryption) throws -> String {
        let data: Data = try decrypt(using: decryption)
        guard let string = String(data: data, encoding: encoding) else { throw EncryptionError.dataToStringConversionFailed }
        return string
    }

    /// Returns either decrypted message or encrypted message in form of Base64, depending on isEncrypted flag.
    public func string() throws -> String {
        if isEncrypted { return data.base64EncodedString() }
        else {
            guard let string = String(data: data, encoding: encoding) else { throw EncryptionError.dataToStringConversionFailed }
            return string
        }
    }

}
