//
//  LazyImageView.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import UIKit

class LazyImageView: UIImageView {

	//MARK: - Statics properties

	static let imageCache = NSCache<NSString, UIImage>()

	//MARK: - Public Properties

	var imageUrlString: String?

	//MARK: - Public methods

	func loadImageUsingUrl(_ url: URL?) {
		guard let url = url else {
			return
		}

		imageUrlString = url.absoluteString
		image = nil

		if let imageFromCache = LazyImageView.imageCache.object(forKey: url.absoluteString as NSString) {
			self.image = imageFromCache
			return
		}

		URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
			if error != nil {
				print(error!)
				return
			}

			DispatchQueue.main.async(execute: { [weak self] in
				guard
					let data = data,
					let imageToCache = UIImage(data: data)
				else {
					return
				}

				if self?.imageUrlString == url.absoluteString {
					self?.image = imageToCache
				}

				LazyImageView.imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
			})

		}).resume()
	}

}

