//
//  DataResponseError.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

enum DataResponseError: Error {
	case network
	case decoding
	case noData
	case invalidURLRequest

	var errorDescription: String? {
		switch self {
		case .network:
			return "Network error"
		case .decoding:
			return "Parsing error"
		case .noData:
			return "No data"
		case .invalidURLRequest:
			return "Invalid URLRequest"
		}
	}
}
