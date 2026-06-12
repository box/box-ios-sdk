//
//  FakeNetworkAgent.swift
//  BoxSDKTests-iOS
//
//  Copyright © 2026 Box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble

func expectRequest(
    _ request: BoxRequest,
    method: HTTPMethod,
    host: String,
    path: String,
    urlEncodedBody expectedBody: [String: String]? = nil,
    unorderedValueKeys: Set<String> = []
) {
    expect(request.httpMethod).to(equal(method))
    expect(request.url.host).to(equal(host))
    expect(request.url.path).to(equal(path))

    guard let expectedBody = expectedBody else {
        return
    }

    guard case let .urlencodedForm(actualBody) = request.body else {
        fail("Expected URL-encoded request body")
        return
    }

    expect(actualBody.keys.sorted()).to(equal(expectedBody.keys.sorted()))
    for (key, expectedValue) in expectedBody {
        guard let actualValue = actualBody[key] else {
            fail("Expected request body to contain \(key)")
            continue
        }

        if unorderedValueKeys.contains(key) {
            expect(Set(actualValue.split(separator: " "))).to(equal(Set(expectedValue.split(separator: " "))))
        }
        else {
            expect(actualValue).to(equal(expectedValue))
        }
    }
}

func makeResponse(request: BoxRequest, fixture: String, statusCode: Int, headers: [String: String] = [:]) -> BoxResponse {
    // swiftlint:disable:next force_unwrapping
    let fixtureURL = URL(fileURLWithPath: TestAssets.path(forResource: fixture)!)
    // swiftlint:disable:next force_try
    let data = try! Data(contentsOf: fixtureURL)
    return makeResponse(request: request, data: data, statusCode: statusCode, headers: headers)
}

func makeResponse(request: BoxRequest, data: Data, statusCode: Int, headers: [String: String] = [:]) -> BoxResponse {
    let urlResponse = HTTPURLResponse(
        url: request.url,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: headers
    )
    return BoxResponse(request: request, body: data, urlResponse: urlResponse)
}

func makeFailure(request: BoxRequest, jsonObject: [String: Any], statusCode: Int) -> Result<BoxResponse, BoxSDKError> {
    // swiftlint:disable:next force_try
    let data = try! JSONSerialization.data(withJSONObject: jsonObject)
    return makeFailure(request: request, data: data, statusCode: statusCode)
}

func makeFailure(request: BoxRequest, data: Data, statusCode: Int) -> Result<BoxResponse, BoxSDKError> {
    let response = makeResponse(request: request, data: data, statusCode: statusCode)
    return .failure(BoxAPIError(request: response.request, response: response))
}

class FakeNetworkAgent: NetworkAgentProtocol {
    var sendHandler: ((BoxRequest) -> Result<BoxResponse, BoxSDKError>)?

    func send(request: BoxRequest, completion: @escaping Callback<BoxResponse>) {
        guard let sendHandler = sendHandler else {
            completion(.failure(BoxSDKError(message: "No fake response configured")))
            return
        }

        completion(sendHandler(request))
    }
}
