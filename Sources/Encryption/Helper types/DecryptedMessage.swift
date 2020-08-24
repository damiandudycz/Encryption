//
//  File.swift
//  
//
//  Created by Home Dudycz on 23/08/2020.
//

import Foundation
import CommonCrypto

public struct DecryptedMessage: EncryptionMessageProtocol {

    public let data: Data
    public let encoding: String.Encoding

    public init(decryptedString: String, encoding: String.Encoding = .utf8) throws {
        guard let data = decryptedString.data(using: encoding) else { 
            throw EncryptionError.stringToDataConversionFailed 
        }
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

    /// returns Base64 representation of encrypted data.
    public func encrypt(using encryption: Encryption) throws -> String {
        let data: Data = try encrypt(using: encryption)
        return data.base64EncodedString()
    }
    
    public func string() throws -> String {
        guard let string = String(data: data, encoding: encoding) else {
            throw EncryptionError.dataToStringConversionFailed
        }
        return string
    }

}
