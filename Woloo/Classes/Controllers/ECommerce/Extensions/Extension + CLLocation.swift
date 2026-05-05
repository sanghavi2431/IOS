//
//  Extension + CLLocation.swift
//  Woloo
//
//  Created by Chandan Sharda on 01/08/21.
//

import Foundation
import CoreLocation

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
