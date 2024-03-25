//
//  URLProtocolMock.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

class URLProtocolMock: URLProtocol {
    static var mockResponses = [URL: (Data?, URLResponse?, Error?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            let normalizedURLString = url.absoluteString.hasSuffix("?") ? String(url.absoluteString.dropLast()) : url.absoluteString

            guard let normalizedURL = URL(string: normalizedURLString) else {
                let error = NSError(domain: "MockError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to normalize URL"])
                client?.urlProtocol(self, didFailWithError: error)
                return
            }

            if let mockResponse = URLProtocolMock.mockResponses[normalizedURL] {
                if let response = mockResponse.1 {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                if let data = mockResponse.0 {
                    client?.urlProtocol(self, didLoad: data)
                } else {
                    client?.urlProtocol(self, didLoad: Data())
                }
                client?.urlProtocolDidFinishLoading(self)
            } else {
                let error = NSError(domain: "MockError", code: 1, userInfo: nil)
                        client?.urlProtocol(self, didFailWithError: error)
            }
            
        } else {
            let error = NSError(domain: "MockError", code: 0, userInfo: nil)
            client?.urlProtocol(self, didFailWithError: error)
        }
        self.client?.urlProtocolDidFinishLoading(self)
   }

    override func stopLoading() {
        // Required to be implemented. Do nothing here.
    }
}
