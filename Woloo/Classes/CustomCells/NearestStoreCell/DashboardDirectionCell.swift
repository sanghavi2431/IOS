//
//  DashboardDirectionCell.swift
//  Woloo
//
//  Created on 30/04/21.
//

import UIKit

class DashboardDirectionCell: UITableViewCell {

    @IBOutlet weak var imgTravelMode: UIImageView!
    @IBOutlet weak var lblTimeNumber: UILabel!
    //@IBOutlet weak var lblTimeUnit: UILabel!
    @IBOutlet weak var cibilScoreLbl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
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
    var directionBtnAction : (() -> Void)?
    
    var customStore: NearbyResultsModel?{
        
        didSet {
            customSetData(customStore)
          
        }
        
    }
    
    var customEnrouteStore: EnrouteListModel?{
        
        didSet {
            customSetEnrouteData(customEnrouteStore)
          
        }
        
    }
    
    var store: WolooStore? {
        didSet {
            setData(store)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configureUI()  {
        
        //cibilScoreLbl.layer.cornerRadius = 10
        
    }
    
    func setData(_ store: WolooStore?) {
        guard let wolooStore = store else { return }
        
        lblName.text = wolooStore.name
        lblAddress.text = wolooStore.address
        lblDistance.text = wolooStore.distance ?? ""
        let timeDuration = wolooStore.duration?.dropLast(4)
        lblTimeNumber.text = "\(timeDuration ?? "")"
        
        //lblTimeUnit.text = "Min"
        
        /*
        if let distance = wolooStore.distance{
            if wolooStore.distance == "-" {
                lblDistance.text = distance
            } else {
                lblDistance.text = String(format: "%.2fkm", distance.toDouble() ?? 0.00)
            }
        }
        if store?.duration == "-" {
            lblTimeNumber.text =  store?.duration ?? ""
            lblTimeUnit.text =  ""
        } else {
            var dur = Int(wolooStore.duration ?? "0") ?? 0
            if dur > 0 {
                dur = (dur/60)
            }
            lblTimeNumber.text = "\(dur)"
            lblTimeUnit.text = "Min"
            
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
    
    
    func customSetData(_ customStore: NearbyResultsModel?){
        
        guard let customwolooStore = customStore else { return }

        lblName.text = customwolooStore.name
        lblAddress.text = customwolooStore.address
        lblDistance.text = customwolooStore.distance ?? ""
        let timeDuration = customwolooStore.duration ?? ""
        
        
        lblTimeNumber.text = "\(timeDuration ?? "")"
        print("Timer \(timeDuration ?? "")")
        //lblTimeUnit.text = "Min"
        
        cibilScoreLbl.text = "\(customwolooStore.cibil_score ?? "")"
        
        cibilScoreLbl.backgroundColor = UIColor(hexString: customwolooStore.cibil_score_colour ?? "#FFFFFF")
        
        if let isWashroom = customwolooStore.is_washroom, isWashroom == 1 {
            toilet.isHidden = false
        }
        if let isWheelchairAccessible = customwolooStore.is_wheelchair_accessible, isWheelchairAccessible == 1 {
            wheelChair.isHidden = false
        }
        if let isFeedingRoom = customwolooStore.is_feeding_room, isFeedingRoom == 1 {
            feeding.isHidden = false
        }
        if let isSanitizerAvailable = customwolooStore.is_sanitizer_available, isSanitizerAvailable == 1 {
            senitizer.isHidden = false
        }
        if let isCoffeeAvailable = customwolooStore.is_coffee_available, isCoffeeAvailable == 1 {
            coffee.isHidden = false
        }
        if let isMakeupRoomAvailable = customwolooStore.is_makeup_room_available, isMakeupRoomAvailable == 1 {
            makeup.isHidden = false
        }
        if let isSanitaryPadsAvailable = customwolooStore.is_sanitizer_available, isSanitaryPadsAvailable == 1 {
            diaper.isHidden = false
        }
        if let isCleanAndHygiene = customwolooStore.is_clean_and_hygiene, isCleanAndHygiene == 1 {
            clean.isHidden = false
        }
        if let isSafeSpace = customwolooStore.is_safe_space, isSafeSpace == 1 {
            safeSpace.isHidden = false
        }
        if let isCovidFree = customwolooStore.is_covid_free, isCovidFree == 1 {
            covidFree.isHidden = false
        }
        
        
    }
    
    func customSetEnrouteData(_ customStore: EnrouteListModel?){
        
        guard let customwolooStore = customStore else { return }

        lblName.text = customwolooStore.name
        lblAddress.text = customwolooStore.address
        lblDistance.text = customwolooStore.distance ?? ""
        let timeDuration = customwolooStore.duration ?? ""
        
        
        lblTimeNumber.text = "\(timeDuration ?? "")"
        print("Timer \(timeDuration ?? "")")
        //lblTimeUnit.text = "Min"
        
        cibilScoreLbl.text = "\(customwolooStore.cibil_score ?? "")"
        
        cibilScoreLbl.backgroundColor = UIColor(hexString: customwolooStore.cibil_score_colour ?? "#FFFFFF")
        
        if let isWashroom = customwolooStore.is_washroom, isWashroom == 1 {
            toilet.isHidden = false
        }
        if let isWheelchairAccessible = customwolooStore.is_wheelchair_accessible, isWheelchairAccessible == 1 {
            wheelChair.isHidden = false
        }
        if let isFeedingRoom = customwolooStore.is_feeding_room, isFeedingRoom == 1 {
            feeding.isHidden = false
        }
        if let isSanitizerAvailable = customwolooStore.is_sanitizer_available, isSanitizerAvailable == 1 {
            senitizer.isHidden = false
        }
        if let isCoffeeAvailable = customwolooStore.is_coffee_available, isCoffeeAvailable == 1 {
            coffee.isHidden = false
        }
        if let isMakeupRoomAvailable = customwolooStore.is_makeup_room_available, isMakeupRoomAvailable == 1 {
            makeup.isHidden = false
        }
        if let isSanitaryPadsAvailable = customwolooStore.is_sanitizer_available, isSanitaryPadsAvailable == 1 {
            diaper.isHidden = false
        }
        if let isCleanAndHygiene = customwolooStore.is_clean_and_hygiene, isCleanAndHygiene == 1 {
            clean.isHidden = false
        }
        if let isSafeSpace = customwolooStore.is_safe_space, isSafeSpace == 1 {
            safeSpace.isHidden = false
        }
        if let isCovidFree = customwolooStore.is_covid_free, isCovidFree == 1 {
            covidFree.isHidden = false
        }
        
        
    }
    
    
    @IBAction func directionAction(_ sender: Any) {
        directionBtnAction?()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}
