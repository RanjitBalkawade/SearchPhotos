//
//  LazyImageViewTests.swift
//  SearchPhotosTests
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import XCTest
@testable import SearchPhotos

class LazyImageViewTests: XCTestCase {

	var sut: LazyImageView!
	var url: URL!

	override func setUp() {
		self.sut = LazyImageView()
		let path = Bundle(for: LazyImageViewTests.self).path(forResource: "SampleImage", ofType: "png")
		self.url = URL(fileURLWithPath: path!)
	}

	override func tearDown() {
		self.sut = nil
	}

	func test_onceImageLoadShouldStoreInCache() {
		//Arrange
		LazyImageView.imageCache.removeAllObjects()
		let expectation = self.expectation(description: "Cache Image Expectation")

		//Act
		self.sut.loadImageUsingUrl(self.url)

		//Assert
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			let imageFromCache = LazyImageView.imageCache.object(forKey: self.url.absoluteString as NSString)
			XCTAssertNotNil(imageFromCache, "Image should have been stored in a cache")
			expectation.fulfill()
		}
		self.wait(for: [expectation], timeout: 3)
	}
}
