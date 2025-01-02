//
//  StoreDetailsHeaderView.swift
//  Woloo
//
//  Created by Ashish Khobragade on 04/01/21.
//

import UIKit

class StoreDetailsHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateCountLabel: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var transportImage: UIImageView!
    @IBOutlet weak var redeemButton: UIButton!
    @IBOutlet weak var offerIcon: UIImageView!

   var redeemAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> UIView {
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func configureUI() {
        self.roundCorners(corners: [.topLeft,.topRight], radius: 20.0)
    }
    
    func setV2(store: NearbyResultsModel?, mode: TransportMode){
        
        timeLabel.text = store?.duration ?? ""
        distanceLabel.text = store?.distance ?? ""
        storeTitle.text = store?.name ?? ""
        locationLabel.text = store?.address ?? ""
        rateCountLabel.text = "3.0"
        transportImage.image = mode.whiteImage
        openTime.text = "Open Time: \(store?.opening_hours ?? "")" // to parse the data from the API
        print("opening hours: \(store?.opening_hours ?? "")")
        //print("ratings: \(store?.rating ?? "")")
        
        print("timeLabel.text: \(store?.duration ?? "")")
        
        if ((store?.offer) != nil) {
            redeemButton.isHidden = false
            offerImage.isHidden = false
        } else {
            redeemButton.isHidden = true
            offerImage.isHidden = true
        }
        
    }
    
    
    func set(store: WolooStore?, mode: TransportMode) {
        timeLabel.text = store?.duration ?? ""
        distanceLabel.text = store?.distance ?? ""
        storeTitle.text = store?.name ?? ""
        locationLabel.text = store?.address ?? ""
        rateCountLabel.text = store?.rating ?? "0.0"
        transportImage.image = mode.whiteImage
        if ((store?.offer) != nil) {
            redeemButton.isHidden = false
            offerImage.isHidden = false
        } else {
            redeemButton.isHidden = true
            offerImage.isHidden = true
        }
        
        openTime.text = "Open Time: 12noon – 11:30pm"
        
        /*
        if store?.duration == "-" {
            timeLabel.text = "-"
        } else {
            let dur = Int(store?.duration ?? "0") ?? 0
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: dur)//wolooStore.duration ?? 0
            timeLabel.text = ""
            if h > 0 {
                timeLabel.text = "\(h)Hr"
            }
            if m > 0 {
                timeLabel.text = "\(timeLabel.text ?? "")\(m)Min"
            }
            
            if (timeLabel.text ?? "").isEmpty {
                timeLabel.text = "0 Min"
            }
        }

        if let distance = store?.distance{
            if store?.distance == "-" {
                distanceLabel.text = distance
            } else {
                distanceLabel.text = String(format: "%.2fkm", distance.toDouble() ?? 0.00)
            }
        }
        */
        
        openTime.text = "Open Time: 12noon – 11:30pm"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    @IBAction func ReedemAction(_ sender: Any) {
        redeemAction?()
    }
}
