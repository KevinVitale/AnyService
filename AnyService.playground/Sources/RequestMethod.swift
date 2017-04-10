import Foundation

public enum RequestMethod {
    case get(parameters:   [URLQueryItem]?)
    case patch(parameters: [URLQueryItem]?, body: Body?)
    case post(parameters:  [URLQueryItem]?, body: Body?)
    case put(parameters:   [URLQueryItem]?, body: Body?)
}

extension RequestMethod {
    public enum Body {
        case text(String)
        case json(Any)
        case form([URLQueryItem])
        
        fileprivate var contentType: String {
            switch self {
            case .text: return "text/plain; charset=utf-8"
            case .json: return "application/json; charset=utf-8"
            case .form: return "application/x-www-form-urlencoded; charset=utf-8"
            }
        }
        
        fileprivate func content(using encoding: String.Encoding = .utf8) throws -> Data? {
            switch self {
            case .text(let string):
                return string.data(using: encoding)
                
            case .json(let object):
                return try JSONSerialization.data(withJSONObject: object, options: [])
                
            case .form(let parameters):
                return parameters.namesAndValues
                    .map { "\($0.0)=\($0.1)" }
                    .joined(separator: "\n")
                    .data(using: encoding)
            }
        }
    }
}

extension RequestMethod {
    private var parameters: [URLQueryItem]? {
        switch self {
        case .get(let parameters): return parameters
        case .patch(let parameters, _): return parameters
        case .post(let parameters, _): return parameters
        case .put(let parameters, _): return parameters
        }
    }
    
    private var methodString: String {
        switch self {
        case .get:   return "GET"
        case .patch: return "PATCH"
        case .post:  return "POST"
        case .put:   return "PUT"
        }
    }
    
    private var contentType: String {
        switch self {
        case .patch(_, let body?):
            return body.contentType
            
        case .post(_, let body?):
            return body.contentType
            
        case .put(_, let body?):
            return body.contentType
            
        default:
            return Body.form([]).contentType
        }
    }
    
    public enum ComposeError: Error {
        case invalid(String)
        case malformed(URLComponents)
    }

    func compose(_ url: String) throws -> URLRequest {
        guard var urlComps = URLComponents(string: url) else {
            throw ComposeError.invalid(url)
        }
        
        urlComps.queryItems = parameters
        
        guard let url = urlComps.url else {
            throw ComposeError.malformed(urlComps)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = methodString
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var bodyData: Data?
        switch self {
        case .put(_, let body):
            bodyData = try body?.content()
            
        case .patch(_, let body):
            bodyData = try body?.content()
            
        case .post(_, let body):
            bodyData = try body?.content()
            
        default: bodyData = nil
        }
        request.httpBody = bodyData
        
        return request
    }
}

extension Collection where Iterator.Element == URLQueryItem {
    fileprivate var namesAndValues: [(String, String)] {
        let names = lazy.map { $0.name }
        let values = lazy.flatMap { $0.value }
        return zip(names, values)
            .sorted { $0.0.0 < $0.1.0 }
    }
}
