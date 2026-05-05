//
//  MoreViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 16/09/24.
//

import Foundation


protocol MoreViewModelDelegate{
    
    func didReceiveUploadProfilePhotoResponse(objResponse: BaseResponse<Profile>)
    
    func didUploadProfilePhotoError(strError: String)
    
    func didReceiveCreditUserCoinsResponse(objResponse: CoinsWrapper)
    
    func didReceiceCreditUserCoinsError(strError: String)
    
    func didReceiveDeleteResponse(objCommonWrapper: BaseResponse<DeleteUser>)
    func didDeleteUserError(strError: String)
    
}

struct MoreViewModel{
    
    var delegate : MoreViewModelDelegate?
    
    func uploadProfileImage(profileImage : UIImage?){
        
        WolooGuestAPI().uploadProfileImage(profileImage: profileImage ?? UIImage()) { objCommonWrapper in
            self.delegate?.didReceiveUploadProfilePhotoResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didUploadProfilePhotoError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func creditUserCoins(blogId: Int?,coins: Int?, isGift: Int?, strRemarks: String?,strType: String?, woloo_id: Int?, wolooCoins: Int?){
        
        WolooGuestAPI().creditUserCoins(blogId: blogId ?? 0, coins: coins ?? 0, isGift: isGift ?? 0, strRemarks: strRemarks ?? "", strType: strType ?? "", woloo_id: woloo_id ?? 0, wolooCoins: wolooCoins ?? 0) { objCommonWrapper in
            self.delegate?.didReceiveCreditUserCoinsResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceCreditUserCoinsError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func deleteUserAPI(){
            WolooGuestAPI().deleteUser { objCommonWrapper in
                self.delegate?.didReceiveDeleteResponse(objCommonWrapper: objCommonWrapper)
            } failure: { error in
                self.delegate?.didDeleteUserError(strError: error?.localizedDescription ?? "")
            }

            
        }
    
}
