//
//  SearchHistoryViewModel.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class SearchHistoryViewModel {

	//MARK: - Public properties

	var filteredSearchTerms: [String] = []

	//MARK: - Private properties

	private var searchTerms: [String] {
		SearchHelper.shared.getSearchTerms() ?? []
	}

	//MARK: - Initializer

	init() {
		self.filteredSearchTerms = self.searchTerms
	}

	//MARK: - Public functions

	func updateData(_ searchText: String, completion: () -> Void) {
		let filteredSearchTerms = self.searchTerms.filter {
			$0.lowercased().contains(searchText.lowercased())
		}

		self.filteredSearchTerms = filteredSearchTerms.isEmpty ? self.searchTerms : filteredSearchTerms
		completion()
	}

}
