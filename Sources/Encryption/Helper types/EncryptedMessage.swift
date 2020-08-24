//
//  File.swift
//  
//
//  Created by Home Dudycz on 23/08/2020.
//

import Foundation
import CommonCrypto

public struct EncryptedMessage: EncryptionMessageProtocol {

    public let data: Data
    public let encoding: String.Encoding

    /// encryptedString: Base64 representation of encrypted data.
    public init(encryptedString: String, encoding: String.Encoding = .utf8) throws {
        guard let data = Data(base64Encoded: encryptedString) else { 
            throw EncryptionError.stringToDataConversionFailed 
        }
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
        guard let string = String(data: data, encoding: encoding) else { 
            throw EncryptionError.dataToStringConversionFailed 
        }
        return string
    }

    public var base64String: String {
        data.base64EncodedString()
    }
    
}
