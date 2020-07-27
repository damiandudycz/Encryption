//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation

public protocol Decryption {
    
    func decryptedMessage(_ message: EncryptionMessage) throws -> EncryptionMessage

}

public extension Decryption {

    func decryptMessage(_ message: EncryptionMessage) throws -> Data {
        let decryptedMessage: EncryptionMessage = try self.decryptedMessage(message)
        return decryptedMessage.data
    }
    
    func decryptMessage(_ message: EncryptionMessage) throws -> String {
        let decryptedMessage: EncryptionMessage = try self.decryptedMessage(message)
        return try decryptedMessage.string()
    }

}
