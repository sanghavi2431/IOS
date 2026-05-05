//
//  SOEncrypter.swift
//  YesFlix
//
//  Created by Ashish.Khobragade on 31/10/18.
//  Copyright © 2018 Ashish.Khobragade. All rights reserved.
//

import UIKit
import ObjectMapper
import CommonCrypto
import Security


class SOEncrypter: NSObject {
    
    static var shared: SOEncrypter = {
        
        let sharedObject = SOEncrypter()
        
        return sharedObject
    }()

 
    override init() {
        
    }
   
    func bytesToPublicKey(certData: NSData) -> SecKey? {
        guard let certRef = SecCertificateCreateWithData(nil, certData) else { return nil }
        var secTrust: SecTrust?
        let secTrustStatus = SecTrustCreateWithCertificates(certRef, nil, &secTrust)
        if secTrustStatus != errSecSuccess { return nil }
        var resultType: SecTrustResultType = SecTrustResultType(rawValue: UInt32(0))! // result will be ignored.
        let evaluateStatus = SecTrustEvaluate(secTrust!, &resultType)
        if evaluateStatus != errSecSuccess { return nil }
        let publicKeyRef = SecTrustCopyPublicKey(secTrust!)
        
        return publicKeyRef
    }
    
    func rsaEncryptData(with rsaPublicKey:String, message:String) -> String?  {
        
         let encString = RSA.encryptString(message, publicKey: rsaPublicKey)
                        
         return encString
    }
    
    func rsaEncryption(with rsaPublicKey:String, message:String)  {

        let file = "file.cer" //this is the file. we will write to and read from it
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try rsaPublicKey.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
            
            //reading
            do {
//                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
//                Logger.shared.showLog(text2)
                
                /////////////////////
                var publicKey1: SecKey?
                var privateKey1: SecKey?
                
                
                let publicKeyAttribute: [NSObject : NSObject] = [kSecAttrIsPermanent: true as NSObject, kSecAttrApplicationTag: "in.publicam.jetengage.yesflix.public".data(using: String.Encoding.utf8)! as NSObject]
                
                let privateKeyAtrribute: [NSObject: NSObject] = [kSecAttrIsPermanent: true as NSObject, kSecAttrApplicationTag: "in.publicam.jetengage.yesflix.private".data(using: String.Encoding.utf8)! as NSObject]
                
                let parameters:[NSObject:Any] = [
                    kSecAttrKeyType: kSecAttrKeyTypeRSA,
                    kSecAttrKeySizeInBits: NSNumber(value: 2048),
                    kSecReturnData: true,
                    kSecPublicKeyAttrs: publicKeyAttribute ,
                    kSecPrivateKeyAttrs: privateKeyAtrribute
                ]
                
                let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil

                
                var result = SecKeyGeneratePair(parameters as CFDictionary, &publicKey1, &privateKey1)

                 let publicKey = SecKeyCopyExternalRepresentation(publicKey1!, error)
                
//                Logger.shared.showLog("publicKey>>>>>>>>>>> \(publicKey)")
                
//                var publicKeyPtr, privateKeyPtr: SecKey?
//
//                let pubKeyData = rsaPublicKey.data(using: String.Encoding.unicode)
//                var error2: Unmanaged<CFError>?
//                let secKey = SecKeyCreateWithData(pubKeyData! as CFData,parameters as CFDictionary, &error2)
//
//
//                let publicKey = publicKeyPtr!
//
                let blockSize = SecKeyGetBlockSize(publicKey1!)

                let plainTextData = [UInt8](message.utf8)
                let plainTextDataLength = UInt(message.count)

                var encryptedData = [UInt8](repeating: 0, count: 2048)
                var encryptedDataLength = blockSize

                result = SecKeyEncrypt(publicKey1!, SecPadding.OAEP,
                                       plainTextData, Int(plainTextDataLength), &encryptedData, &encryptedDataLength)
                
                let endcrypted = Data(bytes: &encryptedData, count: encryptedDataLength)
                
                Logger.shared.showLog("base64v>>>>>>>>>>> \(endcrypted.base64EncodedString())")
                
                let data:Data = rsaPublicKey.data(using: .utf8)!
                
//                var publickeysi = SecKeyCreateWithData(text2.data(using: .utf8)! as CFData, parameters as CFDictionary, nil)

//                SecKeyGeneratePair(parameters as CFDictionary, &publickeysi, &privateKey)
                
                //Encrypt a string with the public key
//                let blockSize = SecKeyGetBlockSize(publickeysi!)
                var messageEncrypted = [UInt8](repeating: 0, count: blockSize)
                
                var messageEncryptedSize = blockSize
                
                var status: OSStatus!
                let  cipherText:Data  = SecKeyCreateEncryptedData(publicKey1!, SecKeyAlgorithm.rsaEncryptionOAEPSHA1, message.data(using: .utf8)! as CFData, nil)! as Data
                
                Logger.shared.showLog("Ciper base64 => \(cipherText.base64EncodedString())")
                
                
                status = SecKeyEncrypt(publicKey1!, SecPadding.OAEP, message, message.count, &messageEncrypted, &messageEncryptedSize)
                
                let cipherBufferSize = SecKeyGetBlockSize(publicKey1!)
                var cipherBufferPointer = [UInt8](repeating: 0, count: Int(cipherBufferSize))
                var cipherBufferSizeResult = Int(cipherBufferSize)
                let dataPointer = message.data(using: .utf8)!.withUnsafeBytes {
                    [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
                }
                
                _ = SecKeyEncrypt(
                    publicKey1!,
                    SecPadding.OAEP,                // `SecPadding.OAEP` works with RSA/ECB/OAEPWithSHA1AndMGF1Padding on the Java side
                    dataPointer,
                    message.data(using: .utf8)!.count,
                    &cipherBufferPointer,
                    &cipherBufferSizeResult
                )
                
                if status != noErr {
                    Logger.shared.showLog("Encryption Error!")
                    return
                }
                
                let endcryptedData = Data(bytes: &messageEncrypted, count: messageEncryptedSize)
                
                let endcryptedData2 = Data(bytes: &cipherBufferPointer, count: cipherBufferSize)
                
                //        let endcryptedDataBase64 = endcryptedData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
                
                let endcryptedDataBase64 = endcryptedData.base64EncodedString()
                let endcryptedDataBase642 = endcryptedData2.base64EncodedString()
                
                Logger.shared.showLog("RSA of Secret base64 => \(endcryptedDataBase64)")
                
                Logger.shared.showLog("RSA of Secret base64 2=> \(endcryptedDataBase642)")
                
                
                //        User this to check if encryption is correct
                //        rsaDecryption(blockSize, messageEncryptedSize, &status, privateKey, &messageEncrypted)
                
                let error2:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
                
                let plainData = message.data(using: .utf8)
                
                if let encryptedMessageData:Data = SecKeyCreateEncryptedData(publicKey1!, .rsaEncryptionOAEPSHA1, plainData! as CFData,error2) as Data?{
                    
                    Logger.shared.showLog("We have an encrypted message")
                    
                    let encryptedMessageDataBase64 = encryptedMessageData.base64EncodedString()
                    
                    Logger.shared.showLog("RSA of Secret base64 2 => \(encryptedMessageDataBase64)")
                    
                    let encryptedMessageSigned = encryptedMessageData.map { Int8(bitPattern: $0) }
                    
                    Logger.shared.showLog(encryptedMessageSigned)
                    
                    let encryptedMessageSignedData = Data(bytes:encryptedMessageSigned, count: encryptedMessageSigned.count)
                    
                    let encryptedMessageSignedDataBase64 = encryptedMessageSignedData.base64EncodedString(options: [])
                    
                    Logger.shared.showLog("RSA of Secret base64 3 => \(encryptedMessageSignedDataBase64)")
        
                }
                else{
                    Logger.shared.showLog("Error encrypting")
                }
                
            }
            catch {/* error handling here */
                Logger.shared.showLog(error.localizedDescription)
            }
        }
    }
   
    
    func rsaDecryption(_ blockSize: Int, _ messageEncryptedSize: Int, _ status: inout Int32?, _ privateKey: SecKey?, _ messageEncrypted: inout [UInt8]) {
        //Decrypt the entrypted string with the private key
        var messageDecrypted = [UInt8](repeating: 0, count: blockSize)
        var messageDecryptedSize = messageEncryptedSize
        
        status = SecKeyDecrypt(privateKey!, SecPadding.OAEP, &messageEncrypted, messageDecryptedSize, &messageDecrypted, &messageDecryptedSize)
        
        if status != noErr {
//            Logger.shared.showLog("Decryption Error!")
            return
        }
        
//        Logger.shared.showLog(NSString(bytes: &messageDecrypted, length: messageDecryptedSize, encoding: String.Encoding.utf8.rawValue)!)
    }
    
    
    func randomString(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    func getRSAPublicKey(completion: @escaping (_ rsaResponseModel:RSAResponseModel?) -> ()) {
        
        var request = URLRequest(url: URL(string: API.authToken.url)!)
        
        request.httpMethod = "POST"
        
        let bundleId = Bundle.getBundleId()
        
        request.setValue(bundleId, forHTTPHeaderField:"PACKAGE-NAME")
        request.setValue(APIConstant.contentTypeValue, forHTTPHeaderField: APIConstant.contentTypeKey)
        
        #if os(tvOS)
        request.setValue("308202e4308201cc020101300d06092a864886f70d010105050030373116301406035504030c0d416e64726f69642044656275673110300e060355040a0c07416e64726f6964310b30090603550406130255533020170d3230303331383131343433325a180f32303530303331313131343433325a30373116301406035504030c0d416e64726f69642044656275673110300e060355040a0c07416e64726f6964310b300906035504061302555330820122300d06092a864886f70d01010105000382010f003082010a0282010100884410f0677af1e6a5fb9e476356aa74f26adf6ebaa6850b4a43c64de766401aef72e24c30e8eefe631fecaa3fd089c10a8c85f6cc187b03ed4779f3d83a4c33ceb8b38e8b926c803ebbd853b85001a21b28be5937f8d3ed974fc63d3f4ca7fe4da7fc79b049b3e5a4ac4ad8ebe7465361e3117065dbb416a4c09e4c4caf0f1447bbe2c7b4606b479e50bee06f32043d1e6ec673f38bda9e1cd09ca75fa6042f3cd77ad0514fcf5fdffb327bf3eec4dca7d72b663c2dd4f081926be923b8b03a75264ef91b0a0e57faf17f70020a44d9853a97c6a7181835a2d8ef93630aea6a44a25543799880682aa4c9f654bd1ef4cac37dd1947af4b67ef1f616bfc390b70203010001300d06092a864886f70d0101050500038201010022920d220add85a8ecc5ec8a457dffb65777518e702eee07a7676734dfda6759e6be99dee7188625704cc8658e37c4acbcfb1c4a0da917cfcd49dbec334932cd94456233e312d79c59df166a3663f4ed10de826880657112b3c4a84e0dfdd1117595055c37ce2042ef8a0d683f49c06137c21597a13fe3661a794f651b9c97d2b5047a91d4cd6885f1bdf7332d39ad2602f330cd59b80ee59a37d6ef9c979de41a9f6b0cc22c351889f25a1a7dbfc449db6eba0cad85f8838f3f83d90404e3237e7acd8bacbf8788afe5f5d090a246f2e908e78ae79e472d7cccc83029d665cf74a3e0998ff99945a5644d85e25f12a9e6b9676d94e73ca3c74ef6177bfb2a31", forHTTPHeaderField: "APP-SIGNATURE")
        
        #else
        request.setValue("308202e4308201cc020101300d06092a864886f70d010105050030373116301406035504030c0d416e64726f69642044656275673110300e060355040a0c07416e64726f6964310b30090603550406130255533020170d3230303331383131343433325a180f32303530303331313131343433325a30373116301406035504030c0d416e64726f69642044656275673110300e060355040a0c07416e64726f6964310b300906035504061302555330820122300d06092a864886f70d01010105000382010f003082010a0282010100884410f0677af1e6a5fb9e476356aa74f26adf6ebaa6850b4a43c64de766401aef72e24c30e8eefe631fecaa3fd089c10a8c85f6cc187b03ed4779f3d83a4c33ceb8b38e8b926c803ebbd853b85001a21b28be5937f8d3ed974fc63d3f4ca7fe4da7fc79b049b3e5a4ac4ad8ebe7465361e3117065dbb416a4c09e4c4caf0f1447bbe2c7b4606b479e50bee06f32043d1e6ec673f38bda9e1cd09ca75fa6042f3cd77ad0514fcf5fdffb327bf3eec4dca7d72b663c2dd4f081926be923b8b03a75264ef91b0a0e57faf17f70020a44d9853a97c6a7181835a2d8ef93630aea6a44a25543799880682aa4c9f654bd1ef4cac37dd1947af4b67ef1f616bfc390b70203010001300d06092a864886f70d0101050500038201010022920d220add85a8ecc5ec8a457dffb65777518e702eee07a7676734dfda6759e6be99dee7188625704cc8658e37c4acbcfb1c4a0da917cfcd49dbec334932cd94456233e312d79c59df166a3663f4ed10de826880657112b3c4a84e0dfdd1117595055c37ce2042ef8a0d683f49c06137c21597a13fe3661a794f651b9c97d2b5047a91d4cd6885f1bdf7332d39ad2602f330cd59b80ee59a37d6ef9c979de41a9f6b0cc22c351889f25a1a7dbfc449db6eba0cad85f8838f3f83d90404e3237e7acd8bacbf8788afe5f5d090a246f2e908e78ae79e472d7cccc83029d665cf74a3e0998ff99945a5644d85e25f12a9e6b9676d94e73ca3c74ef6177bfb2a31", forHTTPHeaderField: "APP-SIGNATURE")
        
        #endif
        
        do {
            let locale = LocaleModel()
            
            if let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
                locale.version = bundleVersion
            }
            
            locale.language = "en"
            locale.country = "IN"
            
            let params = ["locale":locale.toJSON()]
            
            let jsonData = try JSONSerialization.data(withJSONObject:params, options:[])
            
            request.httpBody = jsonData
            
            Device().getDeviceIdentifierForVendor { (identifier) in
                
                request.setValue(identifier, forHTTPHeaderField:"DEVICE-ID")
                                
                URLSession(configuration: .default).dataTask(with: request as URLRequest,completionHandler:
                    
                    {(data, response, error) -> Void in
                        
                        if error == nil {
                            if let dataStr = String(bytes: data!, encoding: String.Encoding.utf8){
                                
                                if let rsaResponseModel = Mapper<RSAResponseModel>().map(JSONString: dataStr){
                                   
                                    Logger.shared.showLog(rsaResponseModel.toJSON())
                                    completion(rsaResponseModel)
                                }
                            }
                        }
                        else{
                            URLSession(configuration: .default).dataTask(with: request as URLRequest,completionHandler:
                                
                                {(data, response, error) -> Void in
                                    
                                    if error == nil {
                                        if let dataStr = String(bytes: data!, encoding: String.Encoding.utf8){
                                            
                                            if let rsaResponseModel = Mapper<RSAResponseModel>().map(JSONString: dataStr){
                                                // Logger.shared.showLog(rsaResponseModel.toJSON())
                                                completion(rsaResponseModel)
                                            }
                                        }
                                    }
                                    else{
                                        //Logger.shared.showLog(error?.localizedDescription ?? "")
                                        completion(nil)
                                    }
                                    
                            }).resume()
                        }
                        
                }).resume()
            }
            
        } catch (let error) {
            
            //Logger.shared.showLog(error.localizedDescription)
        }
    }
 
    
    open func encrypt(data: Data, with key: SecKey) -> Data {
        
        
        let cipherBufferSize = SecKeyGetBlockSize(key)
        var cipherBufferPointer = [UInt8](repeating: 0, count: Int(cipherBufferSize))
        var cipherBufferSizeResult = Int(cipherBufferSize)
        let dataPointer = data.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
        }
        
        let status = SecKeyEncrypt(
            key,
            SecPadding.OAEP,                // `SecPadding.OAEP` works with RSA/ECB/OAEPWithSHA1AndMGF1Padding on the Java side
            dataPointer,
            data.count,
            &cipherBufferPointer,
            &cipherBufferSizeResult
        )
        
        if errSecSuccess != status {
//         Logger.shared.showLog("eroorrrrrrrrrrr")
        
        }
        
        return Data(bytes: cipherBufferPointer, count: cipherBufferSizeResult)
    }
    
}

extension String {
    
    func hmac(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        
        
        let data = Data(digest) //Data(bytes: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}



