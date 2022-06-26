//
//  HomeViewController.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import UIKit

class ResultsViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .red
	}
}

class ListViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDataSource, UICollectionViewDelegate {

	//MARK: - IBOutlets

	@IBOutlet private weak var collectionView: UICollectionView!

	// MARK: - Private properties

	let searchController = UISearchController(searchResultsController: ResultsViewController())

	private let itemsPerRow = 2.0
	private let reuseIdentifier = "ThumbnailCell"
	private let insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.searchController = self.searchController
		self.searchController.searchResultsUpdater = self

		self.collectionView.delegate = self
		self.collectionView.dataSource = self
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		self.collectionView.collectionViewLayout.invalidateLayout()
		self.searchController.showsSearchResultsController = false
	}

	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else {
			return
		}

		print(text)
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		10
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ThumbnailViewCell else {
			return ThumbnailViewCell()
		}

		cell.backgroundColor = .red

		return cell
	}

}


extension ListViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let padding = insets.left * (itemsPerRow + 1)
		let totalLength = collectionView.frame.width - padding
		let length = floor(totalLength / itemsPerRow)

		return CGSize(width: length, height: length)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return insets
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return insets.left
	}
}
