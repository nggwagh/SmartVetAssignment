//
//  MockHomeService.swift
//  SmartVetAssignmentTests
//
//  Created by NWagh on 06/11/22.
//

import Foundation
@testable import SmartVetAssignment

final class MockHomeService: HomeServicesProtocol {
    
    let mockhttpUtility: HTTPUtilityProtocol
    var configResultSuccess: Bool = false
    var petsInfoSuccess: Bool = false
    let bundle = Bundle(identifier: "com.sampleApp.SmartVetAssignmentTests")!
    
    init(httpUtility: HTTPUtilityProtocol) {
        self.mockhttpUtility = httpUtility
    }
    
    func getConfigurationDetails(completionHandle: @escaping (SmartVetAssignment.ConfigModel?, SmartVetAssignment.NetworkError?) -> Void) {
        if configResultSuccess == true {
            let url = bundle.url(forResource: "Config", withExtension: "json")
            mockhttpUtility.getData(requestUrl: url!, resultType: ConfigModel.self) { (result) in
                switch result {
                case .success(let configModel):
                    completionHandle(configModel, nil)
                case .failure(let error):
                    completionHandle(nil, error)
                }
            }
        } else {
            completionHandle(nil, NetworkError(errorMessage: "Failed to load", forStatusCode: 500))
        }
    }
    
    func getPetsInfoList(completionHandle: @escaping (SmartVetAssignment.PetModel?, SmartVetAssignment.NetworkError?) -> Void) {
        if petsInfoSuccess == true {
            let url = bundle.url(forResource: "Pets", withExtension: "json")
            mockhttpUtility.getData(requestUrl: url!, resultType: PetModel.self) { (result) in
                switch result {
                case .success(let PetModel):
                    completionHandle(PetModel, nil)
                case .failure(let error):
                    completionHandle(nil, error)
                }
            }
        } else {
            completionHandle(nil, NetworkError(errorMessage: "Failed to load", forStatusCode: 500))
        }
    }
    
    //MARK: - Mock Data Model
    func getSettingMockData_When_ChatEnable_CallEnable_NilWorkHours() -> Settings {
        return Settings(isChatEnabled: true, isCallEnabled: true, workHours: "")
    }
    
    func getSettingMockData_When_ChatEnable_CallEnable_InvalidWorkHours() -> Settings {
        return Settings(isChatEnabled: true, isCallEnabled: true, workHours: "ABCD 9:00 - 18:00")
    }
    
    func getSettingMockData_When_ChatEnable_CallEnable_ValidWorkHours() -> Settings {
        return Settings(isChatEnabled: true, isCallEnabled: true, workHours: "M-F 9:00 - 18:00")
    }
    
    func getSettingMockData_When_ChatDisable_CallEnable_ValidWorkHours() -> Settings {
        return Settings(isChatEnabled: false, isCallEnabled: true, workHours: "M-F 9:00 - 18:00")
    }
    
    func getSettingMockData_When_ChatDisable_CallDisable_ValidWorkHours() -> Settings {
        return Settings(isChatEnabled: false, isCallEnabled: false, workHours: "M-F 9:00 - 18:00")
    }
}
