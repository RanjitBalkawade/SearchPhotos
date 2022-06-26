//
//  SearchHistoryViewController.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import UIKit

class SearchHistoryViewModel {

	var filteredSearchTerms: [String] = []

	private var searchTerms: [String] {
		SearchHelper.shared.getSearchTerms() ?? []
	}

	init() {
		self.filteredSearchTerms = self.searchTerms
	}

	func updateData(_ searchText: String, completion: () -> Void) {
		let filteredSearchTerms = self.searchTerms.filter {
			$0.lowercased().contains(searchText.lowercased())
		}

		self.filteredSearchTerms = filteredSearchTerms.isEmpty ? self.searchTerms : filteredSearchTerms
		completion()
	}

}

class SearchHistoryViewController: UIViewController, UISearchResultsUpdating {

	@IBOutlet private weak var tableView: UITableView!

	private let viewModel = SearchHistoryViewModel()
	private let cellIndentifier = "SearchTermCell"


	override func viewDidLoad() {
		super.viewDidLoad()
	}

	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else {
			return
		}

		self.viewModel.updateData(text) {
			self.tableView.reloadData()
		}
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
