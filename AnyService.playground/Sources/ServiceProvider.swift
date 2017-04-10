import Foundation

public typealias Callback<T> = (() throws -> T) -> ()

public protocol URLSessionProvider {
    var session: URLSession { get }
}

public protocol ServiceProvider: URLSessionProvider {
    var scheme: String  { get }
    var host:   String  { get }
    var path:   String? { get }
}

extension ServiceProvider {
    var baseURLString: String {
        return "\(scheme)://\(host)"
    }
    
    var serviceURLString: String {
        guard let path = path, !path.isEmpty else {
            return baseURLString
        }
        
        if path.hasPrefix("/") {
            return baseURLString.appending(path)
        }
        
        return baseURLString.appending("/\(path)")
    }
}

extension ServiceProvider {
    private func route(for endpoint: String) -> String {
        guard !endpoint.isEmpty else {
            return serviceURLString
        }
        
        if endpoint.hasPrefix("/") {
            return serviceURLString.appending(endpoint)
        }
        
        return serviceURLString.appending("/\(endpoint)")
    }
    
    public func fetch(endpoint: String ..., method: RequestMethod = .get(parameters: nil), callback: @escaping Callback<(Any, URLResponse)>) throws -> URLSessionDataTask {
        let request = try method.compose(route(for: endpoint.joined(separator: "/")))
        print("\(request)")
        
        return session.dataTask(with: request) { data, response, error in
            callback {
                guard error == nil else {
                    throw error!
                }
                return (try data?.parseJSON() as Any, response!)
            }
        }
    }
}

extension Data {
    fileprivate func parseJSON(_ options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
}
