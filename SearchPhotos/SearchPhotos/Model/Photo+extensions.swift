//
//  Photo+extensions.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

extension Photo {
	var imageURL: URL? {
		guard
			let farm = self.farm,
			let server = self.server,
			let id = self.id,
			let secret = self.secret
		else {
			return nil
		}

		var components = URLComponents()
		components.scheme = "http"
		components.host = "farm\(farm).static.flickr.com"
		components.path = "/\(server)/\(id)_\(secret).jpg"

		return components.url
	}
}
