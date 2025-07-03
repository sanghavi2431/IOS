//
//  SayItWithWolooAPI.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import Foundation
import Alamofire

class SayItWithWolooAPI: NSObject{
    
    func fileUpload(image : UIImage, QrId: String?,
                    success: @escaping (_ objCommonWrapper: FileUploadWrapper)->Void,
                    failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(QrId ?? "", forKey: "QrId")
        
        let api = SayItWithWolooRouterAPI(params: parameters)
        
        api.POSTAction(action: .fileUpload, endValue: "") { multipartFormData in
            // Append single image
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            let dateString = dateFormatter.string(from: Date())
            
            
            let fileName = "image_\(dateString).jpeg"
            let imgData = Utility.compressImage(image: image)
            
            multipartFormData.append(imgData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
        } completion: { response in
            if SSError.isErrorReponse(operation: response.response) {
                let error = SSError.errorWithData(data: response)
                failure(SSError.getErrorMessage(error) as? Error)
            } else {
                guard let data = response.data else { return }
                if let objParsed: FileUploadWrapper? = FileUploadWrapper.decode(data) {
                    success(objParsed!)
                }
            }
        }
    }
    
    
    func addMessage(objAddMesage: AddMessageModel?, success: @escaping (_ objCommonWrapper: AddMessageWrapper)->Void,
                    failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(objAddMesage?.QrId ?? "", forKey: "QrId")
        parameters.setValue(objAddMesage?.Name ?? "", forKey: "Name")
        parameters.setValue(objAddMesage?.Number ?? "", forKey: "Number")
        parameters.setValue(objAddMesage?.RecName ?? "", forKey: "RecName")
        parameters.setValue(objAddMesage?.RecNumber ?? "", forKey: "RecNumber")
        parameters.setValue(objAddMesage?.Msg ?? "", forKey: "Msg")
        parameters.setValue(objAddMesage?.Occasion ?? "", forKey: "Occasion")
        parameters.setValue(objAddMesage?.OtherOccasion ?? "", forKey: "OtherOccasion")
        parameters.setValue(objAddMesage?.AttachmentURL ?? "", forKey: "AttachmentURL")
        
        // Validate input
        guard let objAddMessage = objAddMesage else {
            failure(NSError(domain: "Invalid Input", code: 400, userInfo: nil))
            return
        }
        
        let api = SayItWithWolooRouterAPI(params: nil) // No initial params for `multipartFormData`
        
        api.POSTAction(action: .addMessage, endValue: "") { multipartFormData in
            // Append parameters as form-data
            multipartFormData.append(objAddMessage.QrId?.data(using: .utf8) ?? Data(), withName: "QrId")
            multipartFormData.append(objAddMessage.Name?.data(using: .utf8) ?? Data(), withName: "Name")
            multipartFormData.append(objAddMessage.Number?.data(using: .utf8) ?? Data(), withName: "Number")
            multipartFormData.append(objAddMessage.RecName?.data(using: .utf8) ?? Data(), withName: "RecName")
            multipartFormData.append(objAddMessage.RecNumber?.data(using: .utf8) ?? Data(), withName: "RecNumber")
            multipartFormData.append(objAddMessage.Msg?.data(using: .utf8) ?? Data(), withName: "Msg")
            multipartFormData.append(objAddMessage.Occasion?.data(using: .utf8) ?? Data(), withName: "Occasion")
            multipartFormData.append(objAddMessage.OtherOccasion?.data(using: .utf8) ?? Data(), withName: "OtherOccasion")
            multipartFormData.append(objAddMessage.AttachmentURL?.data(using: .utf8) ?? Data(), withName: "AttachmentURL")
        } completion: { response in
            if SSError.isErrorReponse(operation: response.response) {
                let error = SSError.errorWithData(data: response)
                failure(SSError.getErrorMessage(error) as? Error)
            } else {
                guard let data = response.data else { return }
                if let objParsed: AddMessageWrapper? = AddMessageWrapper.decode(data) {
                    success(objParsed!)
                }
            }
        }
    }
}
