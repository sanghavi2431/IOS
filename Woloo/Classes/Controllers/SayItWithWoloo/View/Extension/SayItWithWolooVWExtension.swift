//
//  SayItWithWolooVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import Foundation
import ContactsUI
import STPopup
import Alamofire
import Contacts
import UIKit

extension SayItWithWolooVC: UITableViewDelegate, UITableViewDataSource,
    txtFieldSayItWolooCellDelegate,
    CNContactPickerDelegate,
    SendBtnCellProtocol,
    txtViewSayItWolooCellDelegate,
    SayItWolooSelectPhotoCellDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    SayItWithWolooDetailVCDelegate {

    // MARK: - SayItWithWolooDetailVCDelegate
    func didMessageSent() {
        self.objAddMessageModel = AddMessageModel()
        self.selectedImg =  UIImage()
        self.imgName = ""
        self.tableView.reloadData()
    }

    // MARK: - SayItWolooSelectPhotoCellDelegate
    func didClickedOpenImage(selectedImg: UIImage?) {
        let objController = PreviewDocumentPopUpVC(nibName: "PreviewDocumentPopUpVC", bundle: nil)
        objController.imgSelected = selectedImg
        let popup = STPopupController(rootViewController: objController)
        popup.present(in: self)
    }

    func didClickedDeleteImage() {
        print("Delete image action")
    }

    // MARK: - SendBtnCellProtocol
    func didClickedSendBtn() {
        guard
            let recName = objAddMessageModel.RecName, !recName.isEmpty,
            let recNumber = objAddMessageModel.RecNumber, !recNumber.isEmpty,
            let msg = objAddMessageModel.Msg, !msg.isEmpty else {

            var errorMessage = "Please enter "
            if objAddMessageModel.RecName?.isEmpty ?? true { errorMessage += "Recipient Name" }
            else if objAddMessageModel.RecNumber?.isEmpty ?? true { errorMessage += "Recipient Number" }
            else if (objAddMessageModel.RecNumber?.count ?? 0) < 10 { errorMessage += "Valid Contact Number" }
            else if objAddMessageModel.Msg?.isEmpty ?? true { errorMessage += "Message" }

            self.showToast(message: errorMessage)
            return
        }

        // Proceed to detail screen
        let objController = SayItWithWolooDetailVC(nibName: "SayItWithWolooDetailVC", bundle: nil)
        objController.delegate = self
        objController.imgSelected = self.selectedImg
        objController.objAddMessageModel = self.objAddMessageModel
        self.navigationController?.pushViewController(objController, animated: true)
    }

    // MARK: - txtViewSayItWolooCellDelegate
    func didChangedDesc(objAddMessageModel: AddMessageModel?) {
        self.objAddMessageModel.Msg = objAddMessageModel?.Msg ?? ""
    }

    // MARK: - txtFieldSayItWolooCellDelegate
    func didChangedRecieverName(objAddMessageModel: AddMessageModel?) {
        self.objAddMessageModel.RecName = objAddMessageModel?.RecName ?? ""
    }

    func didChangedPhoneNumber(objAddMessageModel: AddMessageModel?) {
        self.objAddMessageModel.RecNumber = objAddMessageModel?.RecNumber ?? ""
    }

    func didClickSelectContactInfo() {
        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .authorized, .limited:
            presentAppleContactPicker()
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    if granted { self.presentAppleContactPicker() }
                    else { self.showContactsPermissionAlert() }
                }
            }
        case .denied, .restricted:
            showContactsPermissionAlert()
        @unknown default:
            break
        }
    }

    // MARK: - Apple Contact Picker
    private func presentAppleContactPicker() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        self.present(picker, animated: true)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if let firstPhoneNumber = contact.phoneNumbers.first?.value.stringValue {
            objAddMessageModel.RecNumber = firstPhoneNumber
        } else { objAddMessageModel.RecNumber = "" }

        objAddMessageModel.RecName = contact.givenName
        tableView.reloadData()
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Contact picker cancelled")
    }

    private func showContactsPermissionAlert() {
        let alert = UIAlertController(
            title: "Contacts Permission Required",
            message: "Please allow Woloo to access your contacts in Settings → Privacy → Contacts.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        self.present(alert, animated: true)
    }

    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 7 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            var cell = tableView.dequeueReusableCell(withIdentifier: "ImageHeaderCell") as? ImageHeaderCell
            if cell == nil { cell = Bundle.main.loadNibNamed("ImageHeaderCell", owner: self, options: nil)?.last as? ImageHeaderCell }
            cell?.selectionStyle = .none
            return cell!

        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "txtFieldSayItWolooCell") as? txtFieldSayItWolooCell
            if cell == nil { cell = Bundle.main.loadNibNamed("txtFieldSayItWolooCell", owner: self, options: nil)?.last as? txtFieldSayItWolooCell }
            cell?.delegate = self
            cell?.configureReceiverNameTxtField(obj: objAddMessageModel)
            cell?.selectionStyle = .none
            return cell!

        case 2:
            var cell = tableView.dequeueReusableCell(withIdentifier: "txtFieldSayItWolooCell") as? txtFieldSayItWolooCell
            if cell == nil { cell = Bundle.main.loadNibNamed("txtFieldSayItWolooCell", owner: self, options: nil)?.last as? txtFieldSayItWolooCell }
            cell?.delegate = self
            cell?.configureReceiversContactNumber(obj: objAddMessageModel)
            cell?.selectionStyle = .none
            return cell!

        case 3:
            var cell = tableView.dequeueReusableCell(withIdentifier: "SayItWolooSelectPhotoCell") as? SayItWolooSelectPhotoCell
            if cell == nil { cell = Bundle.main.loadNibNamed("SayItWolooSelectPhotoCell", owner: self, options: nil)?.last as? SayItWolooSelectPhotoCell }
            cell?.delegate = self
            cell?.configureSayItWolooSelectPhotoCell(selectedImg: selectedImg, imgName: imgName)
            cell?.selectionStyle = .none
            return cell!

        case 4:
            var cell = tableView.dequeueReusableCell(withIdentifier: "txtViewSayItWolooCell") as? txtViewSayItWolooCell
            if cell == nil { cell = Bundle.main.loadNibNamed("txtViewSayItWolooCell", owner: self, options: nil)?.last as? txtViewSayItWolooCell }
            cell?.delegate = self
            cell?.configureTxtViewSayItWolooCell(obj: objAddMessageModel)
            cell?.selectionStyle = .none
            return cell!

        case 5:
            var cell = tableView.dequeueReusableCell(withIdentifier: "SendBtnCell") as? SendBtnCell
            if cell == nil { cell = Bundle.main.loadNibNamed("SendBtnCell", owner: self, options: nil)?.last as? SendBtnCell }
            cell?.delegate = self
            cell?.selectionStyle = .none
            return cell!

        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as? StoreHomePageHeaderCell
            if cell == nil { cell = Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell }
            cell?.selectionStyle = .none
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true)
        }
    }

    // MARK: - Image Picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            if let pickedImage = info[.originalImage] as? UIImage {
                self.selectedImg = pickedImage
                self.imgName = (info[.imageURL] as? URL)?.lastPathComponent ?? "default_image_name"
                self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
                DispatchQueue.main.async {
                                           Global.showIndicator()
                                       }
                self.fileUploadAPI(uploadImg: pickedImage, qrId: "WOLOO")
            }
        }
    }

    func fileUploadAPI(uploadImg: UIImage?, qrId: String) {
        guard let uploadImg = uploadImg, let imageData = uploadImg.jpegData(compressionQuality: 0.6) else { return }
        let url = "https://api-digitalmessage.coitor.com/Message/FileUpload/"

        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "file", fileName: "upload.jpg", mimeType: "image/jpeg")
            formData.append(Data(qrId.utf8), withName: "QrId")
        }, to: url)
        .uploadProgress { progress in print("Upload Progress: \(progress.fractionCompleted * 100)%") }
        .responseDecodable(of: FileUploadWrapper.self) { response in
            switch response.result {
            case .success(let res):
                self.objAddMessageModel.AttachmentURL = res.S3URL ?? ""
                DispatchQueue.main.async {
                                           Global.hideIndicator()
                                       }
            case .failure(let err):
                print("Upload failed: \(err.localizedDescription)")
                DispatchQueue.main.async {
                                           Global.hideIndicator()
                                       }
            }
        }
    }
}
