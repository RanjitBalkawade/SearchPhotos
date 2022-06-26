//
//  GetServiceTests.swift
//  SearchPhotosTests
//
//  Created by Ranjeet Balkawade on 26/06/2022.
//

import XCTest
@testable import SearchPhotos

class MockCodable: Codable {
	let id: String?
}

class GetServiceTests: XCTestCase {

	var sut: GetService<MockCodable>!
	let urlString = "https://www.haha.com"

	override func setUp() {
		self.sut = GetService(urlString: self.urlString, session: MockURLProtocol.getSessionWithMockURLProtocol())
	}

	override func tearDown() {
		self.sut = nil
		MockURLProtocol.stubResponseData = nil
		MockURLProtocol.error = nil
		MockURLProtocol.response = nil
	}

	func testGetService_whenPathComponentGiven_ShouldAppendToUrl() {
		//Act
		let url = self.sut.urlRequestWithPathComponents(urlString: self.sut.urlString, pathComponents: ["a", "b"])
		//Assert
		XCTAssertEqual(url?.absoluteString, self.urlString+"/a"+"/b", "Should have appended pathComponents")
	}

	func testGetService_whenGivenSuccessfulResponse_ShouldReturnSuccess() {
		//Arrange
		MockURLProtocol.stubResponseData = "{\"id\": \"abc\"}".data(using: .utf8)
		MockURLProtocol.response = HTTPURLResponse(url: URL(string: self.urlString)!,
												   statusCode: 200,
												   httpVersion: nil,
												   headerFields: nil)!
		let expectation = self.expectation(description: "GetService response expectation")
		//Act
		self.sut.execute(urlRequest: URLRequest(url: URL(string: self.urlString)!)) { (result) in
			//Assert
			switch result {
			case .success(let mockCodable):
				XCTAssertEqual(mockCodable.id, "abc", "should have return data")
				expectation.fulfill()

			case .failure(_):
				XCTFail("should have return data, but it has return error")
				expectation.fulfill()
			}
		}
		self.wait(for: [expectation], timeout: 3)
	}

	func testArtGetService_WhenJsonDecodingFails_shouldReturnDecodingError() {
		//Arrange
		let expectation = self.expectation(description: "GetService decoding Failure Expectation")

		MockURLProtocol.stubResponseData = "".data(using: .utf8)
		MockURLProtocol.response = HTTPURLResponse(url: URL(string: self.urlString)!,
												   statusCode: 200,
												   httpVersion: nil,
												   headerFields: nil)!
		//Act
		self.sut.execute(urlRequest: URLRequest(url: URL(string: self.urlString)!)) { (result) in
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

	func testGetService_whenNetworkErrorOccurs_shouldReturnNetworkError() {
		//Arrange
		let expectation = self.expectation(description: "GetService network error expectation")
		MockURLProtocol.response = HTTPURLResponse(url: URL(string: self.urlString)!,
												   statusCode: 400,
												   httpVersion: nil,
												   headerFields: nil)!
		MockURLProtocol.error = DataResponseError.network
		//Act
		self.sut.execute(urlRequest: URLRequest(url: URL(string: self.urlString)!)) { (result) in
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

}

