//
//  ThumbnailViewCell.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import UIKit

class ThumbnailViewCell: UICollectionViewCell {

	//MARK: - IBOutlets

	@IBOutlet private weak var imageView: LazyImageView!

	//MARK: - Static properties

	static let reuseIdentifier = "ThumbnailCell"

	//MARK: - Life cycle functions

	override func prepareForReuse() {
		super.prepareForReuse()

		self.imageView.image = nil
	}

	//MARK: - Public functions

	func configureCell(viewModel: ThumbnailViewModel) {
		self.imageView.loadImageUsingUrl(viewModel.imageURL)
	}
}
