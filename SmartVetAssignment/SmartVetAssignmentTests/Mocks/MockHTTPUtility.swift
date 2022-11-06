//
//  MockHTTPUtility.swift
//  SmartVetAssignmentTests
//
//  Created by NWagh on 06/11/22.
//

import Foundation
@testable import SmartVetAssignment

class MockHTTPUtility: HTTPUtilityProtocol {
    
    func getData<T>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping (Result<T?, SmartVetAssignment.NetworkError>) -> Void) where T : Decodable {
        let resultData = try? Data(contentsOf: requestUrl)
        do {
            let response = try JSONDecoder().decode(resultType.self, from: resultData!)
            completionHandler(.success(response))
        } catch {
            completionHandler(.failure(NetworkError(errorMessage: "Failed to load", forStatusCode: 500)))
        }
    }
}
