//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

enum APIResponse<T> {
    case success(T)
    case failure(APIError)
}

enum APIError: Error, Equatable {
    case invalidEndpoint
    case invalidResponse
    case noInternetConnection
    case timedOut
    case noJSONData
    case decodeError
    case unhandled(_: NSError)
    case unknown
}

extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .noInternetConnection:
            return "API.ERROR.NO.INTERNET.CONNECTION".localized
        case .timedOut:
            return "API.ERROR.TIMEOUT".localized
        case .noJSONData:
            return "API.ERROR.NO.JSON.DATA".localized
        case .invalidEndpoint:
            return "API.ERROR.INVALID.ENDPOINT".localized
        case .invalidResponse:
            return "API.ERROR.INVALID.RESPONSE".localized
        case .decodeError:
            return "API.ERROR.DECODING.ERROR".localized
        case let .unhandled(error):
            return "API.ERROR.UNHANDLED.NETWORK.ERROR".localized + "\(error)"
        case .unknown:
            return "API.ERROR.UNKNOWN".localized
        }
    }
}
