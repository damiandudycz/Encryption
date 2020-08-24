//
//  File.swift
//  
//
//  Created by Home Dudycz on 23/08/2020.
//

import Foundation

// Message in Encrypted or Decrypted form.
public protocol EncryptionMessageProtocol {
    var data: Data { get }
    var encoding: String.Encoding { get }
}
