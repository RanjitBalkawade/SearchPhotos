//
//  PhotosSearchGetResponse.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class PhotosSearchGetResponse: Codable {
	let photos: Photos?
}

class Photos: Codable {
	let page: Int?
	let pages: Int?
	let photo: [Photo]?
}
