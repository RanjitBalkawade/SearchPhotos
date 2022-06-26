//
//  Factory.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class Factory {

	static func createPhotosSearchGetService() -> PhotosSearchGetServiceProtocol {
		PhotosSearchGetService(urlString: Configuration.API.baseUrl)
	}

}
