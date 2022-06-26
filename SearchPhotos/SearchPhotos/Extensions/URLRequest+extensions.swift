//
//  URLRequest.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

extension URLRequest {
	func encode(with parameters: [String: String]?) -> URLRequest {
		guard
			let parameters = parameters,
			parameters.isEmpty == false,
			let url = self.url,
			var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
				return self
			}

		var encodedURLRequest = self

		let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		urlComponents.queryItems = queryItems
		encodedURLRequest.url = urlComponents.url
		return encodedURLRequest
	}
}
