//
//  SayItWithWolooDetailVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 05/02/25.
//

import Foundation
import UIKit
import Alamofire
import STPopup


extension  SayItWithWolooDetailVC: UITableViewDelegate, UITableViewDataSource, SayItWolooDetailBtnCellDelegate, WolooAlertPopUpViewDelegate{
    
    
    //MARK: - WolooAlertPopUpViewDelegate
    func closePopUp() {
        if self.delegate != nil{
            self.delegate?.didMessageSent()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - SayItWolooDetailBtnCellDelegate
    func didClickEditBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didClickSendBtn() {
        print("calling the send msg api")
        Global.showIndicator()
        self.addMessageAPI(qrId: "WOLOO", name: UserDefaultsManager.fetchUserData()?.profile?.name ?? "Guest", number: String(UserDefaultsManager.fetchUserData()?.profile?.mobile ?? 0), recName: self.objAddMessageModel.RecName ?? "", recNumber: self.objAddMessageModel.RecNumber ?? "", msg: self.objAddMessageModel.Msg ?? "", occasion: "240000005", attachmentURL: self.objAddMessageModel.AttachmentURL ?? "") { result in
            switch result {
                case .success(let wrapper):
                    print("Message saved: \(wrapper)")
                self.qrSendAPI(qrId: wrapper.QrId ?? "") { result in
                    print("Message sent: \(wrapper)")
                }
                case .failure(let error):
                Global.hideIndicator()
                    print("Error: \(error.localizedDescription)")
                self.showToast(message: "Some thing went wrong..!!")
                }
        }
    }
    
 
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{// bg img
            var cell: ImageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "ImageHeaderCell") as! ImageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ImageHeaderCell", owner: self, options: nil)?.last as? ImageHeaderCell)
            }
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1{// gift img
            var cell: SayItWolooImgCell? = tableView.dequeueReusableCell(withIdentifier: "SayItWolooImgCell") as! SayItWolooImgCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("SayItWolooImgCell", owner: self, options: nil)?.last as? SayItWolooImgCell)
            }
            cell?.configureSayItWolooImgCell(selectedImg: imgSelected)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 2{//description
            var cell: txtViewSayItWolooCell? = tableView.dequeueReusableCell(withIdentifier: "txtViewSayItWolooCell") as! txtViewSayItWolooCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("txtViewSayItWolooCell", owner: self, options: nil)?.last as? txtViewSayItWolooCell)
            }
           
            cell?.configureTxtViewSayItWolooCell(obj: self.objAddMessageModel)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 3{//description
            var cell: SayItWolooDetailBtnCell? = tableView.dequeueReusableCell(withIdentifier: "SayItWolooDetailBtnCell") as! SayItWolooDetailBtnCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("SayItWolooDetailBtnCell", owner: self, options: nil)?.last as? SayItWolooDetailBtnCell)
            }
            cell?.delegate = self
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
    }
    
    
    //API call
    

    func addMessageAPI(
        qrId: String,
        name: String,
        number: String,
        recName: String,
        recNumber: String,
        msg: String,
        occasion: String,
        attachmentURL: String,
        completion: @escaping (Result<AddMessageWrapper, Error>) -> Void
    ) {
        let url = "https://api-digitalmessage.coitor.com/Message/add_message"

        AF.upload(
            multipartFormData: { formData in
                formData.append(Data(qrId.utf8),       withName: "QrId")
                formData.append(Data(name.utf8),       withName: "Name")
                formData.append(Data(number.utf8),     withName: "Number")
                formData.append(Data(recName.utf8),    withName: "RecName")
                formData.append(Data(recNumber.utf8),  withName: "RecNumber")
                formData.append(Data(msg.utf8),        withName: "Msg")
                formData.append(Data(occasion.utf8),   withName: "Occasion")
                formData.append(Data(attachmentURL.utf8), withName: "AttachmentURL")
            },
            to: url,
            method: .post
        )
        .validate()
        .responseDecodable(of: AddMessageWrapper.self) { response in
            switch response.result {
            case .success(let wrapper):
                print("✅ AddMessage success:", wrapper)
                completion(.success(wrapper))
            case .failure(let error):
                print("❌ AddMessage failed:", error)
                completion(.failure(error))
            }
        }
    }


    func qrSendAPI(qrId: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        let url = "https://api-digitalmessage.coitor.com/Message/QrSend"
        
        AF.upload(multipartFormData: { formData in
            formData.append(qrId.data(using: .utf8) ?? Data(), withName: "QrId")
        }, to: url, method: .post)
        .validate()
        .response { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                Global.hideIndicator()
                DispatchQueue.main.async {
                    let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                        
                    objController.isComeFrom = "SAY_IT_WITH_WOLOO"
                    objController.delegate = self
                  
                    let popup = STPopupController.init(rootViewController: objController)
                    popup.present(in: self)
                    
                }
                
            case .failure(let error):
                completion(.failure(error))
                Global.hideIndicator()
            }
        }
    }

    
}
