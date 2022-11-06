//
//  HomeServiceProtocol.swift
//  SmartVetAssignment
//
//  Created by NWagh on 05/11/22.
//

import Foundation

protocol HomeServicesProtocol {
    func getConfigurationDetails(completionHandle: @escaping (ConfigModel?, NetworkError?)-> Void)
    func getPetsInfoList(completionHandle: @escaping (PetModel?, NetworkError?)-> Void)
}
