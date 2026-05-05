//
//  OrderSummaryItemListCell.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import UIKit

class OrderSummaryItemListCell: UITableViewCell {

    
    @IBOutlet weak var lblPartName: UILabel!
    @IBOutlet weak var lblSizeQuantity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    var objCartItems = CartItems()
    var objOrderItem = OrderItem()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgVw.layer.cornerRadius = 12.1
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgVw.image = nil // Prevent flicker on reuse
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOrderSummaryItemListCell(objCartItems: CartItems?) {
        self.objCartItems = objCartItems ?? CartItems()

        // Set basic product info
        self.lblPartName.text = self.objCartItems.product_title ?? ""
        self.lblPrice.text =  "\u{20B9}"+"\(self.objCartItems.unit_price ?? 0)"
        
       
        
        self.lblSizeQuantity.text = "\(self.objCartItems.title ?? "") | Qty: \(self.objCartItems.quantity ?? 0)"

        // Clear old image
        self.imgVw.image = nil
        self.imgVw.layer.cornerRadius = 8.0
        self.imgVw.clipsToBounds = true

        var isImageSet = false
        let searchText = self.objCartItems.variant?.options?.first?.value?.lowercased() ?? ""

        // Match image based on variant option (e.g., color code)
        for urlImage in self.objCartItems.product?.images ?? [] {
            if let urlStr = urlImage.url?.lowercased(), urlStr.contains(searchText), let imageUrl = URL(string: urlImage.url ?? "") {
                print("Order Summary Image matched from product.images: \(urlImage.url ?? "")")
                self.imgVw.sd_setImage(with: imageUrl) { image, error, _, _ in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        self.imgVw.image = UIImage(named: "placeholder_image")
                    }
                }
                isImageSet = true
                break
            }
        }

        // Fallback to thumbnail if no match found
        if !isImageSet {
            if let thumbUrlStr = self.objCartItems.product?.thumbnail, !thumbUrlStr.isEmpty, let thumbUrl = URL(string: thumbUrlStr) {
                print("Order Summary Image fallback to thumbnail: \(thumbUrlStr)")
                self.imgVw.sd_setImage(with: thumbUrl) { image, error, _, _ in
                    if let error = error {
                        print("Error loading thumbnail: \(error.localizedDescription)")
                        self.imgVw.image = UIImage(named: "placeholder_image")
                    }
                }
            } else {
                print("No valid image found, setting placeholder.")
                self.imgVw.image = UIImage(named: "placeholder_image")
            }
        }
    }

    func configureStoreOrderStatusListCell(objOrderItem: OrderItem?){
        
        self.objOrderItem = objOrderItem ?? OrderItem()
        
        // Set basic product info
        self.lblPartName.text = self.objOrderItem.product_title ?? ""
        self.lblPrice.text =  "\u{20B9}"+" \(self.objOrderItem.unit_price ?? 0)/-"
        
        self.lblSizeQuantity.text = "\(self.objOrderItem.title ?? "") | Qty: \(self.objOrderItem.quantity ?? 0)"
        
        self.imgVw.sd_setImage(with: URL(string: objOrderItem?.thumbnail ?? ""), completed: nil)
        
    }
    
}
