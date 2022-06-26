//
//  PhotosSearchGetService.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

protocol PhotosSearchGetServiceProtocol {
	func getPhotos(with searchTerm: String, page: Int, completionHandler: @escaping (Result<PhotosSearchGetResponse, DataResponseError>) -> Void)
}

extension PhotosSearchGetService: PhotosSearchGetServiceProtocol {}

class PhotosSearchGetService: GetService<PhotosSearchGetResponse>, KeyEnabled {

	//MARK: - Private properties

	private var defaultQueryItems: [String: String] {
		[
			"api_key": self.key,
			"method": "flickr.photos.search",
			"format": "json",
			"nojsoncallback": "1",
			"per_page": "10"
		]
	}

	//MARK: - Public functions

	func getPhotos(with searchTerm: String, page: Int, completionHandler: @escaping (Result<PhotosSearchGetResponse, DataResponseError>) -> Void) {
		guard let urlRequest = self.getURLRequest(with: searchTerm, page: page) else {
			completionHandler(Result.failure(.invalidURLRequest))
			return
		}
		self.execute(urlRequest: urlRequest, completionHandler)
	}

	//MARK: - Private functions

	private func getURLRequest(with searchTerm: String, page: Int) -> URLRequest? {
		guard let url = URL(string: self.urlString) else {
			return nil
		}

		var queryItems = self.defaultQueryItems
		queryItems["text"] = searchTerm
		queryItems["page"] = String(page)

		return URLRequest(url: url).encode(with: queryItems)
	}
}
