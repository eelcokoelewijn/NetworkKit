import Foundation

public struct Resource {
    let request: Request
    
    init(request: Request) {
        self.request = request
    }
}

extension Resource: Equatable { }

public func ==(lhs: Resource, rhs: Resource) -> Bool {
    return lhs.request == rhs.request
}
