import Foundation

struct Resource {
    let request: Request
    
    init(request: Request) {
        self.request = request
    }
}

extension Resource: Equatable { }

func ==(lhs: Resource, rhs: Resource) -> Bool {
    return lhs.request == rhs.request
}
