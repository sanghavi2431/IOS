//
//  MapWolooStoreCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 14/01/21.
//

import UIKit

class MapWolooStoreCell: UICollectionViewCell {
    
    @IBOutlet weak var wolooName: UILabel!
    @IBOutlet weak var cibilScoreImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var timeToTravelTostoreLabel: UILabel!
    @IBOutlet weak var startNavigationBtn: UIButton!
    
    @IBOutlet weak var toilet: UIImageView!
    @IBOutlet weak var wheelChair: UIImageView!
    @IBOutlet weak var feeding: UIImageView!
    @IBOutlet weak var senitizer: UIImageView!
    @IBOutlet weak var coffee: UIImageView!
    @IBOutlet weak var makeup: UIImageView!
    @IBOutlet weak var diaper: UIImageView!
    @IBOutlet weak var covidFree: UIImageView!
    @IBOutlet weak var safeSpace: UIImageView!
    @IBOutlet weak var clean: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var imgTravelMode: UIImageView!
    
    var transportMode = TransportMode.car
    
    var directionBtnAction : (() -> Void)?
    var startBtnAction : (() -> Void)?
    var shareBtnAction : (() -> Void)?
    var likeBtnAction : (() -> Void)?
    
    var wolooStoreDO:WolooStore?{
        didSet{
            configureData()
            collectionView.reloadData()
        }
    }
    
    var wolooStoreDoV2: NearbyResultsModel?{
        
        didSet{
            configureDataV2()
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //configureUI()
        configureUI2()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configureUI() {
        backgroundColor = .clear
        collectionView.register(OfferImageCell.nib, forCellWithReuseIdentifier: OfferImageCell.identifier)
    }
    
    func configureUI2(){
        
        backgroundColor = .clear
        collectionView.register(OfferImageCell.nib, forCellWithReuseIdentifier: OfferImageCell.identifier)
        
        startNavigationBtn.isHidden = true
    }
    
    @IBAction func directionAction(_ sender: Any) {
        directionBtnAction?()
    }
    @IBAction func startAction(_ sender: Any) {
        
        print("Start pass the lat and long to open google map ")
        startBtnAction?()
    }
    @IBAction func shareAction(_ sender: Any) {
        shareBtnAction?()
    }
    @IBAction func likeAction(_ sender: Any) {
        changeLikeUnlikeUIChange()
        likeBtnAction?()
    }
    func configureData()  {
        guard let wolooStore = wolooStoreDO else { return }
        
        
        storeAddressLabel.text = wolooStore.address
        imgTravelMode.image = transportMode.whiteImage
        storeDistanceLabel.text = wolooStore.distance ?? ""
        timeToTravelTostoreLabel.text = wolooStore.duration ?? ""

        /*
        if wolooStore.duration == "-" {
            timeToTravelTostoreLabel.text = "-"
        } else {
            let dur = Int(wolooStore.duration ?? "0") ?? 0
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: dur)//wolooStore.duration ?? 0
            
            timeToTravelTostoreLabel.text = ""
            if h > 0 {
                timeToTravelTostoreLabel.text = "\(h) Hr "
            }
            if m > 0 {
                timeToTravelTostoreLabel.text = "\(timeToTravelTostoreLabel.text ?? "")\(m) Min"
            }
            if (timeToTravelTostoreLabel.text ?? "").isEmpty {
                timeToTravelTostoreLabel.text = "0 Min"
            }
        }
        if let distance = wolooStore.distance{
            if wolooStore.distance == "-" {
                storeDistanceLabel.text = distance
            } else {
                storeDistanceLabel.text = String(format: "%.2fkm", distance.toDouble() ?? 0.00)
            }
        }
        */
        
        if let isWashroom = wolooStore.isWashroom, isWashroom == 1 {
            toilet.isHidden = false
        }
        if let isWheelchairAccessible = wolooStore.isWheelchairAccessible, isWheelchairAccessible == 1 {
            wheelChair.isHidden = false
        }
        if let isFeedingRoom = wolooStore.isFeedingRoom, isFeedingRoom == 1 {
            feeding.isHidden = false
        }
        if let isSanitizerAvailable = wolooStore.isSanitizerAvailable, isSanitizerAvailable == 1 {
            senitizer.isHidden = false
        }
        if let isCoffeeAvailable = wolooStore.isCoffeeAvailable, isCoffeeAvailable == 1 {
            coffee.isHidden = false
        }
        if let isMakeupRoomAvailable = wolooStore.isMakeupRoomAvailable, isMakeupRoomAvailable == 1 {
            makeup.isHidden = false
        }
        if let isSanitaryPadsAvailable = wolooStore.isSanitaryPadsAvailable, isSanitaryPadsAvailable == 1 {
            diaper.isHidden = false
        }
        if let isCleanAndHygiene = wolooStore.isCleanAndHygiene, isCleanAndHygiene == 1 {
            clean.isHidden = false
        }
        if let isSafeSpace = wolooStore.isSafeSpace, isSafeSpace == 1 {
            safeSpace.isHidden = false
        }
        if let isCovidFree = wolooStore.isCovidFree, isCovidFree == 1 {
            covidFree.isHidden = false
        }
    }
    
    func configureDataV2(){
        
        guard let wolooStore = wolooStoreDoV2 else { return }
        
        if wolooStore.is_liked == 1{
            print("woloo is bookmarked")
            likeBtn.layer.borderColor = UIColor(named: "Woloo_Yellow")?.cgColor

            likeBtn.setTitleColor(UIColor(named: "Woloo_Yellow") , for: .normal)

            let image = UIImage(systemName: "bookmark")!.withTintColor(UIColor(named: "Woloo_Yellow")!, renderingMode: .alwaysOriginal)
            likeBtn.setImage(image, for: .normal)

        }else {
            print("Woloo is not bookmarked")
            likeBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            likeBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    
                let image = UIImage(systemName: "bookmark")!.withTintColor(UIColor(ciColor: .white), renderingMode: .alwaysOriginal)
                likeBtn.setImage(image, for: .normal)
           
        }
        
        wolooName.text = wolooStore.name ?? ""
        storeAddressLabel.text = wolooStore.address ?? ""
        imgTravelMode.image = transportMode.whiteImage
        storeDistanceLabel.text = wolooStore.distance ?? ""
        timeToTravelTostoreLabel.text = wolooStore.duration ?? ""
        
        cibilScoreImageView.sd_setImage(with: URL(string: wolooStore.cibil_score_image ?? ""), completed: nil)
        
        if let isWashroom = wolooStore.is_washroom, isWashroom == 1 {
            toilet.isHidden = false
        }
        if let isWheelchairAccessible = wolooStore.is_wheelchair_accessible, isWheelchairAccessible == 1 {
            wheelChair.isHidden = false
        }
        if let isFeedingRoom = wolooStore.is_feeding_room, isFeedingRoom == 1 {
            feeding.isHidden = false
        }
        if let isSanitizerAvailable = wolooStore.is_sanitizer_available, isSanitizerAvailable == 1 {
            senitizer.isHidden = false
        }
        if let isCoffeeAvailable = wolooStore.is_coffee_available, isCoffeeAvailable == 1 {
            coffee.isHidden = false
        }
        if let isMakeupRoomAvailable = wolooStore.is_makeup_room_available, isMakeupRoomAvailable == 1 {
            makeup.isHidden = false
        }
        if let isSanitaryPadsAvailable = wolooStore.is_sanitary_pads_available, isSanitaryPadsAvailable == 1 {
            diaper.isHidden = false
        }
        if let isCleanAndHygiene = wolooStore.is_clean_and_hygiene, isCleanAndHygiene == 1 {
            clean.isHidden = false
        }
        if let isSafeSpace = wolooStore.is_safe_space, isSafeSpace == 1 {
            safeSpace.isHidden = false
        }
        if let isCovidFree = wolooStore.is_covid_free, isCovidFree == 1 {
            covidFree.isHidden = false
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func changeLikeUnlikeUIChange() {
        likeBtn.isSelected = !likeBtn.isSelected
        likeBtn.layer.borderColor = likeBtn.isSelected ? UIColor(named: "Woloo_Yellow")?.cgColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        likeBtn.setTitleColor(likeBtn.isSelected ? UIColor(named: "Woloo_Yellow") : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
       // let image = #imageLiteral(resourceName: "Like_2").withTintColor(likeBtn.isSelected ? UIColor(named: "Woloo_Yellow")! : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) , renderingMode: .alwaysOriginal)
        let image = UIImage(systemName: "bookmark")!.withTintColor(likeBtn.isSelected ? UIColor(named: "Woloo_Yellow")! : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) , renderingMode: .alwaysOriginal)
        likeBtn.setImage(image, for: .normal)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension MapWolooStoreCell:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let imgstr = wolooStoreDO?.offer?.image, imgstr.count > 0  {
//            return 1
//        } else {
//            return 5
//        }
        
        if let imgstr = wolooStoreDoV2?.image, imgstr.count > 0 {
            return imgstr.count
        } else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferImageCell.identifier, for: indexPath) as? OfferImageCell ?? OfferImageCell()
        cell.offerImage.image = #imageLiteral(resourceName: "logoBanner")
        
        print("Image list offer cell : \(wolooStoreDoV2?.image)")
//        if let imgstr = wolooStoreDO?.offer?.image {
//            let url = "\(API.environment.baseURL)storage/app/public/\(imgstr)"
//            cell.offerImage.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "logoBanner"), options: [], context: nil)
//        } else if let images = wolooStoreDO?.image , images.count > indexPath.item {
//            let imgstr = images[indexPath.item]
//            let url = "\(API.environment.baseURL)storage/app/public/\(imgstr)"
//            cell.offerImage.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "logoBanner"), options: [], context: nil)
//        }
        
//        if let imgstr = wolooStoreDoV2?.image{
//            
//            print("Image Url for bottom container: \(wolooStoreDoV2?.image)")
//            let url = "https://admin.woloo.in/storage/app/public/woloos/19April2021/WHMUM00204.png"
//            cell.offerImage.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "logoBanner"), options: [], context: nil)
//        }else if let images = wolooStoreDoV2?.image, images.count > indexPath.item{
//            let imhStr = images[indexPath.item]
//            let url = "https://admin.woloo.in/storage/app/public/woloos/19April2021/WHMUM00204.png"
//            cell.offerImage.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "logoBanner"), options: [], context: nil)
//        }
        if self.wolooStoreDoV2?.image?.count == 0{
            print("No image array found")
        }
        else{
            let url = "\(wolooStoreDoV2?.base_url ?? "")/\(wolooStoreDoV2?.image?[0] ?? "")"
            print("\(wolooStoreDoV2?.base_url ?? "")/\(wolooStoreDoV2?.image?[0] ?? "")")
            let trimmedUrl = url.replacingOccurrences(of: " ", with: "")
            cell.offerImage.isHidden = false
            cell.offerImage.sd_setImage(with: URL(string: trimmedUrl), completed: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? OfferImageCell else { print("OfferImageCell not available"); return }
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MapWolooStoreCell:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size:CGSize = .zero
//        if let imgstr = wolooStoreDO?.offer?.image, imgstr.count > 0  {
//            size.width = collectionView.bounds.size.width
//        } else {
//            size.width = 159
//        }
        if let imgstr = wolooStoreDoV2?.image, imgstr.count > 0 {
            size.width = collectionView.bounds.width
        }else{
            size.width = 159
        }
        
        size.height = collectionView.bounds.size.height
        
        return size
    }
}

