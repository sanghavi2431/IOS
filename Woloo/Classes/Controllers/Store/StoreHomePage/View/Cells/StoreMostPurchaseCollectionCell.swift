//
//  StoreMostPurchaseCollectionCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 30/01/25.
//

import UIKit

protocol StoreMostPurchaseCollectionCellDelegate: NSObjectProtocol{
    
    func didUpdateProductQuantity(objproduct: Products?, strType: String?, listCart: [CartItems]?)
    
    func didWishlishedItem(objProduct: Products?, strType: String?)
    
    func didCallNotifyAPI(strVariantId: String?)
}

class StoreMostPurchaseCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    //@IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var llblOriginalPrice: UILabel!
    //@IBOutlet weak var btnIsLiked: UIButton!
    
    @IBOutlet weak var vwBackAddBtn: UIView!
    @IBOutlet weak var vwBackTag: UIView!
    @IBOutlet weak var lblTag: UILabel!
    
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblAddNotify: UILabel!
    @IBOutlet weak var vwOverlay: UIView!
    
    
    @IBOutlet weak var vwBackItemQuantity: ShadowView!
    @IBOutlet weak var lblItemQuantity: UILabel!
    @IBOutlet weak var imgVwBack: ShadowView!
    @IBOutlet weak var lblVariant: UILabel!
    
    
    var objProduct = Products()
    var listCartItems = [CartItems]()
    weak var delegate: StoreMostPurchaseCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBackAddBtn.layer.cornerRadius = 3.5
        self.vwBackAddBtn.layer.borderWidth = 1.0
        self.vwBackAddBtn.layer.borderColor = UIColor(named: "Woloo_Yellow")?.cgColor
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    func configureStoreMostPurchaseCollectionCell(objProducts: Products?, listCartItems: [CartItems]?){
        
        self.imgVwBack.viewCornerRadius = 18.24
        self.imgProduct.layer.cornerRadius = 18.24
        
        self.objProduct = objProducts ?? Products()
        self.listCartItems = listCartItems ?? [CartItems]()
        
        for variant in self.listCartItems
        {
            print("Varian ID to map: ", variant.variant_id ?? "")
            if self.objProduct.id == variant.product_id ?? ""{
                print("product ID Found:", variant.product_id ?? "")
                self.objProduct.prodQuantity = variant.quantity ?? 0
            }
        }
        
        print("Quantity: ", self.objProduct.prodQuantity ?? 0)
        
        if self.objProduct.prodQuantity ?? 0 > 0{
            self.vwBackItemQuantity.isHidden = false
            self.vwBackAddBtn.isHidden = true
            print("show quantity btn ")
        }
        else{
           
            self.vwBackItemQuantity.isHidden = true
            self.vwBackAddBtn.isHidden = false
            print("show add btn ")
        }
        
        self.lblItemQuantity.text = "\(self.objProduct.prodQuantity ?? 0)"
        
        
        self.lblRatingCount.text = "(\(self.objProduct.review_count ?? 0))"
        self.lblQuantity.text = String(self.objProduct.quantity ?? 0)
        self.lblProductName.text = objProducts?.title ?? ""
        self.lblVariant.text = objProducts?.variants?.first?.options?.first?.value ?? ""
        //self.lblSellerName.text = objProducts?.subtitle ?? ""
        imgProduct.sd_setImage(with: URL(string: objProducts?.thumbnail ?? ""), completed: nil)
        self.lblPrice.text = "\u{20B9}"+"\(objProducts?.variants?[0].calculated_price?.calculated_amount ?? 0)"
        
        
        let originalAmount = objProducts?.variants?.first?.calculated_price?.original_amount ?? 0
        let priceText = String(format: "MRP \u{20B9}%d/-", originalAmount)

        let attributedString = NSAttributedString(
            string: priceText,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            ]
        )
        self.llblOriginalPrice.attributedText = attributedString
        
        
        if self.objProduct.tags?.count ?? 0 > 0 {
            self.vwBackTag.isHidden = false
            self.lblTag.text = self.objProduct.tags?[0].value ?? ""
        }
        else{
            //self.vwBackTag.isHidden = true
        }
        
        if self.objProduct.variants?[0].inventory_quantity == 0 && self.objProduct.variants?[0].has_restock_subscription == false{
            self.lblAddNotify.text = "Notify"
            self.lblTag.text = "Out of Stock"
            self.vwBackTag.isHidden = false
            self.vwOverlay.isHidden = false
        } else if self.objProduct.variants?[0].inventory_quantity == 0 && self.objProduct.variants?[0].has_restock_subscription == true{
            self.lblAddNotify.text = "Notified"
            self.lblTag.text = "Out of Stock"
            self.vwBackTag.isHidden = false
            self.vwOverlay.isHidden = false
        }
        else{
            self.lblAddNotify.text = "Add"
        }
        
    }
    
    @IBAction func clickedBtnIsLiked(_ sender: UIButton) {
        
//        self.btnIsLiked.isSelected.toggle()
//        
//        if self.btnIsLiked.isSelected == true{
//            self.objProduct.isLiked = true
//        }
//        else{
//            self.objProduct.isLiked = false
//        }
    }
    
    
    func configureAllProductCollectionCell(objProducts: Products?, listCartItems: [CartItems]?) {
        
        self.imgVwBack.viewCornerRadius = 18.24
        self.imgProduct.layer.cornerRadius = 18.24
        
        self.objProduct = objProducts ?? Products()
        self.listCartItems = listCartItems ?? [CartItems]()
        
        // Map cart quantity to product
        for variant in self.listCartItems {
            if self.objProduct.id == variant.product_id ?? "" {
                self.objProduct.prodQuantity = variant.quantity ?? 0
            }
        }
        
        let quantity = self.objProduct.prodQuantity ?? 0
        let inventoryQty = self.objProduct.variants?.first?.inventory_quantity
        
        // Set common UI
        self.lblRatingCount.text = "(\(self.objProduct.review_count ?? 0))"
        self.lblProductName.text = self.objProduct.title ?? ""
        self.lblVariant.text = self.objProduct.variants?.first?.options?.first?.value ?? ""
        self.lblItemQuantity.text = "\(quantity)"
        
        let price = objProducts?.variants?.first?.calculated_price?.calculated_amount ?? 0
        self.lblPrice.text = "\u{20B9}\(price)"
        
        imgProduct.sd_setImage(with: URL(string: objProducts?.thumbnail ?? ""), completed: nil)
        
        // Set original price with strikethrough
        let originalAmount = objProducts?.variants?.first?.calculated_price?.original_amount ?? 0
        let priceText = "MRP \u{20B9}\(originalAmount)/-"
        self.llblOriginalPrice.attributedText = NSAttributedString(
            string: priceText,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        // Handle stock and quantity logic
        if inventoryQty == 0 &&  self.objProduct.variants?.first?.has_restock_subscription == false{
            print("Out of Stock: Show Notify + Overlay")
            self.lblAddNotify.text = "Notify"
            self.vwOverlay.isHidden = false
            self.vwBackAddBtn.isHidden = false
            self.vwBackItemQuantity.isHidden = true
            self.lblTag.text = "Out of Stock"
            self.vwBackTag.isHidden = false
        }
        else if inventoryQty == 0 &&  self.objProduct.variants?.first?.has_restock_subscription == true{
            self.lblAddNotify.text = "Notified"
            self.vwOverlay.isHidden = false
            self.vwBackAddBtn.isHidden = false
            self.vwBackItemQuantity.isHidden = true
            self.lblTag.text = "Out of Stock"
            self.vwBackTag.isHidden = false
        }
        else {
            print("In Stock or inventory unknown")
            self.vwOverlay.isHidden = true
            
            if quantity > 0 {
                print("Qty > 0: Show Quantity")
                self.vwBackItemQuantity.isHidden = false
                self.vwBackAddBtn.isHidden = true
            } else {
                print("Qty == 0: Show Add")
                self.vwBackItemQuantity.isHidden = true
                self.vwBackAddBtn.isHidden = false
                self.lblAddNotify.text = "Add"
            }
            
            // Tag display logic
            if self.objProduct.tags?.count ?? 0 > 0 {
                self.lblTag.text = self.objProduct.tags?.first?.value ?? ""
                self.vwBackTag.isHidden = false
            } else {
                self.vwBackTag.isHidden = true
            }
        }
    }


    
    
    @IBAction func clickedBtnRemove(_ sender: UIButton) {
        
        if self.delegate != nil {
            
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 - 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Remove", listCart: self.listCartItems)
        }
        
    }
    
    @IBAction func clickedBtnAdd(_ sender: UIButton) {
        if self.delegate != nil {
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 + 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Add", listCart: self.listCartItems)
        }
    }
    
    @IBAction func clickedBtnPlus(_ sender: UIButton) {
        if self.delegate != nil {
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 + 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Add", listCart: self.listCartItems)
        }
    }
    
    @IBAction func clickedBtnMinus(_ sender: UIButton) {
        if self.delegate != nil {
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 + 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Remove", listCart: self.listCartItems)
        }
    }
    
    
    @IBAction func clickedAddToCart(_ sender: UIButton) {
        
       if self.lblAddNotify.text == "Notify"{
           if self.delegate != nil {
               self.delegate?.didCallNotifyAPI(strVariantId: self.objProduct.variants?.first?.id ?? "")
           }
        }
        else if self.lblAddNotify.text == "Add"
        {
            if self.delegate != nil {
    //            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 + 1
                self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Add", listCart: self.listCartItems)
            }
        }
    }
    
}
