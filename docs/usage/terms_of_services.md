Terms of Services
=================

Terms of Service are custom objects that the admin of an enterprise can configure. This will prompt the end user to accept/re-accept or decline the custom Terms of Service for custom applications built on Box Platform.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Terms of Service By ID](#get-terms-of-service-by-id)
- [Create Terms of Service](#create-terms-of-service)
- [Update Terms of Service](#update-terms-of-service)
- [List Terms of Services for an Enterprise](#list-terms-of-services-for-an-enterprise)
- [Create User Status on Terms of Service](#create-user-status-on-terms-of-service)
- [Update User Status of Terms of Service](#update-user-status-of-terms-of-service)
- [Get User Status for Terms of Service](#get-user-status-for-terms-of-service)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Terms of Service By ID
--------------------------

To retrieve information about a terms of service, call
[`client.termsOfService.get(tosId:fields:completion)`][get-tos] with the ID of the terms of service. You can control which fields are returned in the resulting `Terms of Service` object by passing the `fields` parameter.

<!-- sample get_terms_of_services_id -->   
```swift
client.termsOfService.get(
    tosID: "12345"
) { (result: Result<TermsOfService, BoxSDKError>) in
    guard case let .success(termsOfService) = result else {
        print("Error getting terms of service information")
        return
    }
    print("Terms of Service with id: \(termsOfService.id) was retrieved")
}
```

[get-tos]: https://opensource.box.com/box-ios-sdk/Classes/TermsOfServicesModule.html#/s:6BoxSDK21TermsOfServicesModuleC3get5tosId6fields10completionySS_SaySSGSgys6ResultOyAA0cD7ServiceCAA0A8SDKErrorCGctF

Create Terms of Service
-----------------------

To create a terms of service, call
[`client.termsOfService.create(status:tosType:text:fields:completion`][create-tos]. You can control which fields are returned in the resulting `Terms of Service` object by passing the `fields` parameter.

<!-- sample post_terms_of_services -->   
```swift
client.termsOfService.create(
    status: .enabled,
    tosType: .managed,
    text: "Test Terms of Service"
) { (result: Result<TermsOfService, BoxSDKError>) in
    guard case let .success(termsOfService) = result else {
        print("Error creating terms of service")
        return
    }
    print("Terms of Service with id: \(termsOfService.id) was created")
}
```

[create-tos]: https://opensource.box.com/box-ios-sdk/Classes/TermsOfServicesModule.html#/s:6BoxSDK21TermsOfServicesModuleC6create6status7tosType4text6fields10completionyAA0cD13ServiceStatusO_AA0cdnJ0OSSSaySSGSgys6ResultOyAA0cdN0CAA0A8SDKErrorCGctF

Update Terms of Service
-----------------------

To update a terms of service, call [`client.termsOfService.update(tosId:text:status:fields:completion)`][update-tos] with the ID of the terms of service to update. You can control which fields are returned in the resulting `Terms of Service` object by passing the `fields` parameter.

<!-- sample put_terms_of_services_id -->   
```swift
client.termsOfService.update(
    tosId: "12345",
    text: "Updated Text String",
    status: TermsOfServiceStatus.enabled
) { (result: Result<TermsOfService, BoxSDKError>) in
    guard calse let .success(termsOfService) = result else {
        print("Error updating terms of service")
        return
    }
    print("Terms of Service with id: \(termsOfService.id) was updated with text: \(termsOfService.text)")
}
```

[update-tos]: https://opensource.box.com/box-ios-sdk/Classes/TermsOfServicesModule.html#/s:6BoxSDK21TermsOfServicesModuleC6update5tosId4text6status6fields10completionySS_SSAA0cD13ServiceStatusOSaySSGSgys6ResultOyAA0cdN0CAA0A8SDKErrorCGctF

List Terms of Services for an Enterprise
----------------------------------------

To retrieve a list of terms of services for an enterprise, call [`client.termsOfService.listForEnterprise(tosType:fields:completion)`][list-tos] with the type of terms of service to retrieve. If left nil, then terms of services of both types, `managed` and `external` will be retrieved. You can control which fields are returned in the resulting `Terms of Service` objects by passing the `fields` parameter.

<!-- sample get_terms_of_services -->   
```swift
let termsOfServiceItems = client.termsOfService.listForEnterprise()

print("Terms of Service with ID \(termsOfServiceItems[0].id) and Terms of Service with ID \(termsOfServiceItems[1].id) was retrieved.")
```

[list-tos]: https://opensource.box.com/box-ios-sdk/Classes/TermsOfServicesModule.html#/s:6BoxSDK21TermsOfServicesModuleC17listForEnterprise7tosType6fields10completionyAA0cd7ServiceK0OSg_SaySSGSgys6ResultOySayAA0cdN0CGAA0A8SDKErrorCGctF

Create User Status on Terms of Service
--------------------------------------

To accept or decline a terms of service for a user who has never 
accepted/declined this terms of service before call [`client.termsOfService.createUserStatus(tosId:isAccepted:userId:fields:completion)`][create-user-status]. You can control which fields are returned in the resulting `Terms of Service User Status` object by passing the `fields` parameter.

<!-- sample post_terms_of_service_user_statuses -->   
```swift
client.termsOfService.createUserStatus(
    tosId: "12345",
    isAccepted: true,
    userId: "54321"
) { (result: Result<TermsOfServiceUserStatus, BoxSDKError>) in
    guard case let .success(userStatus) = result else {
        print("Error accepting Terms of Service for new user")
        return
    }

    print("User status for accepting of Terms of Service is \(userStatus.isAccepted)")
}
```

[create-user-status]: https://opensource.box.com/box-ios-sdk/Classes/TermsOfServicesModule.html#/s:6BoxSDK21TermsOfServicesModuleC16createUserStatus5tosId10isAccepted04userK06fields10completionySS_SbSSSgSaySSGSgys6ResultOyAA0cd7ServicehI0CAA0A8SDKErrorCGctF

Update User Status of Terms of Service
--------------------------------------

To update a user status on a terms of service call [`client.termsOfService.updateUserStatus(userStatusId:isAccepted:fields:completion)`][update-user-status]. You can control which fields are returned in the resulting `Terms of Service User Status` object by passing the `fields` parameter.

<!-- sample put_terms_of_service_user_statuses -->
```swift
client.termsOfService.updateUserStatus(
    userStatusId: "12345",
    isAccepted: true
) { (result: Result<TermsOfServiceUserStatus, BoxSDKError>) in
    guard case let .success(userStatus) = result else {
        print("Error updating Terms of Service User Status")
        return
    }

    print("User status for updating of Terms of Service is \(userStatus.isAccepted)")
}
```

[update-user-status]: https://opensource.box.com/box-ios-sdk/Classes/TermsOfServicesModule.html#/s:6BoxSDK21TermsOfServicesModuleC16updateUserStatus04userI2Id10isAccepted6fields10completionySS_SbSaySSGSgys6ResultOyAA0cd7ServicehI0CAA0A8SDKErrorCGctF

Get User Status for Terms of Service
------------------------------------

To retrieve the user status for a user on a terms of service, call [`client.termsOfService.getUserStatus(tosId:userId:fields:completion)`][get-user-status] with the ID of the `Terms of Service` object and the ID of the user.

<!-- sample get_terms_of_service_user_statuses_id -->
```swift
client.termsOfService.getUserStatus(
    tosId: "12345",
    userId: "54321"
) { (result: Result<TermsOfServiceUserStatus, BoxSDKError>) in
    guard case let .success(userStatus) = result else {
        print("Error retrieving user status for Terms of Service")
        return
    }
    
    print("User status with ID \(userStatus.id) was retrieved")
}
```
[get-user-status]: https://opensource.box.com/box-ios-sdk/Classes/TermsOfServicesModule.html#/s:6BoxSDK21TermsOfServicesModuleC13getUserStatus5tosId04userK06fields10completionySS_SSSgSaySSGSgys6ResultOyAA0cd7ServicehI0CAA0A8SDKErrorCGctF