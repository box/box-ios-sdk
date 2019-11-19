//
//  DevicePinsModule.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/27/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Provides [DevicePin](../Structs/DevicePin.html) management.
public class DevicePinsModule {

    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Retrieves a specified Device Pin.
    ///
    /// - Parameters:
    ///   - The Id of the Device Pin to retrieve.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Device Pin object or an error.
    public func get(
        devicePinId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<DevicePin>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/device_pinners/\(devicePinId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Retrieves all Device Pins for an enterprise.
    ///
    /// - Parameters:
    ///   - enterpriseId: The Id of the enterprise to retrieve Device Pins for.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - direction: This can be ASC or DESC.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listForEnterprise(
        enterpriseId: String,
        marker: String? = nil,
        limit: Int? = nil,
        direction: OrderDirection? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<DevicePin>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/enterprises/\(enterpriseId)/device_pinners", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit,
                "direction": direction,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Deletes the specified Device Pin.
    ///
    /// - Parameters:
    ///   - The Id of the Device Pin to delete.
    ///   - completion: An empty response will be returned upon successful deletion.
    public func delete(
        devicePinId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/device_pinners/\(devicePinId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
