//
//  HTTPURLResponse+extensions.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import Foundation

extension HTTPURLResponse {
	var hasSuccessStatusCode: Bool {
		return 200...299 ~= self.statusCode
	}
}
