//
//  HomeViewController.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

	//MARK: - IBOutlets

	@IBOutlet private weak var collectionView: UICollectionView!

	// MARK: - Private properties

	private var searchController: UISearchController?
	private let itemsPerRow = 2.0
	private let insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
	private let viewModel = HomeViewModel(service: Factory.createPhotosSearchGetService())

	private var searchTerm: String? {
		didSet {
			self.viewModel.clearData()
			self.loadData()
			self.setTitle()
		}
	}

	let searchHistoryViewController: SearchHistoryViewController = {
		let storyboard = UIStoryboard(name: "Main", bundle: .main)

		guard
			let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: SearchHistoryViewController.self)) as? SearchHistoryViewController
		else {
			return SearchHistoryViewController()
		}
		return viewController
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.searchController = UISearchController(searchResultsController: self.searchHistoryViewController)
		self.navigationItem.searchController = self.searchController
		self.searchController?.searchResultsUpdater = self.searchHistoryViewController
		self.searchController?.searchBar.delegate = self

		self.collectionView.delegate = self
		self.collectionView.dataSource = self
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		self.collectionView.collectionViewLayout.invalidateLayout()

	}

	private func loadData() {
		guard let searchTerm = self.searchTerm else {
			return
		}

		self.viewModel.loadData(with: searchTerm) { [weak self] error in
			if error != nil {
				self?.present(AlertHelper.getNoDataAlert(), animated: true, completion: nil)
			} else {
				self?.collectionView.reloadData()
			}
		}
	}

	private func setTitle() {
		if let searchTerm = self.searchTerm {
			self.title = "Search results for '\(searchTerm)'"
		} else {
			self.title = nil
		}
	}

	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		self.searchController?.isActive = true
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		defer {
			self.searchController?.isActive = false
		}

		guard let searchTerm = searchBar.text else {
			return
		}

		self.searchTerm = searchTerm
		SearchHelper.shared.add(searchTerm: searchTerm)
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.viewModel.thumbnailViewModels.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailViewCell.reuseIdentifier, for: indexPath) as? ThumbnailViewCell else {
			return ThumbnailViewCell()
		}

		cell.configureCell(viewModel: self.viewModel.thumbnailViewModels[indexPath.row])

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard self.canLoadMoreData(indexPath.row) else {
			return
		}

		self.loadData()
	}

	private func canLoadMoreData(_ visibleItemIndex: Int) -> Bool {
		visibleItemIndex == self.viewModel.thumbnailViewModels.count - 10
	}

}


extension HomeViewController: UICollectionViewDelegateFlowLayout {

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
