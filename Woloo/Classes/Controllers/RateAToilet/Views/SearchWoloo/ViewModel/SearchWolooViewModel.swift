//
//  SearchWolooViewModel.swift
//  Woloo
//
//  Created by CEPL on 07/06/25.
//

import Foundation

protocol SearchWolooViewModelProtocol: NSObjectProtocol{
    
    func didRecieveSearchWolooResponse(listWrapper: BaseResponse<SearchListWrapper>)
    func didRecieveSearchWolooError(strError: String)
}

struct SearchWolooViewModel{
    
    var delegtae: SearchWolooViewModelProtocol?
    
    func searchWoloo(strQuery: String?,page: Int?){
        
        WolooHostAPI().searchWolooHost(strQuery: strQuery ?? "", page: page ?? 0) { objCommonWrapper in
            self.delegtae?.didRecieveSearchWolooResponse(listWrapper: objCommonWrapper)
        } failure: { error in
            self.delegtae?.didRecieveSearchWolooError(strError: error?.localizedDescription ?? "")
        }

    }
    
}
