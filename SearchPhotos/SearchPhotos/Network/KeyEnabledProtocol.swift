//
//  KeyEnabledProtocol.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

protocol KeyEnabled {
	var key: String { get }
}

extension KeyEnabled {
	var key: String {
		Configuration.API.key
	}
}
