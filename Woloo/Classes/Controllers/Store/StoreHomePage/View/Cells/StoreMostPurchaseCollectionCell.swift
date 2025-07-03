//
//  StoreMostPurchaseCollectionCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 30/01/25.
//

import UIKit

protocol StoreMostPurchaseCollectionCellDelegate: NSObjectProtocol{
    
    func didUpdateProductQuantity(objproduct: Products?, strType: String?)
    
    func didWishlishedItem(objProduct: Products?, strType: String?)
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
        
        if self.objProduct.variants?[0].inventory_quantity == 0{
            self.lblAddNotify.text = "Notify"
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
    
    
    func configureAllProductCollectionCell(objProducts: Products?, listCartItems: [CartItems]?){
      //  self.btnIsLiked.isHidden = false
        self.imgVwBack.viewCornerRadius = 18.24
        self.imgProduct.layer.cornerRadius = 18.24
        self.objProduct = objProducts ?? Products()
        self.lblRatingCount.text = "(\(objProducts?.review_count ?? 0))"
        self.lblProductName.text = objProducts?.title ?? ""
        //self.lblSellerName.text = objProducts?.subtitle ?? ""
        imgProduct.sd_setImage(with: URL(string: objProducts?.thumbnail ?? ""), completed: nil)
        self.lblPrice.text = "\u{20B9}"+"\(objProducts?.variants?[0].calculated_price?.original_amount ?? 0)"
        
        self.lblVariant.text = objProducts?.variants?.first?.options?.first?.value ?? ""
        
        if self.objProduct.tags?.count ?? 0 > 0 {
            self.vwBackTag.isHidden = false
            self.lblTag.text = objProducts?.tags?[0].value ?? ""
        }
        else{
            //self.vwBackTag.isHidden = true
        }
        
        
        if objProducts?.variants?[0].inventory_quantity == 0{
            self.lblAddNotify.text = "Notify"
            self.lblTag.text = "Out of Stock"
            self.vwBackTag.isHidden = false
            self.vwOverlay.isHidden = false
        }
        else{
            self.lblAddNotify.text = "Add"
        }
        
        for variant in self.listCartItems
        {
            print("Varian ID to map: ", variant.variant_id ?? "")
            if objProducts?.id == variant.product_id ?? ""{
                print("product ID Found:", variant.product_id ?? "")
                self.objProduct.prodQuantity = variant.quantity ?? 0
            }
        }
        

        if objProducts?.prodQuantity ?? 0 > 0{
            self.vwBackItemQuantity.isHidden = false
            self.vwBackAddBtn.isHidden = true
            print("show quantity btn ", objProducts?.title ?? "")
        }
        else if objProducts?.prodQuantity == 0{
           
            self.vwBackItemQuantity.isHidden = true
            self.vwBackAddBtn.isHidden = false
            print("show add btn ", objProducts?.title ?? "")
        }
        self.lblItemQuantity.text = "\(objProducts?.prodQuantity ?? 0)"
        
        
        if self.objProduct.tags?.count ?? 0 > 0 {
            self.vwBackTag.isHidden = false
            self.lblTag.text = objProducts?.tags?[0].value ?? ""
        }
        else{
            //self.vwBackTag.isHidden = true
        }
        
    }
    
    
    @IBAction func clickedBtnRemove(_ sender: UIButton) {
        
        if self.delegate != nil {
            
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 - 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Remove")
        }
        
    }
    
    @IBAction func clickedBtnAdd(_ sender: UIButton) {
        if self.delegate != nil {
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 + 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Add")
        }
    }
    
    @IBAction func clickedBtnPlus(_ sender: UIButton) {
        if self.delegate != nil {
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 + 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Add")
        }
    }
    
    @IBAction func clickedBtnMinus(_ sender: UIButton) {
        if self.delegate != nil {
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 + 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Remove")
        }
    }
    
    
    @IBAction func clickedAddToCart(_ sender: UIButton) {
        if self.delegate != nil {
//            self.objProduct.quantity =  self.objProduct.quantity  ?? 0 + 1
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Add")
        }
    }
    
}
