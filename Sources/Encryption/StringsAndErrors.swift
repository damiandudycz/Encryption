//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation
import CommonCrypto

public enum AESEncryptionError: Error {
    
    case invalidBase64String
    case stringToDataConversionFailed
    case dataToStringConversionFailed
    case messageIsNotEncrypted
    case messageIsAlreadyEncrypted
    case encryptionOrDecryptionFailed(status: CCCryptorStatus)

}

public enum RSAEncryptionError: Error {
    
    case keyCreateFailed
    case asn1ParsingFailed(error: Error)
    case invalidAsn1RootNode
    case invalidAsn1Structure
    case invalidBase64String
    case chunkDecryptFailed(status: OSStatus)
    case chunkEncryptFailed(status: OSStatus)
    case stringToDataConversionFailed
    case dataToStringConversionFailed
    case messageIsNotEncrypted
    case messageIsAlreadyEncrypted

}
