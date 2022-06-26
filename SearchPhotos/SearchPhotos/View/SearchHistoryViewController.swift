//
//  SearchHistoryViewController.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import UIKit

protocol SearchHistoryViewControllerDelegate: AnyObject {
	func searchHistoryTextSelected(text: String)
}

class SearchHistoryViewController: UIViewController {

	//MARK: - IBOutlets

	@IBOutlet private weak var tableView: UITableView!

	//MARK: - Public properties

	weak var delegate: SearchHistoryViewControllerDelegate?

	//MARK: - Private properties

	private let viewModel = SearchHistoryViewModel()
	private let cellIndentifier = "SearchTermCell"

	//MARK: - Life cycle functions

	override func viewDidLoad() {
		super.viewDidLoad()
	}

}

extension SearchHistoryViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.viewModel.filteredSearchTerms.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIndentifier, for: indexPath)
		cell.textLabel?.text = self.viewModel.filteredSearchTerms[indexPath.row]
		return cell
	}

}

extension SearchHistoryViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.delegate?.searchHistoryTextSelected(text: self.viewModel.filteredSearchTerms[indexPath.row])
	}

}

extension SearchHistoryViewController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else {
			return
		}

		self.viewModel.updateData(text) {
			self.tableView.reloadData()
		}
	}

}
