//
//  ThumbnailViewModel.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class ThumbnailViewModel {

	//MARK: - Public properties

	var imageURL: URL?

	//MARK: - Initializer

	init(imageURL: URL?) {
		self.imageURL = imageURL
	}
}
