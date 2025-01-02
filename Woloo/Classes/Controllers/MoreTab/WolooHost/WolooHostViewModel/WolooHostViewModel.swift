//
//  WolooHostViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 05/09/24.
//

import Foundation

protocol WolooHostViewModelDelegate {
   
    func didAddWolooResponse(objResponse: BaseResponse<StatusSuccessResponseModel>)
    func didAddWolooError(strError: String)
}

struct WolooHostViewModel {
    
    var delegate : WolooHostViewModelDelegate?
    
    func addWolooForHost(images : [UIImage], name: String?, address: String? ,city: String?, lat: Double?, long: Double?, pincode: String?){
        
        WolooHostAPI().addWolooAPI(images: images, name: name ?? "", address: address ?? "", city: city ?? "", lat: lat ?? 0.0, long: long ?? 0.0, pincode: pincode ?? "") { objCommonWrapper in
            self.delegate?.didAddWolooResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didAddWolooError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
    
    func recommendWolooForHost(images : [UIImage], name: String?, address: String? ,city: String?, lat: Double?, long: Double?, pincode: String?, recommendedMobile: String?){
        
        WolooHostAPI().recommendWolooAPI(images: images, name: name ?? "", address: address ?? "", city: city ?? "", lat: lat ?? 0.0, long: long ?? 0.0, pincode: pincode ?? "", recommendedMobile: recommendedMobile) { objCommonWrapper in
            self.delegate?.didAddWolooResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didAddWolooError(strError: error?.localizedDescription ?? "")
        }

    }
        
}

