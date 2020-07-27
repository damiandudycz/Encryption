//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation

public protocol Encryption {
    
    func encryptedData(_ message: DecryptedMessage) throws -> Data

}
