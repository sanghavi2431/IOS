//
//  SayItWithWolooVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import Foundation
import ContactsUI
import STPopup


extension SayItWithWolooVC: UITableViewDelegate, UITableViewDataSource, txtFieldSayItWolooCellDelegate, CNContactPickerDelegate, SendBtnCellProtocol, txtViewSayItWolooCellDelegate, SayItWolooSelectPhotoCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    
    //MARK: - SayItWolooSelectPhotoCellDelegate
    func didClickedOpenImage(selectedImg: UIImage?) {
        print("Show selected img")
        let objController = PreviewDocumentPopUpVC.init(nibName: "PreviewDocumentPopUpVC", bundle: nil)
        objController.imgSelected = selectedImg
        let popup = STPopupController(rootViewController: objController)
        popup.present(in: self)
    }
    
    func didClickedDeleteImage() {
        print("show delete image alert")
    }
    
    
    
  
    
    //MARK: - SendBtnCellProtocol
    func didClickedSendBtn() {
        print("call the add message api")
        print("name: ", self.objAddMessageModel.RecName ?? "")
        print("number: ", self.objAddMessageModel.RecNumber ?? "")
        print("msg: ", self.objAddMessageModel.Msg ?? "")
        
        if let recName = self.objAddMessageModel.RecName, !recName.isEmpty,
           let recNumber = self.objAddMessageModel.RecNumber, !recNumber.isEmpty,
           let msg = self.objAddMessageModel.Msg, !msg.isEmpty {
            
            // All fields have values, proceed to the next screen
            let objController = SayItWithWolooDetailVC(nibName: "SayItWithWolooDetailVC", bundle: nil)
            objController.imgSelected = self.selectedImg
            objController.objAddMessageModel = self.objAddMessageModel
            self.navigationController?.pushViewController(objController, animated: true)

        } else {
            // One or more fields are empty, show an error message
            var errorMessage = "Please enter: "
            
            if self.objAddMessageModel.RecName?.isEmpty ?? true {
                errorMessage += "\n- Recipient Name"
            }
            if self.objAddMessageModel.RecNumber?.isEmpty ?? true {
                errorMessage += "\n- Recipient Number"
            }
            if self.objAddMessageModel.Msg?.isEmpty ?? true {
                errorMessage += "\n- Message"
            }
            
            let alert = UIAlertController(title: "Missing Information", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
   
    //MARK: - txtViewSayItWolooCellDelegate
    func didChangedDesc(objAddMessageModel: AddMessageModel?) {
        self.objAddMessageModel.Msg = objAddMessageModel?.Msg ?? ""
    }
    
    
    //MARK: - txtFieldSayItWolooCellDelegate
    func didChangedRecieverName(objAddMessageModel: AddMessageModel?) {
        print("change name: ", objAddMessageModel?.RecName ?? "")
        self.objAddMessageModel.RecName = objAddMessageModel?.RecName ?? ""
    }
    
    func didChangedPhoneNumber(objAddMessageModel: AddMessageModel?) {
        print("Type contact info")
        print("change RecNumber: ", objAddMessageModel?.RecNumber ?? "")
        self.objAddMessageModel.RecNumber = objAddMessageModel?.RecNumber ?? ""
    }
    
    func didClickSelectContactInfo() {
        let contactPicker = CNContactPickerViewController()
         contactPicker.delegate = self
         contactPicker.displayedPropertyKeys =
         [CNContactPhoneNumbersKey]
         self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        // Loop through all phone numbers of the contact
        for contact in contacts {
               // Print the given name
               print("Given Name:", contact.givenName)
            self.objAddMessageModel.RecName = contact.givenName
               // Check if there are any phone numbers
               if let firstPhoneNumber = contact.phoneNumbers.first?.value.stringValue {
                   print("Phone Number:", firstPhoneNumber)
                   self.objAddMessageModel.RecNumber = firstPhoneNumber
               } else {
                   print("No phone numbers available for this contact.")
               }
           }
        self.tableView.reloadData()
    }
    
  
    //MARK: - UITableViewDelegate and UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
        else if indexPath.row == 1{//name
            var cell: txtFieldSayItWolooCell? = tableView.dequeueReusableCell(withIdentifier: "txtFieldSayItWolooCell") as! txtFieldSayItWolooCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("txtFieldSayItWolooCell", owner: self, options: nil)?.last as? txtFieldSayItWolooCell)
            }
            cell?.delegate = self
            cell?.configureReceiverNameTxtField(obj: self.objAddMessageModel)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 2{//Phone number
            var cell: txtFieldSayItWolooCell? = tableView.dequeueReusableCell(withIdentifier: "txtFieldSayItWolooCell") as! txtFieldSayItWolooCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("txtFieldSayItWolooCell", owner: self, options: nil)?.last as? txtFieldSayItWolooCell)
            }
            cell?.delegate = self
            cell?.configureReceiversContactNumber(obj: self.objAddMessageModel)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 3{//select photo
            var cell: SayItWolooSelectPhotoCell? = tableView.dequeueReusableCell(withIdentifier: "SayItWolooSelectPhotoCell") as! SayItWolooSelectPhotoCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("SayItWolooSelectPhotoCell", owner: self, options: nil)?.last as? SayItWolooSelectPhotoCell)
            }
            cell?.delegate = self
            cell?.configureSayItWolooSelectPhotoCell(selectedImg: self.selectedImg, imgName: self.imgName)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 4{//description
            var cell: txtViewSayItWolooCell? = tableView.dequeueReusableCell(withIdentifier: "txtViewSayItWolooCell") as! txtViewSayItWolooCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("txtViewSayItWolooCell", owner: self, options: nil)?.last as? txtViewSayItWolooCell)
            }
            cell?.delegate = self
            cell?.configureTxtViewSayItWolooCell(obj: self.objAddMessageModel)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 5{// send btn
            var cell: SendBtnCell? = tableView.dequeueReusableCell(withIdentifier: "SendBtnCell") as! SendBtnCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("SendBtnCell", owner: self, options: nil)?.last as? SendBtnCell)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            print("Open image picker")
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            if let pickedImage = info[.originalImage] as? UIImage {
                self.selectedImg = pickedImage
                
                // Get the image name from the URL if available
                var imageName = "default_image_name" // Fallback if name is unavailable
                if let imageURL = info[.imageURL] as? URL {
                    imageName = imageURL.lastPathComponent
                }
                
                print("Selected Image Name: \(imageName)")
                self.imgName = imageName

                self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
                DispatchQueue.main.async {
                    print("Call the upload img API")
                }
            }
        }
    }

}
