//
//  File.swift
//  
//
//  Created by Home Dudycz on 27/07/2020.
//

import Foundation
import CommonCrypto

public enum EncryptionError: Error {

    case dataToStringConversionFailed
    case stringToDataConversionFailed
    case messageIsNotEncrypted
    case messageIsAlreadyEncrypted
    case failedToLoadData

}

public enum AESEncryptionError: Error {
    
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

}
