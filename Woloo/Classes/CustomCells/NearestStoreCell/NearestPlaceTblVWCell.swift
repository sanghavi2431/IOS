//
//  NearestPlaceTblVWCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 27/09/24.
//

import UIKit

class NearestPlaceTblVWCell: UITableViewCell {
    
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblContactInfo: UILabel!
    
    var nearByPlace: Place? {
        didSet {
            setData(nearByPlace)
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setData(_ nearByPlace: Place?){
        
        guard let nearByPlace = nearByPlace else { return }
        
       // self.lblTitle.text = nearByPlace.placeId
        self.lblName.text  = nearByPlace.name
        self.lblAddress.text = nearByPlace.address
        self.lblContactInfo.text = nearByPlace.phone ?? ""
        
        if let photoReference = nearByPlace.photoReference {
            fetchPlacePhoto(photoReference: photoReference)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // Fetch place photo from photo reference
    func fetchPlacePhoto(photoReference: String) {
        let photoURL = "https://maps.googleapis.com/maps/api/place/photo"
        let url = "\(photoURL)?maxwidth=400&photoreference=\(photoReference)&key=\(Constant.ApiKey.googleMap)"
        
        if let photoURL = URL(string: url) {
            URLSession.shared.dataTask(with: photoURL) { data, response, error in
                if let error = error {
                    print("Error fetching photo: \(error)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    // Use the image (for example, display it in an UIImageView)
                    print("Fetched image")
                    DispatchQueue.main.async {
                        // Display the image in a UIImageView, etc.
                        // self.placeImageView.image = image
                        self.imgVw.image = image
                    }
                }
            }.resume()
        }
    }
}
