//
//  GetService.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class GetService<T: Codable> {

	//MARK: - Public properties

	let urlString: String

	//MARK: - Private properties

	private let session: URLSession

	//MARK: - Initializer

	init(urlString: String, session: URLSession = URLSession.shared) {
		self.session = session
		self.urlString = urlString
	}

	//MARK: - Public functions

	func execute(urlRequest: URLRequest, _ completionHandler: @escaping (Result<T, DataResponseError>) -> Void) {
		let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
			guard
				let httpResponse = response as? HTTPURLResponse,
				httpResponse.hasSuccessStatusCode,
				let data = data else {
					DispatchQueue.main.async {
						completionHandler(Result.failure(.network))
					}
					return
				}

			guard
				let response = try? JSONDecoder().decode(T.self, from: data)
			else {
				DispatchQueue.main.async {
					completionHandler(Result.failure(.decoding))
				}
				return
			}

			DispatchQueue.main.async {
				completionHandler(Result.success(response))
			}

		}
		dataTask.resume()
	}

	//MARK: - Helper functions

	func urlRequestWithPathComponents(urlString: String, pathComponents: [String]) -> URL? {
		var url = URL(string: urlString)
		pathComponents.forEach { url?.appendPathComponent($0) }
		return url
	}
}

enum DataResponseError: Error {
	case network
	case decoding
	case noData
	case invalidURLRequest

	var errorDescription: String? {
		switch self {
		case .network:
			return "Network error"
		case .decoding:
			return "Parsing error"
		case .noData:
			return "No data"
		case .invalidURLRequest:
			return "Invalid URLRequest"
		}
	}
}

extension HTTPURLResponse {
	var hasSuccessStatusCode: Bool {
		return 200...299 ~= self.statusCode
	}
}

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
