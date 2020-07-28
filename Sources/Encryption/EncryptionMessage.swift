//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation
import CommonCrypto

public protocol EncryptionMessageProtocol {
    var data: Data { get }
    var encoding: String.Encoding { get }
}

public struct DecryptedMessage: EncryptionMessageProtocol {

    public let data: Data
    public let encoding: String.Encoding

    public init(decryptedString: String, encoding: String.Encoding = .utf8) throws {
        guard let data = decryptedString.data(using: encoding) else { throw EncryptionError.stringToDataConversionFailed }
        self.init(decryptedData: data, encoding: encoding)
    }

    public init(decryptedData data: Data, encoding: String.Encoding = .utf8) {
        self.encoding = encoding
        self.data = data
    }
    
    public init(file fileName: String, in bundle: Bundle) throws {
        guard let url = bundle.url(forResource: fileName, withExtension: nil), let data = try? Data(contentsOf: url) else {
            throw EncryptionError.failedToLoadData
        }
        self.init(decryptedData: data)
    }

    public func encrypted(using encryption: Encryption) throws -> EncryptedMessage {
        let data: Data = try encrypt(using: encryption)
        return EncryptedMessage(encryptedData: data, encoding: encoding)
    }

    public func encrypt(using encryption: Encryption) throws -> Data {
        try encryption.encryptedData(self)
    }

    public func encrypt(using encryption: Encryption) throws -> String {
        let data: Data = try encrypt(using: encryption)
        guard let string = String(data: data, encoding: encoding) else { throw EncryptionError.dataToStringConversionFailed }
        return string
    }
    
    public func string() throws -> String {
        guard let string = String(data: data, encoding: encoding) else {
            throw EncryptionError.dataToStringConversionFailed
        }
        return string
    }

}

public struct EncryptedMessage: EncryptionMessageProtocol {

    public let data: Data
    public let encoding: String.Encoding

    public init(encryptedString: String, encoding: String.Encoding = .utf8) throws {
        guard let data = encryptedString.data(using: encoding) else { throw EncryptionError.stringToDataConversionFailed }
        self.init(encryptedData: data, encoding: encoding)
    }

    public init(encryptedData data: Data, encoding: String.Encoding = .utf8) {
        self.encoding = encoding
        self.data = data
    }

    public init(file fileName: String, in bundle: Bundle) throws {
        guard let url = bundle.url(forResource: fileName, withExtension: nil), let data = try? Data(contentsOf: url) else {
            throw EncryptionError.failedToLoadData
        }
        self.init(encryptedData: data)
    }

    public func decrypted(using decryption: Decryption) throws -> DecryptedMessage {
        let data: Data = try decrypt(using: decryption)
        return DecryptedMessage(decryptedData: data, encoding: encoding)
    }

    public func decrypt(using decryption: Decryption) throws -> Data {
        try decryption.decryptedData(self)
    }

    public func decrypt(using decryption: Decryption) throws -> String {
        let data: Data = try decrypt(using: decryption)
        guard let string = String(data: data, encoding: encoding) else { throw EncryptionError.dataToStringConversionFailed }
        return string
    }

    public var base64String: String {
        data.base64EncodedString()
    }
    
}
