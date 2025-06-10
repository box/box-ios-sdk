//
//  SignRequestSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 14/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestSpecs: QuickSpec {

    override class func spec() {
        describe("SignRequest") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FullSignRequest.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let signRequest = try SignRequest(json: jsonDict)

                        expect(signRequest.id).to(equal("12345"))
                        expect(signRequest.status).to(equal(.converting))
                        expect(signRequest.isDocumentPreparationNeeded).to(equal(true))
                        expect(signRequest.areTextSignaturesEnabled).to(equal(true))
                        expect(signRequest.areRemindersEnabled).to(equal(true))
                        expect(signRequest.emailSubject).to(equal("Sign Request from Acme"))
                        expect(signRequest.emailMessage).to(equal("Hello! Please sign the document below"))
                        expect(signRequest.externalId).to(equal("123"))
                        expect(signRequest.daysValid).to(equal(2))
                        expect(signRequest.autoExpireAt?.iso8601).to(equal("2021-04-26T08:12:13Z"))
                        expect(signRequest.redirectUrl).to(equal("https://box.com/redirect_url"))
                        expect(signRequest.declinedRedirectUrl).to(equal("https://box.com/declined_redirect_url"))
                        expect(signRequest.templateId).to(equal("123075213-af2c8822-3ef2-4952-8557-52d69c2fe9cb"))
                        expect(signRequest.name).to(equal("Contract.pdf"))
                        expect(signRequest.signatureColor).to(equal(.blue))
                        expect(signRequest.isPhoneVerificationRequiredToView).to(equal(true))
                        expect(signRequest.signers[0].email).to(equal("example@gmail.com"))
                        expect(signRequest.signers[0].role).to(equal(.signer))
                        expect(signRequest.signers[0].isInPerson).to(equal(true))
                        expect(signRequest.signers[0].order).to(equal(2))
                        expect(signRequest.signers[0].loginRequired).to(equal(true))
                        expect(signRequest.signers[0].verificationPhoneNumber).to(equal("6314578901"))
                        expect(signRequest.signers[0].password).to(equal("SecretPassword123"))
                        expect(signRequest.signers[0].signerGroupId).to(equal("cd4ff89-8fc1-42cf-8b29-1890dedd26d7"))
                        expect(signRequest.signers[0].embedUrlExternalUserId).to(equal("1234"))
                        expect(signRequest.signers[0].hasViewedDocument).to(equal(true))
                        expect(signRequest.signers[0].embedUrl).to(equal("https://example.com"))
                        expect(signRequest.signers[0].redirectUrl).to(equal("https://box.com/redirect_url_signer_1"))
                        expect(signRequest.signers[0].declinedRedirectUrl).to(equal("https://box.com/declined_redirect_url_signer_1"))
                        expect(signRequest.signers[0].signerDecision?.type).to(equal(.signed))
                        expect(signRequest.signers[0].signerDecision?.finalizedAt?.iso8601).to(equal("2021-04-26T08:12:13Z"))
                        expect(signRequest.signers[0].inputs?[0].documentTagId).to(equal("1234"))
                        expect(signRequest.signers[0].inputs?[0].type).to(equal(.text))
                        expect(signRequest.signers[0].inputs?[0].textValue).to(equal("text"))
                        expect(signRequest.signers[0].inputs?[0].pageIndex).to(equal(4))
                        expect(signRequest.signers[0].inputs?[0].contentType).to(equal(.text))
                        expect(signRequest.sourceFiles[0].id).to(equal("12345"))
                        expect(signRequest.sourceFiles[0].etag).to(equal("1"))
                        expect(signRequest.sourceFiles[0].name).to(equal("Contract.pdf"))
                        expect(signRequest.sourceFiles[0].fileVersion?.id).to(equal("12345"))
                        expect(signRequest.parentFolder.id).to(equal("12345"))
                        expect(signRequest.parentFolder.name).to(equal("Contracts"))
                        expect(signRequest.parentFolder.etag).to(equal("1"))
                        expect(signRequest.prefillTags?[0].documentTagId).to(equal("1234"))
                        expect(signRequest.prefillTags?[0].textValue).to(equal("text"))
                        expect(signRequest.signFiles?.files?[0].id).to(equal("12345"))
                        expect(signRequest.signFiles?.files?[0].name).to(equal("Contract.pdf"))
                        expect(signRequest.signFiles?.files?[0].etag).to(equal("1"))
                        expect(signRequest.signFiles?.isReadyForDownload).to(equal(true))
                        expect(signRequest.signingLog?.id).to(equal("12345"))
                        expect(signRequest.signingLog?.name).to(equal("Contract Log.pdf"))
                        expect(signRequest.signingLog?.etag).to(equal("1"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }

        describe("SignRequestStatus") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(SignRequestStatus.converting).to(equal(SignRequestStatus(SignRequestStatus.converting.description)))
                    expect(SignRequestStatus.created).to(equal(SignRequestStatus(SignRequestStatus.created.description)))
                    expect(SignRequestStatus.sent).to(equal(SignRequestStatus(SignRequestStatus.sent.description)))
                    expect(SignRequestStatus.viewed).to(equal(SignRequestStatus(SignRequestStatus.viewed.description)))
                    expect(SignRequestStatus.signed).to(equal(SignRequestStatus(SignRequestStatus.signed.description)))
                    expect(SignRequestStatus.cancelled).to(equal(SignRequestStatus(SignRequestStatus.cancelled.description)))
                    expect(SignRequestStatus.declined).to(equal(SignRequestStatus(SignRequestStatus.declined.description)))
                    expect(SignRequestStatus.errorConverting).to(equal(SignRequestStatus(SignRequestStatus.errorConverting.description)))
                    expect(SignRequestStatus.errorSending).to(equal(SignRequestStatus(SignRequestStatus.errorSending.description)))
                    expect(SignRequestStatus.expired).to(equal(SignRequestStatus(SignRequestStatus.expired.description)))
                    expect(SignRequestStatus.finalizing).to(equal(SignRequestStatus(SignRequestStatus.finalizing.description)))
                    expect(SignRequestStatus.errorFinalizing).to(equal(SignRequestStatus(SignRequestStatus.errorFinalizing.description)))

                    expect(SignRequestStatus.customValue("custom value")).to(equal(SignRequestStatus("custom value")))
                }
            }
        }
    }
}
