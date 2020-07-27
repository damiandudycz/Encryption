//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation

public protocol Decryption {
    
    func decryptedData(_ message: EncryptionMessage) throws -> Data

}
