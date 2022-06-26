//
//  MockURLProtocol.swift
//  SearchPhotosTests
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class MockURLProtocol: URLProtocol {

	static var stubResponseData: Data?
	static var response: HTTPURLResponse?
	static var error: Error?

	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	override func startLoading() {

		if let response = MockURLProtocol.response {
			self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		}

		if let error = MockURLProtocol.error {
			self.client?.urlProtocol(self, didFailWithError: error)
		} else {
			self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
		}

		self.client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() { }

}

extension MockURLProtocol {
	static func getSessionWithMockURLProtocol() -> URLSession {
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		return URLSession(configuration: config)
	}
}
