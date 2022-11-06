//
//  HomeViewViewModelProtocol.swift
//  SmartVetAssignment
//
//  Created by NWagh on 05/11/22.
//

import Foundation

protocol HomeViewViewModelProtocol {
    var configSetting: Settings? { get set }
    var petsArray: [Pet]? { get set }
    var showCallChatOptions: Bool { get }
    var rowsCount: Int { get }
    var operationCompletion: ((Bool, String?)-> Void)? { get set }
    func checkIfWithinWorkHours(now: Date) -> Bool
    func loadRemoteData()
}
