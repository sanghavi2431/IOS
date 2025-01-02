//
//  SOEncryptionUtility.swift
//  PublicamPlus
//
//  Created by Ashish.Khobragade on 05/07/18.
//  Copyright © 2018 Ashish.Khobragade. All rights reserved.
//

import UIKit
import CommonCrypto

enum AESError: Error {
    case KeyError((String, Int))
    case IVError((String, Int))
    case CryptorError((String, Int))
}

class SOEncryptionUtility: NSObject {
   
    static var shared: SOEncryptionUtility = {
        
        let soObject = SOEncryptionUtility()
        
        return soObject
    }()
    
    func getSOEncryptedDataString(dataToEncode stringData:String,completion: @escaping (_ cryptDataString:String?,_ randomSecret:String?) -> ()) {
        
        let encryptionKey = SOEncrypter.shared.randomString(length: 32)
        
        if let inputStringData = stringData.data(using: .utf8,allowLossyConversion: false),let encryptionKeyData = encryptionKey.data(using: .utf8,allowLossyConversion: false){
            
            encrypt(data: inputStringData, keyData: encryptionKeyData) { (cryptDataString) in
                            
                
                completion (cryptDataString,encryptionKey)
            }
        }
    }

    func encrypt(data:Data, keyData:Data,completion: @escaping (_ encryptedHex:String?) -> ()){
        
        var ivData = Data(count:kCCBlockSizeAES128)
        
        let status = ivData.withUnsafeMutableBytes {ivBytes in
            SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
        }
        
        if (status != 0) {
           print("IV generation failed", Int(status))
        }
        
        let cryptData    = NSMutableData(length: Int(data.count) + kCCBlockSizeAES128)!
        let keyLength              = size_t(kCCKeySizeAES256)
        let operation: CCOperation = CCOperation(UInt32(kCCEncrypt))
        let algoritm:  CCAlgorithm = CCAlgorithm(UInt32(kCCAlgorithmAES128))
        let options:   CCOptions   = CCOptions(UInt32(kCCOptionPKCS7Padding))
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  options,
                                  keyData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in return bytes},
                                  keyLength,
                                  ivData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in return bytes},
                                  data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in return bytes},
                                  data.count,
                                  cryptData.mutableBytes, cryptData.length,
                                  &numBytesEncrypted)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            
            cryptData.length = Int(numBytesEncrypted)
            
              let ivHex = ivData.hexEncodedString()
              let cryptHex = (cryptData as Data).hexEncodedString()
            
              completion(ivHex + cryptHex )
        }
    }
    
    // The iv is prefixed to the encrypted data
    private func encryptDataFor(data:Data, keyData:Data,completion: @escaping (_ encryptedHex:String?) -> ()) throws {
       
        let encrypted :String
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES256]
        if (validKeyLengths.contains(keyLength) == false) {
            throw AESError.KeyError(("Invalid key length", keyLength))
        }
        
        let ivSize = kCCBlockSizeAES128;
        let cryptLength = size_t(ivSize + data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:kCCBlockSizeAES128)
        
        let status = cryptData.withUnsafeMutableBytes {ivBytes in
            SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
        }
        
        if (status != 0) {
            throw AESError.IVError(("IV generation failed", Int(status)))
        }
        
        let ivHexData = cryptData
        
        let ivHex = ivHexData.hexEncodedString()
        
        var numBytesEncrypted :size_t = 0
        let options   = CCOptions(kCCOptionPKCS7Padding)
        var cryptedBytes:Data = Data()
        
        let cryptStatus =  data.withUnsafeBytes {dataBytes in
            cryptData.withUnsafeMutableBytes {cryptBytes in
               
                keyData.withUnsafeBytes {keyBytes in
                
                    CCCrypt(CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyBytes,
                            keyLength,
                            cryptBytes,
                            dataBytes,
                            data.count,
                            &cryptedBytes,
                            cryptLength,
                            &numBytesEncrypted)
                }
            }
        }
        
        /*
         
         (
         CCOperation op,         /* kCCEncrypt, etc. */
         CCAlgorithm alg,        /* kCCAlgorithmAES128, etc. */
         CCOptions options,      /* kCCOptionPKCS7Padding, etc. */
         const void *key,
         size_t keyLength,
         const void *iv,         /* optional initialization vector */
         const void *dataIn,     /* optional per op and alg */
         size_t dataInLength,
         void *dataOut,          /* data RETURNED here */
         size_t dataOutAvailable,
         size_t *dataOutMoved)
         */
        if UInt32(cryptStatus) != UInt32(kCCSuccess) {
            throw AESError.CryptorError(("Encryption failed", Int(cryptStatus)))
        }
        
        
        let hexEncodedString = cryptedBytes.hexEncodedString()
      
        encrypted = ivHex + hexEncodedString
        
        completion(encrypted)
    }
    
    
    // The iv is prefixed to the encrypted data
    private func getDecryptedData(stringData:String, keyData:Data) throws -> String {
        
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES256]
        
        if (validKeyLengths.contains(keyLength) == false) {
            throw AESError.KeyError(("Invalid key length", keyLength))
        }
        
        let saltHex = stringData.substring(to:stringData.index(stringData.startIndex, offsetBy: 32))
        var saltData = saltHex.data(using: .utf8)!
       
        
        let cipher = stringData.dropFirst(32)
        let base64DecodedString = String(data: cipher.data(using: .utf8)!, encoding: .utf8)!
        var data = base64DecodedString.data(using: .utf8)!
        
        let encrypt_length = Swift.max(data.count * 2, 16)
        var encrypt_bytes = [UInt8](repeating: 0,
                                    count: encrypt_length)
        
        var numBytesDecrypted  = size_t (encrypt_length)
        let options = CCOptions(kCCOptionPKCS7Padding)
         let input_bytes = data.arrayOfBytes()
        
        let cryptStatus = saltData.withUnsafeMutableBytes {cryptBytes in

            keyData.withUnsafeBytes {keyBytes in
                    CCCrypt(CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            options,
                            keyBytes, keyLength,
                            cryptBytes,
                            input_bytes, input_bytes.count,
                            &encrypt_bytes,
                            encrypt_length,
                            &numBytesDecrypted)
                }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            //            data.count = numBytesDecrypted
            
            let  decodedStr = String(data: data, encoding: .utf8)!
            
            print(decodedStr)
            return decodedStr
        }
        else {
            throw AESError.CryptorError(("Decryption failed", Int(cryptStatus)))
        }
        //        let base64 = cryptData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        //        let decoded = base64.data(using: .utf8)!
        
    }
    

}

extension Data {
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
    
    /// Array of UInt8
    public func arrayOfBytes() -> [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
}
extension String {
    /// Array of UInt8
    public var arrayOfBytes:[UInt8] {
        let data = self.data(using: String.Encoding.utf8)!
        return data.arrayOfBytes()
    }
    public var bytes:UnsafeRawPointer{
        let data = self.data(using: String.Encoding.utf8)!
        return (data as NSData).bytes
    }

}
