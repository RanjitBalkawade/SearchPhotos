//
//  Photo.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class Photo: Codable {
	let id: String?
	let owner: String?
	let secret: String?
	let server: String?
	let farm: Int?
	let title: String?
	let ispublic: Int?
	let isfriend: Int?
	let isfamily: Int?
}
