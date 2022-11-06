//
//  HttpUtility.swift
//  SmartVetAssignment
//
//  Created by NWagh on 05/11/22.
//

import Foundation

protocol HTTPUtilityProtocol {
     func getData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>)-> Void)
}

public class HTTPUtility: HTTPUtilityProtocol {
    
    static let session = HTTPUtility()
    private init(){}
    
    public func getData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>)-> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = HttpMethods.get.rawValue
        
        URLSession.shared.dataTask(with: requestUrl) { (data, httpUrlResponse, error) in
            let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                completionHandler(.failure(NetworkError(errorMessage: error.localizedDescription, forStatusCode: statusCode!)))
            } else {
                guard let resultData = data else { return }
                do {
                    let response = try JSONDecoder().decode(resultType.self, from: self.convertDataToJsonData(data: resultData))
                    completionHandler(.success(response))
                } catch let error {
                    completionHandler(.failure(NetworkError(errorMessage: error.localizedDescription, forStatusCode: statusCode!)))
                }
            }
        }.resume()
    }
    
    // MARK: - Private Methods
    private func convertDataToJsonData(data: Data) -> Data {
        let jsonString = String(decoding: data, as: UTF8.self)
        return jsonString.data(using: .utf8)!
    }
}
