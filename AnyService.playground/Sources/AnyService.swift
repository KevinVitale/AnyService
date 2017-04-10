import Foundation

public struct AnyService: ServiceProvider, ExpressibleByStringLiteral {
    private let rawValue: String
    private let components: URLComponents
    
    public var scheme: String { return components.scheme! }
    public var host: String   { return components.host! }
    public var path: String?  { return components.path.isEmpty ? nil : components.path }
    public let session: URLSession = .shared
    
    public init(stringLiteral value: String) {
        rawValue = value
        components = URLComponents(string: value)!
    }
    public init(unicodeScalarLiteral value: String) {
        rawValue = value
        components = URLComponents(string: value)!
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        rawValue = value
        components = URLComponents(string: value)!
    }
}
