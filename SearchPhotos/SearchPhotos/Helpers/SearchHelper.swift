//
//  SearchHelper.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

class SearchHelper {

	static let shared = SearchHelper()

	let searchTermsKey = "searchTerms"

	private var searchTerms: [String]? {
		get {
			guard let searchTerms = UserDefaults.standard.value(forKey: searchTermsKey) as? [String] else {
				return nil
			}
			return searchTerms
		}
		set {
			UserDefaults.standard.set(newValue, forKey: searchTermsKey)
			UserDefaults.standard.synchronize()
		}
	}

	func getSearchTerms() -> [String]? {
		self.searchTerms
	}

	func add(searchTerm: String) {
		guard searchTerm != "" else {
			return
		}

		guard var searchTerms = self.searchTerms else {
			self.searchTerms = [searchTerm]
			return
		}

		searchTerms.append(searchTerm)
		self.searchTerms = Array(Set(searchTerms))
	}
}
