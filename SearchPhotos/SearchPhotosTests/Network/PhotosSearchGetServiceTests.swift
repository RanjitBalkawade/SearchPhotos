//
//  PhotosSearchGetServiceTests.swift
//  SearchPhotosTests
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import XCTest
@testable import SearchPhotos

class PhotosSearchGetServiceTests: XCTestCase {

	var sut: PhotosSearchGetService!
	let urlString = "https://www.haha.com"

	override func setUp() {
		self.sut = PhotosSearchGetService(
			urlString: self.urlString,
			session: MockURLProtocol.getSessionWithMockURLProtocol()
		)
	}

	override func tearDown() {
		self.sut = nil
		MockURLProtocol.stubResponseData = nil
		MockURLProtocol.error = nil
		MockURLProtocol.response = nil
	}

	func testPhotosSearchGetService_whenGivenSuccessfulResponse_ShouldReturnSuccess() {
		//Arrange
		MockURLProtocol.stubResponseData = "{\"photos\": {\"photo\": [{\"id\": \"0\",\"secret\": \"0\",\"server\":\"0\",\"farm\":0}]}}".data(using: .utf8)
		MockURLProtocol.response = HTTPURLResponse(url: URL(string: self.urlString)!,
												   statusCode: 200,
												   httpVersion: nil,
												   headerFields: nil)!

		let expectation = self.expectation(description: "PhotosSearchGetService response expectation")
		//Act
		self.sut.getPhotos(with: "", page: 0) { (result) in
			//Assert
			switch result {
			case .success(let photosSearchGetResponse):
				XCTAssertEqual(photosSearchGetResponse.photos!.photo!.count, 1, "should have return data")
				expectation.fulfill()

			case .failure(_):
				XCTFail("should have return data, but it has return error")
				expectation.fulfill()
			}
		}
		self.wait(for: [expectation], timeout: 3)
	}

	func testPhotosSearchGetService_WhenJsonDecodingFails_shouldReturnDecodingError() {
		//Arrange
		let expectation = self.expectation(description: "PhotosSearchGetService decoding Failure Expectation")

		MockURLProtocol.stubResponseData = "".data(using: .utf8)
		MockURLProtocol.response = HTTPURLResponse(url: URL(string: self.urlString)!,
												   statusCode: 200,
												   httpVersion: nil,
												   headerFields: nil)!
		//Act
		self.sut.getPhotos(with: "", page: 0) { (result) in
			//Assert
			switch result {
			case .success(_):
				XCTFail("should have return decoding error, but it has return success")
				expectation.fulfill()

			case .failure(let error):
				XCTAssertEqual(error, DataResponseError.decoding, "should have return \(String(describing: DataResponseError.decoding.errorDescription)), but it has return \(String(describing: error.errorDescription))")
				expectation.fulfill()
			}
		}
		self.wait(for: [expectation], timeout: 3)
	}


	func testPhotosSearchGetService_whenNetworkErrorOccurs_shouldReturnNetworkError() {
		//Arrange
		let expectation = self.expectation(description: "PhotosSearchGetService network error expectation")
		MockURLProtocol.response = HTTPURLResponse(url: URL(string: self.urlString)!,
												   statusCode: 400,
												   httpVersion: nil,
												   headerFields: nil)!
		MockURLProtocol.error = DataResponseError.network
		//Act
		self.sut.getPhotos(with: "", page: 0) { (result) in
			//Assert
			switch result {
			case .success(_):
				XCTFail("should have return network error, but it has return success")
				expectation.fulfill()

			case .failure(let error):
				XCTAssertEqual(error, DataResponseError.network, "should have return \(String(describing: DataResponseError.network.errorDescription)), but it has return \(String(describing: error.errorDescription))")
				expectation.fulfill()
			}
		}
		self.wait(for: [expectation], timeout: 3)
	}

	func testPhotosSearchGetService_WhenInvalidUrlStringGiven_ShouldReturnInvalidUrlRequestError() {
		//Arrrange
		let sut = PhotosSearchGetService(urlString: "", session: MockURLProtocol.getSessionWithMockURLProtocol())
		let expectation = self.expectation(description: "PhotosSearchGetService response expectation")

		//Act
		sut.getPhotos(with: "", page: 0) { (result) in
			//Assert
			switch result {
			case .success(_):
				XCTFail("should have return invalidRequest error, but it has return success")
				expectation.fulfill()

			case .failure(let error):
				XCTAssertEqual(error, DataResponseError.invalidURLRequest, "should have return \(String(describing: DataResponseError.invalidURLRequest.errorDescription)), but it has return \(String(describing: error.errorDescription))")
				expectation.fulfill()
			}
		}
		self.wait(for: [expectation], timeout: 3)
	}

}

