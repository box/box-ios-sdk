Device Pins
===========

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Device Pin Info](#get-device-pin-info)
- [Get Device Pins for Enterprise](#get-device-pins-for-enterprise)
- [Delete Device Pin](#delete-device-pin)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


Get Device Pin Info
-------------------

To retrieve information about a device pin, call
[`client.devicepins.get(devicePinId: String, fields: [String]?, completion: @escaping Callback<DevicePin>)`][get-device-pin] with the ID
of the device pin. You can control which fields are returned on the resulting `Device Pin` object by passing the desired field names in the optional `fields` parameter.

<!-- sample get_device_pinners_id -->
```swift
client.devicePins.get(devicePinId: "11111", fields: ["product_name"]) { (result: Result<DevicePin, BoxSDKError>) in
    guard case let .success(devicePin) = result else {
        print("Error retrieving device pin information")
        return
    }

    print("Device Pin for \(devicePin.productName) was created at \(devicePin.createdAt)")
}
```

[get-device-pin]: https://opensource.box.com/box-ios-sdk/Classes/DevicePinsModule.html#/s:6BoxSDK16DevicePinsModuleC3get11devicePinId6fields10completionySS_SaySSGSgys6ResultOyAA0cH0CAA0A8SDKErrorCGctF

Get Device Pins for Enterprise
------------------------------

To retrieve information about the device pins active for the enterprise, call [`client.devicePins.listForEnterprise(enterpriseId: String, marker: String?, limit: Int?, direction: OrdeDirection?, fields: [String]?)`][get-device-pins] with the ID of the enterpise. This method will return an iterator object in the completion, which is used to retrieve device pins for the enterprise.

<!-- sample get_enterprise_id_device_pinners -->
```swift
client.devicePins.listForEnterprise(enterpriseId: "12345", direction: .ascending) { results in 
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(devicePin):
                    print("Device type: \(devicePin.productName)")
                case let .failure(error):
                    print(error)
                }
            }
        }
    case let .failure(error):
        print(error)
    }
}
```

[get-device-pins]: https://opensource.box.com/box-ios-sdk/Classes/DevicePinsModule.html#/s:6BoxSDK16DevicePinsModuleC17listForEnterprise12enterpriseId6marker5limit9direction6fields10completionySS_SSSgSiSgAA14OrderDirectionOSgSaySSGSgys6ResultOyAA14PagingIteratorCyAA0C3PinCGAA0A8SDKErrorCGctF


Delete Device Pin
-----------------

To delete a device pin, call [`client.devicePins.delete(devicePinId: String, completion: @escaping: Callback<Void>)`][delete-device-pin] with the ID of the device pin to delete. 

<!-- sample delete_device_pinners_id -->
```swift
client.devicePins.delete(devicePinId: "12345") { result: Result<Void, BoxSDKError> in
    guard case .success = result else {
        print("Error deleting device pin")
        return
    }

    print("Device Pin successfully deleted")
}
```

[delete-device-pin]: https://opensource.box.com/box-ios-sdk/Classes/DevicePinsModule.html#/s:6BoxSDK16DevicePinsModuleC6delete11devicePinId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF