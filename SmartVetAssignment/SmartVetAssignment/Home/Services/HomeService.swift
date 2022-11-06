//
//  HomeService.swift
//  SmartVetAssignment
//
//  Created by NWagh on 05/11/22.
//

import Foundation

class HomeService: HomeServicesProtocol {
    
    //MARK: - Properties
    let httpUtility: HTTPUtilityProtocol
    
    //MARK: - init
    init(httpUtility: HTTPUtilityProtocol) {
        self.httpUtility = httpUtility
    }
    
    //MARK: - Config Service call
    func getConfigurationDetails(completionHandle: @escaping (ConfigModel?, NetworkError?) -> Void) {
        let configURL = URL(string: Constants.AppURL.config)!
        httpUtility.getData(requestUrl: configURL, resultType: ConfigModel.self) { (result) in
            switch result {
            case .success(let configModel):
                completionHandle(configModel, nil)
            case .failure(let error):
                completionHandle(nil, error)
            }
        }
    }
    
    //MARK: - Pets Service call
    func getPetsInfoList(completionHandle: @escaping (PetModel?, NetworkError?) -> Void) {
        let petsURL = URL(string: Constants.AppURL.pets)!
        httpUtility.getData(requestUrl: petsURL, resultType: PetModel.self) { (result) in
            switch result {
            case .success(let petsModel):
                completionHandle(petsModel, nil)
            case .failure(let error):
                completionHandle(nil, error)
            }
        }
    }
}
