//
//  CheckInventoryPopUpTblCell.swift
//  Woloo
//
//  Created by CEPL on 27/06/25.
//

import UIKit

protocol CheckInventoryPopUpTblCellDelegate: NSObjectProtocol{
    func didClickedBtnNotify(objCartItems: CartItems)
}

class CheckInventoryPopUpTblCell: UITableViewCell {

    @IBOutlet weak var btnNotify: ShadowViewButton!
    @IBOutlet weak var lblPartName: UILabel!
    @IBOutlet weak var lblSizeQuantity: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    var objCartItems = CartItems()
    weak var delegate: CheckInventoryPopUpTblCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgVw.layer.cornerRadius = 12.1
        
    }

    func configureCheckInventoryPopUpTblCell(objCartItems: CartItems?){
        self.objCartItems = objCartItems ?? CartItems()
        self.lblPartName.text = self.objCartItems.product_title ?? ""

        var isImageSet = false
        let searchText = self.objCartItems.variant?.options?.first?.value?.lowercased() ?? ""
        for urlImage in self.objCartItems.product?.images ?? [StoreProductImages]() {
            if let urlStr = urlImage.url?.lowercased(), urlStr.contains(searchText) {
                print("Item found: \(urlImage.url ?? "")")
                self.imgVw.sd_setImage(with: URL(string: urlImage.url ?? ""), completed: nil)
                print("Image found in image array: \(urlImage.url ?? "")")
                isImageSet = true
                break
            }
        }
        // Only if not found in images array, fallback to thumbnail
        if !isImageSet {
            let thumbUrl = self.objCartItems.product?.thumbnail ?? ""
            print("Image found in thumbnail: \(thumbUrl)")
            self.imgVw.sd_setImage(with: URL(string: thumbUrl), completed: nil)
        }
        
        
        self.lblSizeQuantity.text = String(format: "%@",
        "Qty: \(self.objCartItems.quantity ?? 0)")
        
    }
    
    @IBAction func clickedBtnNotify(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.didClickedBtnNotify(objCartItems: self.objCartItems)
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
