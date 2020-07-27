//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation

public protocol Encryption {
    
    func encryptedMessage(_ message: EncryptionMessage) throws -> EncryptionMessage

}

public extension Encryption {
    
    func encryptMessage(_ message: EncryptionMessage) throws -> Data {
        let encryptedMessage = try self.encryptedMessage(message)
        return encryptedMessage.data
    }
    
    func encryptMessage(_ message: EncryptionMessage) throws -> String {
        let encryptedMessage = try self.encryptedMessage(message)
        return try encryptedMessage.string()
    }

}
