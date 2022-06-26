//
//  HomeViewModel.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class HomeViewModel {

	var thumbnailViewModels: [ThumbnailViewModel] = []

	private let service: PhotosSearchGetServiceProtocol
	private var photos: [Photo] = []
	private var page = 0

	init(service: PhotosSearchGetServiceProtocol) {
		self.service = service
	}

	//MARK: - Public functions

	func loadData(with query: String, completionHandler: ((Error?) -> Void)?) {
		self.service.getPhotos(with: query, page: self.page) { [weak self] (result) in
			switch result {
			case .success(let photosSearchGetResponse):
				self?.bindData(photosSearchGetResponse)
				completionHandler?(nil)

			case .failure(let error):
				completionHandler?(error)
			}
		}
	}

	func clearData() {
		self.photos.removeAll()
		self.thumbnailViewModels.removeAll()
		self.page = 0
	}

	//MARK: - Private functions

	private func bindData(_ data: PhotosSearchGetResponse) {
		let photos = data.photos?.photo ?? []
		self.photos.append(contentsOf: photos)
		self.thumbnailViewModels.append(contentsOf: photos.map { ThumbnailViewModel(imageURL: $0.imageURL) })
		self.page += 1
	}

}
