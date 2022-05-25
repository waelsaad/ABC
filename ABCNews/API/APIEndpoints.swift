//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

enum EndPoint {
    case justIn
    case otherFutureEndPointWithParams(result: Int, page: Int)
    
    var url: URL? {
        var items: [URLQueryItem]
        var components = URLComponents()
        components.host = Domains.Prod
        components.scheme = Scheme.https.rawValue
        //components.path = "\(Routes.Api)"
        
        switch self {
        case .justIn:
            return URL(string: Domains.justIn)
            
        case .otherFutureEndPointWithParams(let result, let page):
            let queryItems = [
                URLQueryItem(name: "results", value: String(result)),
                URLQueryItem(name: "page", value: String(page))
            ]
            items = queryItems
            components.path += "\(Path.results.rawValue)"
            components.queryItems = items
            return components.url
        }
    }
}

extension EndPoint {
    
    private enum Path: String {
        case results
    }
    
    private enum Scheme: String {
        case http
        case https
    }
    
    private struct Routes {
        static let Api = "/v1/api"
    }
    
    private struct Domains {
        static let Dev = "127.0.0.1:5000"
        static let Prod = "api.rss2json.com"
        
        static let justIn = "https://api.rss2json.com/v1/api.json?rss_url=http://www.abc.net.au/news/feed/51120/rss.xml"
    }
}
