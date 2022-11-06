//
//  Constants.swift
//  SmartVetAssignment
//
//  Created by NWagh on 06/11/22.
//

import Foundation

struct Constants {
    
    static let alertTitle = "Alert"
    static let okTitle = "Ok"
    static let errorTitle = "Error"
    static let cellHeight = 100.0
    static let placeholderImage = "placeholderImage"
    static let workingHours = "Office Hours"
    static let regularExpression = "M-F 9:00 - 18:00"
    
    struct AppURL {
        private struct Domains {
            static let dev = "https://raw.githubusercontent.com"
        }
        private struct Routes {
            static let api = "/nggwagh/api/main"
        }
        private static let baseURL = Domains.dev + Routes.api
        static let config = baseURL + "/config.json"
        static let pets = baseURL + "/pets.json"
    }
    
    struct Messages {
        static let workHours = "Thank you for getting in touch with us. We’ll get back to you as soon as possible"
        static let outsideWorkHours = "Work hours has ended. Please contact us again on the next work day"
    }
    
    struct CellIdentifier {
        static let action = "ActionsCell"
        static let pets = "PetsCell"
    }
    
    struct SegueIdentifier {
        static let petDetails = "segueToDetails"
    }
}

enum HttpMethods : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
