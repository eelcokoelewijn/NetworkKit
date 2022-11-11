import Foundation
#if os(Linux)
import FoundationNetworking
#endif

extension URLSession {
    /**
     Adds option for async/await to URLSession using `withUnsafeThrowingContinuation` api for Linux.
     The async URLSession APIs aren't available on FoundationNetworking
     
     This doesn't have the same semantics as Darwin, because Darwin ensures task cancellation trickles down into canceling the connection, which isn't occurring here.
     
     - Ref: https://medium.com/hoursofoperation/use-async-urlsession-with-server-side-swift-67821a64fa91
     - Ref: https://forums.swift.org/t/how-to-use-async-await-w-docker/49591/13
     **/
    @available(macOS 10.15, *)
    func asyncData(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withUnsafeThrowingContinuation { continuation in
            let sessionDataTask = self.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                switch (data, response, error) {
                case (nil, nil, let error?):
                    continuation.resume(throwing: error)
                case (let data?, let response?, nil):
                    continuation.resume(returning: (data, response))
                default:
                    fatalError("Unexpected state, data and response are nil or no error encountered")
                }
            }
            sessionDataTask.resume()
        }
    }
}
