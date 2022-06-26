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
