//
//  Config.swift
//  SmartVetAssignment
//
//  Created by NWagh on 05/11/22.
//

import Foundation

// MARK: - ConfigModel
struct ConfigModel: Codable {
    let settings: Settings
}

// MARK: - Settings
struct Settings: Codable {
    let isChatEnabled, isCallEnabled: Bool
    let workHours: String
}
