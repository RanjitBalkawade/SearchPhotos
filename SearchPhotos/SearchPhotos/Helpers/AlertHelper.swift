//
//  AlertHelper.swift
//  SearchPhotos
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import UIKit

class AlertHelper {

	//MARK: - Public functions

	static func getNoDataAlert() -> UIAlertController {
		let alert = UIAlertController(
			title: "",
			message: "Information not available, please try again.",
			preferredStyle: .alert
		)

		alert.addAction(UIAlertAction(title: "OK", style: .cancel) { (action) in
			alert.dismiss(animated: true, completion: nil)
		})

		return alert
	}
}
