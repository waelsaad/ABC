//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

class APIManager {
    
    private let jsonDecoder: JSONDecoder = { let jsonDecoder = JSONDecoder(); return jsonDecoder }()
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    // Light version
    
    func request<T: Decodable>(url: URL?,
                               completion: @escaping (APIResponse<T>) -> Void) {
        
        
        guard let url = url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        URLSession.shared.dataTask(with: url) { result in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    //print(String.init(bytes: data, encoding: .utf8)!)
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch (let error) {
                    print(error)
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(.unhandled(error)))
            }
        }.resume()
    }
    
    // By Type Version
    
    func request<T: Decodable>(url: URL?,
                                type: T.Type,
                                withCompletion completion: @escaping (APIResponse<T>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        let task = session.dataTask(url: url) { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data,
                                     response: httpResponse,
                                     error: error,
                                     completion: completion)
        }
        task.resume()
    }
    
    private func handleDataResponse<T: Decodable>(data: Data?,
                                                  response: HTTPURLResponse?,
                                                  error: Error?,
                                                  completion: (APIResponse<T>) -> ()) {
        
        guard let error = error as NSError? else {
            guard
                let data = data,
                let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1),
                let modifiedDataInUTF8Format = responseStrInISOLatin.data(using: String.Encoding.utf8)
            else { return completion(.failure(.noJSONData)) }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                
                if let responseData = try? JSONSerialization.data(withJSONObject: responseJSONDict) {
                    do {
                        let model = try jsonDecoder.decode(T.self, from: responseData)
                        return completion(.success(model))
                    } catch {
                        return completion(.failure(.decodeError))
                    }
                }
            } catch {
                return completion(.failure(.unknown))
            }
            return completion(.failure(.unknown))
        }
        
        switch error.code {
        case NSURLErrorBadURL,
             NSURLErrorUnsupportedURL:
            completion(.failure(.unhandled(error)))
            
        case NSURLErrorNotConnectedToInternet,
             NSURLErrorNetworkConnectionLost,
             NSURLErrorInternationalRoamingOff:
            completion(.failure(.noInternetConnection))
            
        case NSURLErrorTimedOut:
            completion(.failure(.timedOut))
            
        default:
            completion(.failure(.unhandled(error)))
        }
    }
}
