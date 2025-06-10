Sign Requests
=============

Sign Requests are used to request e-signatures on documents from signers.
A Sign Request can refer to one or more Box Files and can be sent to one or more Box Sign Request Signers.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

  - [Create Sign Request](#create-sign-request)
  - [List Sign Requests](#list-sign-requests)
  - [Get Sign Request by ID](#get-sign-request-by-id)
  - [Cancel Sign Request by ID](#cancel-sign-request-by-id)
  - [Resend Sign Request by ID](#resend-sign-request-by-id)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Create Sign Request
--------------------

To create a sign request, call
[`client.signRequests.create(signers:sourceFiles:parentFolder:parameters:completion:)`][create-sign-request]

You need to provide at least one file and up to ten files (from which the signing document will be created) with at least one signer to receive the Sign Request and a destination folder. You should use [`SignRequestCreateSourceFile`][box-sign-request-file]
,[`SignRequestCreateSigner`][box-sign-request-signer] and [`SignRequestCreateParentFolder`][box-sign-request-folder] types to provide the necessary data.

<!-- sample post_sign_requests -->
```swift

let signers = [SignRequestCreateSigner(email: "signer@mail.com", role: .approver)]
let sourceFiles = [SignRequestCreateSourceFile(id: "12345"), SignRequestCreateSourceFile(id: "34567")]
let parentFolder = SignRequestCreateParentFolder(id: "234")

client.signRequests.create(signers: signers, sourceFiles: sourceFiles, parentFolder: parentFolder) { (result: Result<SignRequest, BoxSDKError>) in
    guard case let .success(signRequest) = result else {
        print("Error creating sign request")
        return
    }

    print("Sign request \(signRequest.id) was created")
}
```

[`create`][create-sign-request] method allows you to specify optional parameters using the [`SignRequestCreateParameters`][sign-request-create-params]
object.

```swift

let signers = [SignRequestCreateSigner(email: "signer@mail.com", role: .approver)]
let sourceFiles = [SignRequestCreateSourceFile(id: "12345", fileVersionId: "5")]
let parentFolder = SignRequestCreateParentFolder(id: "234")
let params = SignRequestCreateParameters(
    isDocumentPreparationNeeded: true,
    emailSubject: "Sign Request from Acme",
    emailMessage: "Hello! Please sign the document below"
)

client.signRequests.create(signers: signers, sourceFiles: sourceFiles, parentFolder: parentFolder) { (result: Result<SignRequest, BoxSDKError>) in
    guard case let .success(signRequest) = result else {
        print("Error creating sign request")
        return
    }

    print("Sign request \(signRequest.id) was created")
}
```

If you set ```isDocumentPreparationNeeded``` flag to true, you need to visit ```prepareUrl``` before the Sign Request will be sent. 

[create-sign-request]: https://opensource.box.com/box-ios-sdk/Classes/SignRequestsModule.html#/s:6BoxSDK18SignRequestsModuleC6create7signers11sourceFiles12parentFolder10parameters10completionySayAA0C19RequestCreateSignerVG_SayAA0cnO10SourceFileVGAA0cno6ParentK0VAA0cnO10ParametersVSgys6ResultOyAA0cN0CAA0A8SDKErrorCGctF
[box-sign-request-file]: https://opensource.box.com/box-ios-sdk/Structs/SignRequestCreateSourceFile.html
[box-sign-request-signer]: https://opensource.box.com/box-ios-sdk/Structs/SignRequestCreateSigner.html
[box-sign-request-folder]: https://opensource.box.com/box-ios-sdk/Structs/SignRequestCreateParentFolder.html
[sign-request-create-params]: https://opensource.box.com/box-ios-sdk/Structs/SignRequestCreateParameters.html

List Sign Requests
------------------

To retrieve sign requests, call
[`client.signRequests.list(marker:limit:)`][list-sign-requests]. This method will return an iterator object, which is used to get the sign requests.

<!-- sample get_sign_requests -->
```swift
let iterator = client.signRequests.list()
iterator.next { results in
    switch results {
    case let .success(page):
        for signRequest in page.entries {
            print("Sign request \(signRequest.id)")
        }

    case let .failure(error):
        print(error)
    }
}
```

[list-sign-requests]: https://opensource.box.com/box-ios-sdk/Classes/SignRequestsModule.html#/s:6BoxSDK18SignRequestsModuleC4list6marker5limitAA14PagingIteratorCyAA0C7RequestCGSSSg_SiSgtF

Get Sign Request by ID
----------------------

To retrieve information about a sign request, call
[`client.signRequests.getById(id:)`][get-sign-request-by-id] with the ID of the sign request.

<!-- sample get_sign_requests_id -->
```swift
client.signRequests.getById(id: "1234") { (result: Result<SignRequest, BoxSDKError>) in
    guard case let .success(signRequest) = result else {
        print("Error getting sign request")
        return
    }

    print("Sign request \(signRequest.id)")
}
```

[get-sign-request-by-id]: https://opensource.box.com/box-ios-sdk/Classes/SignRequestsModule.html#/s:6BoxSDK18SignRequestsModuleC7getById2id10completionySS_ys6ResultOyAA0C7RequestCAA0A8SDKErrorCGctF

Cancel Sign Request by ID
-------------------------

To cancel a created sign request, call
[`client.signRequests.cancelById(id:, completion:)`][cancel-sign-request-by-id]

<!-- sample post_sign_requests_id_cancel -->
```swift
client.signRequests.cancelById(id: "1234") { (result: Result<SignRequest, BoxSDKError>) in
    guard case let .success(signRequest) = result else {
        print("Error cancelling sign request")
        return
    }

    print("Sign request \(signRequest.id) is cancelled")
}
```

[cancel-sign-request-by-id]: https://opensource.box.com/box-ios-sdk/Classes/SignRequestsModule.html#/s:6BoxSDK18SignRequestsModuleC10cancelById2id10completionySS_ys6ResultOyAA0C7RequestCAA0A8SDKErrorCGctF

Resend Sign Request by ID
-------------

To resend a sign request to all signers that have not signed it yet, call
[`client.signRequests.resendById(id:, completion:)`][resend-sign-request-by-id].
There is an 10-minute cooling-off period between re-sending reminder emails. If this method is called during the cooling-off period, a BoxAPIError will be thrown.

<!-- sample post_sign_requests_id_resend -->
```swift
client.signRequests.resendById(id: "1234") { result: Result<Void, BoxSDKError>} in
    guard case .success = result else {
        print("Error resending sign request")
        return
    }

    print("Sign request successfully resent")
}
```

[resend-sign-request-by-id]: https://opensource.box.com/box-ios-sdk/Classes/SignRequestsModule.html#/s:6BoxSDK18SignRequestsModuleC10resendById2id10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF
